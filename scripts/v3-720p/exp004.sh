# 概要: reidを学習する
# 仮説: lossの team の重みを prtreidの論文通りに設定すると、reidの性能が向上するか->向上しない
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004

<< COMMENTOUT
123 epoch: [1/120 e][6679 b] eta 2 days, 17:40:48 lr 0.00003815 loss 16.141
125 epoch: [2/120 e][6692 b] eta 2 days, 16:28:09 lr 0.00007280 loss 12.090
127 epoch: [3/120 e][6700 b] eta 6 days, 4:39:21 lr 0.00010745 loss 11.571
129 epoch: [4/120 e][6674 b] eta 5 days, 6:26:01 lr 0.00014210 loss 11.257
133 epoch: [6/120 e][6679 b] eta 4 days, 7:43:50 lr 0.00021140 loss 10.723
135 epoch: [7/120 e][6713 b] eta 4 days, 0:49:30 lr 0.00024605 loss 10.530
137 epoch: [8/120 e][6656 b] eta 3 days, 19:22:52 lr 0.00028070 loss 10.427
139 epoch: [9/120 e][6730 b] eta 3 days, 15:05:39 lr 0.00031535 loss 10.293

152 Computing CMC and mAP for eval Team Affiliation metric 'mot_intra_video' ...
153 ** Results **
154 mAP: 50.70%
155 CMC curve
156 Rank-1  : 58.44%
157 Rank-5  : 95.34%
158 Rank-10 : 99.43%
159 Rank-20 : 99.85%

203 epoch: [19/120 e][6718 b] eta 2 days, 18:30:17 lr 0.00035000 loss 9.681
267 epoch: [29/120 e][6714 b] eta 2 days, 8:33:45 lr 0.00035000 loss 9.444
331 epoch: [39/120 e][6699 b] eta 2 days, 0:47:09 lr 0.00035000 loss 9.359
396 epoch: [49/120 e][6706 b] eta 1 day, 18:38:49 lr 0.00003500 loss 8.685
524 epoch: [69/120 e][6681 b] eta 1 day, 6:16:02 lr 0.00003500 loss 8.450
845 epoch: [120/120 e][6691 b] eta 0:00:00 lr 0.00000350 loss 8.218

861 Computing CMC and mAP for eval Team Affiliation metric 'mot_intra_video' ...
862 ** Results **
863 mAP: 50.75%
864 CMC curve
865 Rank-1  : 58.93%
866 Rank-5  : 95.08%
867 Rank-10 : 99.35%
868 Rank-20 : 99.80%

COMMENTOUT