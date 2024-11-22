# 概要: reidを学習する
# 仮説: lossの teamのみにした方がチーム分類の精度が高いのではないか-> 0.5%だけ向上したが、ほとんど変わらない
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp003 \
    modules.reid.cfg.loss.part_based.reid_weight=0.0 \
    modules.reid.cfg.loss.part_based.team_weight=1.0 \
    modules.reid.cfg.loss.part_based.role_weight=0.0 \
    wandb.name=exp005


<< COMMENTOUT
97 => Start training
98 epoch: [1/120 e][6679 b] eta 2 days, 17:16:19 lr 0.00003815 loss 2.254
100 epoch: [2/120 e][6692 b] eta 2 days, 18:04:24 lr 0.00007280 loss 0.515
102 epoch: [3/120 e][6700 b] eta 2 days, 16:41:41 lr 0.00010745 loss 0.400
104 epoch: [4/120 e][6674 b] eta 2 days, 15:29:25 lr 0.00014210 loss 0.400
106 epoch: [5/120 e][6679 b] eta 2 days, 14:50:08 lr 0.00017675 loss 0.400
108 epoch: [6/120 e][6679 b] eta 2 days, 14:37:24 lr 0.00021140 loss 0.400
110 epoch: [7/120 e][6713 b] eta 2 days, 14:05:53 lr 0.00024605 loss 0.400
112 epoch: [8/120 e][6656 b] eta 2 days, 13:32:04 lr 0.00028070 loss 0.400
114 epoch: [9/120 e][6730 b] eta 2 days, 12:52:37 lr 0.00031535 loss 0.400
 158 epoch: [19/120 e][6718 b] eta 2 days, 7:07:00 lr 0.00035000 loss 0.400
 290 epoch: [49/120 e][6706 b] eta 1 day, 14:43:14 lr 0.00003500 loss 0.400
 378 epoch: [69/120 e][6681 b] eta 1 day, 3:46:57 lr 0.00003500 loss 0.400
 508 epoch: [98/120 e][6677 b] eta 12:01:36 lr 0.00000350 loss 0.400

=> Loaded ReidDataset
---------------------------------
subset   | # ids   | # images  | # cameras
---------------------------------
train    | 13328   | 174679    | 295
query    | 2390    | 7526      | 48
gallery  | 2390    | 25573     | 48
---------------------------------

train #images per id = 13.10

=> Loading test (target) dataset
**************** Summary ****************
source           : ['SoccerNet']
# source datasets: 1
# source ids     : 13328
# source images  : 174679
# source cameras : 295
target           : ['SoccerNet']
*****************************************

=> Final test
##### Evaluating SoccerNet (source) #####
Computing CMC and mAP for eval Team Affiliation metric 'mot_intra_video' ...
** Results **
mAP: 50.80%
CMC curve
Rank-1  : 57.65%
Rank-5  : 95.07%
Rank-10 : 99.22%
Rank-20 : 99.91%
Computing CMC and mAP for eval REID metric 'mot_intra_video' ...
** Results **
mAP: 8.11%
CMC curve
Rank-1  : 22.15%
Rank-5  : 30.39%
Rank-10 : 38.21%
Rank-20 : 50.00%
SSMD = 2.2704
Role prediction accuracy for query = 83.63% and for gallery = 83.74% and on average = 83.72%
visualize_ranking_grid for dataset SoccerNet, bp None and ids [ 972 7429 3287 1106]
Test completed


COMMENTOUT
