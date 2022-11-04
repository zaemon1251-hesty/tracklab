import torch
import numpy as np

from pathlib import Path
from strong_sort.utils.parser import get_config # TODOs in here
from strong_sort.strong_sort import StrongSORT

@torch.no_grad()
class StrongSORT2detections():
    def __init__(self, config_strongsort, device):
        self.cfg = get_config()
        self.cfg.merge_from_file(config_strongsort)
        weights = Path(self.cfg.STRONGSORT.WEIGHTS).resolve()
        
        self.model = StrongSORT(
            weights,
            device,
            self.cfg.STRONGSORT.HALF,
            max_dist=self.cfg.STRONGSORT.MAX_DIST,
            max_iou_distance=self.cfg.STRONGSORT.MAX_IOU_DISTANCE,
            max_age=self.cfg.STRONGSORT.MAX_AGE,
            n_init=self.cfg.STRONGSORT.N_INIT,
            nn_budget=self.cfg.STRONGSORT.NN_BUDGET,
            mc_lambda=self.cfg.STRONGSORT.MC_LAMBDA,
            ema_alpha=self.cfg.STRONGSORT.EMA_ALPHA,
        )
        # For camera compensation
        # TODO not sure about utility
        self.prev_frame = None
        
    def _image2input(self, image): # Tensor RGB (1, 3, H, W)
        input = image.detach().cpu().numpy() # tensor -> numpy
        input = np.transpose(input, (1, 2, 0)) # -> (H, W, 3)
        input = input*255.0
        input = input.astype(np.uint8) # -> to uint8
        return input
    
    def _camera_compensation(self, curr_frame):
        if self.cfg.STRONGSORT.ECC:  # camera motion compensation
            self.model.tracker.camera_update(self.prev_frame, curr_frame)
            self.prev_frame = curr_frame
            
    def _detections2inputs(self, detections):
        xywhs = []
        scores = []
        for detection in detections:
            xywhs.append(detection.bbox_xywh())
            scores.append(detection.bbox.conf)
        
        xywhs = torch.Tensor(np.asarray(xywhs))
        scores = torch.Tensor(scores)
        classes = torch.Tensor([0]*len(scores))
        return xywhs, scores, classes
        
    def run(self, data, detections):
        input = self._image2input(data['image'])
        self._camera_compensation(input)
        
        results = []
         # check if instance(s) has been detected
         # by pose detector
        if detections:
            xywhs, scores, classes = self._detections2inputs(detections)
            results = self.model.update(xywhs,
                                        scores,
                                        classes,
                                        input)
        
        detections = self._update_detections(results, detections)
        return detections

    def _update_detections(self, results, detections):
        for result in results:
            detection = self._find_detection(result[:4], detections)
            detection.bbox.x = result[0]
            detection.bbox.y = result[1]
            detection.bbox.w = result[2] - result[0]
            detection.bbox.h = result[3] - result[1]
            detection.bbox.conf = result[6]
            detection.person_id = result[4]
            detection.source = 3
        return detections
    
    def _find_detection(self, bbox_track, detections):
        """
            TODO rendre ça mieux car c'est vraiment degeulasse
            Comme les Bboxes en output de StrongSort sont différentes de celles
            du detecteur, je suis obligé des les parser pour les associer.
            Ici l'algo est clairement sous optimisé O(n) mais on appelle
            cette fonction n fois -> O(n²) in fine, c'est franchement degeux.
            Ca serait cool que dans le framework Re-ID, on ai un matching
            input / output pour éviter ça...
        """
        # compute euclidean distance for each Bbox, select the smallest one
        # to return the Keypoints
        distances = []
        for detection in detections:
            distances.append(
                np.sum((bbox_track - detection.bbox_xyxy())**2)
            )
        argmin = distances.index(min(distances))
        return detections[argmin]