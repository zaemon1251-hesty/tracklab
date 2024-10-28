# 概要: reidを学習する
# 仮説: epochを増やせば、チーム分類の精度が上がるのではないか
# 設定:
#   映像データ SoccerNet FullHD 1080p
#   アノテーションデータ v3

export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v3-exp002

<< COMMENTOUT
=> Loaded ReidDataset

subset | # ids | # images | # cameras
train   | 18981 | 188333   | 297
query   | 3403  | 8539     | 48
gallery | 3403  | 26864    | 48

=> Loading test (target) dataset
Using cached dataset SoccerNet.
Using cached dataset SoccerNet.

**************** Summary ****************

source : ['SoccerNet']
# source datasets : 1
# source ids      : 18981
# source images   : 188333
# source cameras  : 297
target : ['SoccerNet']

******************************************

Computing CMC and mAP for eval Team Affiliation metric 'mot_intra_video' ...
** Results **
mAP: 51.99%
CMC curve
Rank-1  : 69.27%
Rank-5  : 97.57%
Rank-10 : 99.83%
Rank-20 : 100.00%
Computing CMC and mAP for eval REID metric 'mot_intra_video' ...
COMMENTOUT