# 概要: reidを学習する
# 仮説: epochを増やせば、チーム分類の精度が上がるのではないか
# 設定:
#   映像データ SoccerNet FullHD 1080p
#   アノテーションデータ v3

export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v3-720p-exp002

<< COMMENTOUT
=> Loaded ReidDataset
=> Loaded ReidDataset
---------------------------------
subset   | # ids   | # images  | # cameras
---------------------------------
train    | 13328   | 174679    | 295
query    | 2390    | 7526      | 48
gallery  | 2390    | 25573     | 48
---------------------------------

=> Loading test (target) dataset
Using cached dataset SoccerNet.
Using cached dataset SoccerNet.

**************** Summary ****************
source           : ['SoccerNet']
# source datasets: 1
# source ids     : 13328
# source images  : 174679
# source cameras : 295
target           : ['SoccerNet']
*****************************************

COMMENTOUT