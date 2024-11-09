# 概要: reidをtestするだけ -> train epoch 1
# 仮説: 
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3

export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p

<< COMMENTOUT
=> Loaded ReidDataset
---------------------------------
subset     | # ids | # images | # cameras
---------------------------------
train      | 188   | 1224     | 3
query      | 203   | 585      | 3
gallery    | 203   | 1912     | 3
---------------------------------

=> Loading test (target) dataset
Using cached dataset SoccerNet.
Using cached dataset SoccerNet.

*************** Summary ***************
source             : ['SoccerNet']
# source datasets  : 1
# source ids       : 188
# source images    : 1224
# source cameras   : 3
target             : ['SoccerNet']
****************************************
Test batch feature extraction speed: 8.2698 sec/batch
Normalizing features with L2 norm ...
Computing distance matrix with metric=euclidean ...
Computing CMC and mAP for eval Team Affiliation metric 'mot_intra_video' ...
** Results **
mAP: 51.06%
CMC curve
Rank-1   : 59.90%
Rank-5   : 95.49%
Rank-10  : 99.65%
Rank-20  : 100.00%

Computing CMC and mAP for eval REID metric 'mot_intra_video' ...
** Results **
mAP: 7.01%
CMC curve
Rank-1   : 20.51%
Rank-5   : 27.18%
Rank-10  : 33.68%
Rank-20  : 46.32%

Low visibility (<0.25) mAP: not provided
Medium visibility (0.25->0.75) mAP: not provided
High visibility (>0.75) mAP: 7.01% (585)
Low visibility (<0.25) rank-1: not provided
Medium visibility (0.25->0.75) rank-1: not provided
High visibility (>0.75) rank-1: 20.51% (585)

COMMENTOUT