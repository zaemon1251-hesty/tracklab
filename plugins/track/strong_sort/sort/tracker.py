# vim: expandtab:ts=4:sw=4
from __future__ import absolute_import
import numpy as np
from . import kalman_filter
from . import linear_assignment
from . import iou_matching
from . import oks_matching
from .track import Track
import logging

from ..utils.ecc import ECC, get_matrix

log = logging.getLogger(__name__)


class Tracker:
    """
    This is the multi-target tracker.
    Parameters
    ----------
    metric : nn_matching.NearestNeighborDistanceMetric
        A distance metric for measurement-to-track association.
    max_age : int
        Maximum number of missed misses before a track is deleted.
    n_init : int
        Number of consecutive detections before the track is confirmed. The
        track state is set to `Deleted` if a miss occurs within the first
        `n_init` frames.
    Attributes
    ----------
    metric : nn_matching.NearestNeighborDistanceMetric
        The distance metric used for measurement to track association.
    max_age : int
        Maximum number of missed misses before a track is deleted.
    n_init : int
        Number of frames that a track remains in initialization phase.
    kf : kalman_filter.KalmanFilter
        A Kalman filter to filter target trajectories in image space.
    tracks : List[Track]
        The list of active tracks at the current time step.
    """

    GATING_THRESHOLD = np.sqrt(kalman_filter.chi2inv95[4])

    def __init__(
        self,
        metric,
        motion_criterium="iou",
        max_iou_distance=0.9,
        max_oks_distance=0.7,
        max_age=30,
        n_init=3,
        _lambda=0,
        ema_alpha=0.9,
        mc_lambda=0.995,
        only_position_for_kf_gating=False,
    ):
        self.metric = metric
        if motion_criterium == "iou":
            self.motion_cost = iou_matching.iou_cost
            self.motion_max_distance = max_iou_distance
        elif motion_criterium == "oks":
            self.motion_cost = oks_matching.oks_cost
            self.motion_max_distance = max_oks_distance
        else:
            raise NotImplementedError(
                "motion_criterium should be either 'iou' or 'oks', but got {}".format(
                    motion_criterium
                )
            )
        self.max_age = max_age
        self.n_init = n_init
        self._lambda = _lambda
        self.ema_alpha = ema_alpha
        self.mc_lambda = mc_lambda

        self.kf = kalman_filter.KalmanFilter()
        self.tracks = []
        self._next_id = 1
        self.predict_done = False
        self.only_position = only_position_for_kf_gating

    def predict(self):
        """Propagate track state distributions one time step forward.

        This function should be called once every time step, before `update`.
        """
        for track in self.tracks:
            track.predict(self.kf)
        self.predict_done = True

    def increment_ages(self):
        for track in self.tracks:
            track.increment_age()
            track.mark_missed()

    def camera_update(self, previous_img, current_img):
        # ECC call was previously done inside each track in track.py, which is not efficient.
        # Moved it here to be computed once per new incoming frame.
        warp_matrix, src_aligned = ECC(previous_img, current_img)
        if warp_matrix is None and src_aligned is None:
            return None

        log.info("ECC WORKED, IT IS A MIRACLE SINCE IT WAS NOT WORKING BEFORE. TELL VLADIMIR")
        [a,b] = warp_matrix
        warp_matrix=np.array([a,b,[0,0,1]])
        warp_matrix = warp_matrix.tolist()
        matrix = get_matrix(warp_matrix)

        for track in self.tracks:
            track.camera_update(matrix)

        return matrix

    def update(self, detections, classes, confidences):
        """Perform measurement update and track management.

        Parameters
        ----------
        detections : List[deep_sort.detection.Detection]
            A list of detections at the current time step.

        """
        # Run matching cascade.
        matches, unmatched_tracks, unmatched_detections = self._match(detections)

        # Update track set.
        for track_idx, detection_idx in matches:
            self.tracks[track_idx].update(
                detections[detection_idx],
                classes[detection_idx],
                confidences[detection_idx],
            )
        for track_idx in unmatched_tracks:
            self.tracks[track_idx].mark_missed()
        for detection_idx in unmatched_detections:
            self._initiate_track(
                detections[detection_idx],
                classes[detection_idx].item(),
                confidences[detection_idx].item(),
            )
        self.tracks = [t for t in self.tracks if not t.is_deleted()]

        # Update distance metric.
        active_targets = [t.track_id for t in self.tracks if t.is_confirmed()]
        features, targets = [], []
        for track in self.tracks:
            if not track.is_confirmed():
                continue
            features += track.features
            targets += [track.track_id for _ in track.features]
        self.metric.partial_fit(
            np.asarray(features), np.asarray(targets), active_targets
        )

    def _full_cost_metric(self, tracks, dets, track_indices, detection_indices):
        """
        This implements the full lambda-based cost-metric. However, in doing so, it disregards
        the possibility to gate the position only which is provided by
        linear_assignment.gate_cost_matrix(). Instead, I gate by everything.
        Note that the Mahalanobis distance is itself an unnormalised metric. Given the cosine
        distance being normalised, we employ a quick and dirty normalisation based on the
        threshold: that is, we divide the positional-cost by the gating threshold, thus ensuring
        that the valid values range 0-1.
        Note also that the authors work with the squared distance. I also sqrt this, so that it
        is more intuitive in terms of values.
        """
        # Compute First the Position-based Cost Matrix
        pos_cost = np.empty([len(track_indices), len(detection_indices)])
        msrs = np.asarray([dets[i].to_xyah() for i in detection_indices])
        for row, track_idx in enumerate(track_indices):
            pos_cost[row, :] = (
                np.sqrt(
                    self.kf.gating_distance(
                        tracks[track_idx].mean,
                        tracks[track_idx].covariance,
                        msrs,
                        False,
                    )
                )
                / self.GATING_THRESHOLD
            )
        pos_gate = pos_cost > 1.0
        # Now Compute the Appearance-based Cost Matrix
        app_cost = self.metric.distance(
            np.array([dets[i].feature for i in detection_indices]),
            np.array([tracks[i].track_id for i in track_indices]),
        )
        app_gate = app_cost > self.metric.matching_threshold
        # Now combine and threshold
        cost_matrix = self._lambda * pos_cost + (1 - self._lambda) * app_cost
        cost_matrix[np.logical_or(pos_gate, app_gate)] = linear_assignment.INFTY_COST
        # Return Matrix
        return cost_matrix

    def _match(self, detections):
        """
        Associate previous track with current detections in two steps.
        Both steps perform a linear assignment (Hungarian algorithm) based on a cost matrix between tracks and detections.
        # REID STEP WITH KF GATING
        1. To compute the first cost matrix, we compare the appearance/reid features of the CONFIRMED tracks
        (i.e. tracks older than 'n_init') w.r.t. all the detections.
        Reid features for the tracks are computed by a moving average of the reid features of their underlying detections.
        The reid cost matrix is first computed and then 'gated' by the KF gating distance.
        The first cost matrix is 0.995 of the ReID distance + 0.005 of the KF gating distance. Entries of the cost
        matrix where the KF gating distance is above the threshold are set to INFTY_COST and ignored by the linear assignment.
        Finally, after the linear assignment is performed, tracks and detections that were matched but whose cost in
        the cost matrix was above the threshold 'max_dist' are canceled and considered as not matched.
        # SPATIO-TEMPORAL STEP WITH IOU
        2. To compute the second cost matrix, we compared all remaining (unmatched) detections with all remaining tracks,
        including UNCONFIRMED tracks (that were ignored in previous step), but excluding tracks that were not updated in the previous step.
        Tracks that were not updated in the previous step can therefore only be matched using the appearance features.
        To compare these unmatched tracks and detections and compute the second cost matrix, the IOU/OKS distance is used.
        The IOU is computed between the detection's bounding box and the kalman filter predicted bounding box of the track.
        Finally, after the linear assignment is performed, tracks and detections that were matched but whose cost in
        the cost matrix was above the threshold 'max_iou_distance' are canceled and considered as not matched.
        """


        self.compute_all_costs_matrix(detections)

        def gated_metric(tracks, dets, track_indices, detection_indices):
            features = {
                "reid_features": np.array(
                    [dets[i].feature["reid_features"] for i in detection_indices]
                ),
                "visibility_scores": np.array(
                    [dets[i].feature["visibility_scores"] for i in detection_indices]
                ),
            }

            targets = np.array([tracks[i].track_id for i in track_indices])
            cost_matrix_reid = self.metric.distance(features, targets)  # NO thresholding until here -> ONLY REID DISTANCE
            cost_matrix = linear_assignment.gate_cost_matrix(  # KF gating applied, too big values are set to INFTY
                cost_matrix_reid, tracks, dets, track_indices, detection_indices, only_position=self.only_position
            )

            return cost_matrix

        # Split track set into confirmed and unconfirmed tracks.
        confirmed_tracks = [i for i, t in enumerate(self.tracks) if t.is_confirmed()]
        unconfirmed_tracks = [
            i for i, t in enumerate(self.tracks) if not t.is_confirmed()
        ]

        # Associate confirmed tracks using appearance features.
        (
            matches_a,
            unmatched_tracks_a,
            unmatched_detections_a,
            gated_reid_cost_matrix
        ) = linear_assignment.matching_cascade(
            gated_metric,
            self.metric.matching_threshold,
            self.max_age,  # 'cascade' matching is not really implemented here, so 'max_age' is not used
            self.tracks,
            detections,
            confirmed_tracks,
        )

        # print(f"Matches with confirmed tracks using appearance features = {len(matches_a)}")

        # Associate remaining tracks together with unconfirmed tracks using spatio-temporal (st) distance metric.
        iou_track_candidates = unconfirmed_tracks + [
            k for k in unmatched_tracks_a if self.tracks[k].time_since_update == 1
        ]
        unmatched_tracks_a = [
            k for k in unmatched_tracks_a if self.tracks[k].time_since_update != 1
        ]
        (
            matches_b,
            unmatched_tracks_b,
            unmatched_detections_b,
            st_cost_matrix
        ) = linear_assignment.min_cost_matching(
            self.motion_cost,
            self.motion_max_distance,
            self.tracks,
            detections,
            iou_track_candidates,
            unmatched_detections_a,
        )


        # for i, (t_idx, d_idx) in enumerate(matches_a):
        #     det = detections[d_idx]
        #     det.reid_cost = {}
        #     matched_dist = -1
        #     for lcl_idx, glb_idx in enumerate(confirmed_tracks):
        #         det.reid_cost[self.tracks[glb_idx].track_id] = reid_cost_matrix[lcl_idx, i]
        #         if glb_idx == t_idx:
        #             matched_dist = reid_cost_matrix[lcl_idx, i]
        #     det.matched_with = f"R|{np.around(matched_dist, 3)}"  # R for ReID
        #
        # for i, (t_idx, d_idx) in enumerate(matches_b):
        #     det = detections[d_idx]
        #     det.st_cost = {}
        #     matched_dist = -1
        #     for lcl_idx, glb_idx in enumerate(iou_track_candidates):
        #         det.st_cost[self.tracks[glb_idx].track_id] = st_cost_matrix[lcl_idx, i]
        #         if glb_idx == t_idx:
        #             matched_dist = st_cost_matrix[lcl_idx, i]
        #     det.matched_with = f"S|{np.around(matched_dist, 3)}"  # S for Spatio-Temporal

        self.add_matching_information(detections, self.tracks, "R", confirmed_tracks, list(range(len(detections))), matches_a, gated_reid_cost_matrix)
        self.add_matching_information(detections, self.tracks, "S", iou_track_candidates, unmatched_detections_a, matches_b, st_cost_matrix)

        # print(f"Remaining tracks together with unconfirmed tracks using IOU = {len(matches_b)}")

        matches = matches_a + matches_b
        unmatched_tracks = list(set(unmatched_tracks_a + unmatched_tracks_b))
        return matches, unmatched_tracks, unmatched_detections_b

    def compute_all_costs_matrix(self, detections):
        """Compute reid/spatio-temporal/kf_gating distance from each detection to each track and update each
        detection with the resulting information. This is used for visualization purposes. No gated/thresholding is
        applied here to display the original information"""
        # reid cost matrix
        features = {
            "reid_features": np.array(
                [detection.feature["reid_features"] for detection in detections]
            ),
            "visibility_scores": np.array(
                [detection.feature["visibility_scores"] for detection in detections]
            ),
        }
        targets = np.array([track.track_id for track in self.tracks])
        cost_matrix_reid = self.metric.distance(features, targets)

        # spatio-temporal cost matrix (iou/oks)
        cost_matrix_st = self.motion_cost(  # return cost matrix gated by KM (too big IOU set to INF)
            self.tracks, detections, list(range(len(self.tracks))), list(range(len(detections))))

        # kf gating cost matrix
        only_position = self.only_position
        gating_dim = 2 if only_position else 4
        gating_threshold = kalman_filter.chi2inv95[gating_dim]
        track_indices = list(range(len(self.tracks)))
        detection_indices = list(range(len(detections)))
        measurements = np.asarray(
            [detections[i].to_xyah() for i in detection_indices])
        cost_matrix_kf_gating = np.zeros((len(self.tracks), len(detections)))
        for row, track_idx in enumerate(track_indices):
            track = self.tracks[track_idx]
            gating_distance = track.kf.gating_distance(track.mean, track.covariance, measurements, only_position)
            cost_matrix_kf_gating[row] = gating_distance

        # update each detection with costs to each track
        for i, det in enumerate(detections):
            det.costs = {}
            det.costs["R"] = {track.track_id: cost_matrix_reid[j, i] for j, track in enumerate(self.tracks)}
            det.costs["Rt"] = self.metric.matching_threshold
            det.costs["S"] = {track.track_id: cost_matrix_st[j, i] for j, track in enumerate(self.tracks)}
            det.costs["St"] = self.motion_max_distance
            det.costs["K"] = {track.track_id: cost_matrix_kf_gating[j, i] for j, track in enumerate(self.tracks)}
            det.costs["Kt"] = gating_threshold

    def add_matching_information(self, detections, tracks, name, track_candidates, detections_candidates, matches, cost_matrix):
        if cost_matrix is None:
            return
        track_glb_idx_to_lcl_idx = {idx:i for i, idx in enumerate(track_candidates)}
        matches_b_dict = {d: t for t, d in matches}
        for i, d_idx in enumerate(detections_candidates):
            det = detections[d_idx]
            # costs = cost_matrix[:, i]
            # det.costs[name] = {}
            # for t, cost in enumerate(costs):
            #     t_idx = track_candidates[t]
                # det.costs[name][tracks[t_idx].track_id] = cost
            if d_idx in matches_b_dict:
                matched_dist = cost_matrix[track_glb_idx_to_lcl_idx[matches_b_dict[d_idx]], i]
                det.matched_with = (name, matched_dist)  # name = "S" for Spatio-Temporal or "R" for ReID
            else:
                det.matched_with = None

    def _initiate_track(self, detection, class_id, conf):
        self.tracks.append(
            Track(
                detection,
                self._next_id,
                class_id,
                conf,
                self.n_init,
                self.max_age,
                self.ema_alpha,
                detection.feature,
            )
        )
        self._next_id += 1
