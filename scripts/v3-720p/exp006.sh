# 概要: reidを学習する
# 仮説: trainでのmAPはじゅうぶんたかいのでは？
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp003 \
    modules.reid.cfg.loss.part_based.reid_weight=0.0 \
    modules.reid.cfg.loss.part_based.team_weight=1.0 \
    modules.reid.cfg.loss.part_based.role_weight=0.0 \
    wandb.name=exp006 \
    modules.reid.dataset.test.set_name=train


<< COMMENTOUT
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
