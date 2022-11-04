import os
import argparse

from tqdm import tqdm

import cv2
import torch
import numpy as np

from datasets import ImageFolder
from dekr2detections import DEKR2detections
from strong_sort2detections import StrongSORT2detections

from tracker import *


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input-folder', required=True, help='path to folder containing images to process')
    parser.add_argument('--project', default='track', help='project name')
    parser.add_argument('--name', default='exp', help='experience name')
    parser.add_argument('--show-poses', default=True, help='show keypoints')
    parser.add_argument('--show-tracks', default=True, help='show tracking results')
    parser.add_argument('--save-imgs', default=True, help='save images')
    parser.add_argument('--save-vid', default=True, help='save video')
    parser.add_argument('--config-dekr', type=str, default='DEKR/experiments/inference.yaml')
    parser.add_argument('--config-strongsort', type=str, default='strong_sort/configs/track.yaml')
    args = parser.parse_args()
    return args


@torch.no_grad()
def track(
    input_folder,
    project='track',
    name='exp',
    show_poses=True,
    show_tracks=True,
    save_imgs=True,
    save_vid=True,
    config_dekr='DEKR/experiments/inference.yaml',
    config_strongsort='strong_sort/configs/track.yaml',
):
    # handle paths
    if save_imgs or save_vid:
        save_path = os.path.join('runs', project, name)
        i = 0
        while os.path.exists(save_path + str(i)):
            i += 1
        save_path = save_path + str(i)
        os.makedirs(save_path, exist_ok=True)
        if save_imgs:
            imgs_name = os.path.join(save_path, 'imgs')
            os.makedirs(imgs_name, exist_ok=True)
        if save_vid:
            vid_name = None
    
    # select device
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    
    # TODO use this as a module, not always DEKR but whatever we want
    # load pose extractor 
    model_pose = DEKR2detections(
        config_dekr, 
        device,
        vis_threshold=0.3 # TODO maybe add to .yaml file ?
    )
    
    # TODO replace by Re-ID framework and make it modulable
    # TODO use this as a module, not always StrongSORT but whatever we want
    # load strongsort
    model_track = StrongSORT2detections(
            config_strongsort,
            device
        )
    
    # load dataloader
    dataset = ImageFolder(input_folder)
    
    all_detections = []
    # process images
    for data in tqdm(dataset): # image is Tensor RGB (3, H, W)
        # pose estimation part -> create detections object
        detections = model_pose.run(data)
        
        # tracking part -> update detecti  ons object
        detections = model_track.run(data, detections)
        all_detections.extend(detections)
    
    tracker = Tracker(detections=all_detections)
    df = tracker.detections
    
    
def main():
    args = parse_args()
    track(**vars(args))
    
    
if __name__ == "__main__":
    main()