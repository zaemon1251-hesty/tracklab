# 概要: reidを学習する
# 仮説: SoccerNet映像でも、reidを学習することで、チーム分類で良い結果が得られるのではないか
# 設定:
#   映像データ SoccerNet FullHD 1080p
#   アノテーションデータ v3

export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v3

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
Computing distance matrix with metric=euclidean ...
Computing CMC and mAP for eval Team Affiliation metric 'mot_intra_video' ...

** Results **
mAP: 53.25%
CMC curve
Rank-1  : 69.13%
Rank-5  : 96.13%
Rank-10 : 99.42%
Rank-20 : 99.96%

** Results **
mAP: 16.65%
CMC curve
Rank-1  : 32.29%
Rank-5  : 50.57%
Rank-10 : 61.24%
Rank-20 : 72.60%

Low visibility (<0.25) mAP: not provided
Medium visibility (0.25->0.75) mAP: not provided
High visibility (>0.75) mAP: 16.65% (8539)

Low visibility (<0.25) rank-1: not provided
Medium visibility (0.25->0.75) rank-1: not provided
High visibility (>0.75) rank-1: 32.29% (8539)

Evaluate distribution of distances of pairs with same id vs different ids
Positive pairs distance distribution mean: 0.674
Positive pairs distance distribution standard deviation: 0.192
Negative pairs distance distribution mean: 0.888
Negative pairs distance distribution standard deviation: 0.168

SSMD = 3.2861

Role prediction accuracy for query = 82.29% and for gallery = 82.74% and on average = 82.63%
visualize_ranking_grid for dataset SoccerNet, bp None and ids [4554 3684 7602 1222]

Test completed

Amount of pairs query-gallery that couldn't be compared: 0.0%
Amount of queries that couldn't be compared to any gallery sample: 0.0%

COMMENTOUT