# 概要: reidを学習する
# 仮説: 
# 設定:
#   映像データ Swiss 1080p
#   アノテーションデータ gsr
export CUDA_VISIBLE_DEVICES=3; 
python -m tracklab.main -cn soccernet-gsr-exp005

## Reid の学習結果
<< COMMENTOUT
Normalizing features with L2 norm ...
Computing distance matrix with metric=euclidean ...
Computing CMC and mAP for eval Team Affiliation metric 'mot_intra_video' ...
** Results **
mAP: 78.12%
CMC curve
Rank-1  : 96.52%
Rank-5  : 99.51%
Rank-10 : 99.80%
Rank-20 : 99.92%
Computing CMC and mAP for eval REID metric 'mot_intra_video' ...
** Results **
mAP: 56.56%
CMC curve
Rank-1  : 73.32%
Rank-5  : 90.05%
Rank-10 : 94.31%
Rank-20 : 97.05%
Low visibility (<0.25) mAP: not provided
Medium visibility (0.25->0.75) mAP: not provided
High visibility (>0.75) mAP: 56.56% (2845)
Low visibility (<0.25) rank-1: not provided
Medium visibility (0.25->0.75) rank-1: not provided
High visibility (>0.75) rank-1: 73.32% (2845)
Evaluate distribution of distances of pairs with same id vs different ids
Positive pairs distance distribution mean: 0.533
Positive pairs distance distribution standard deviation: 0.206
Negative pairs distance distribution mean: 0.875
Negative pairs distance distribution standard deviation: 0.187
SSMD = 4.4188
Role prediction accuracy for query = 75.57% and for gallery = 75.55% and on average = 75.56%
visualize_ranking_grid for dataset SoccerNet, bp None and ids [1651 1013  443 2687
COMMENTOUT