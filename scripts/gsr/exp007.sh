# 概要: 
# 仮説: reid を学習することで、gsr の性能が向上する -> (ベースライン27.755 -> 27.155) 変わらないどころか減ってる。。。
# 設定:
#   映像データ Swiss 1080p
#   アノテーションデータ gsr
#   不具合でtestの件数が若干少ない。なので、ベースラインと公平公正に比較できているわけではない
export CUDA_VISIBLE_DEVICES=3; 
# python -m tracklab.main -cn soccernet-gsr-exp007

###################
# 評価だけする
###################
python -m tracklab.main -cn soccernet-gsr-exp007 \
    visualization.cfg.save_videos=False \
    use_wandb=False 

#     state.save_file=/home/lr/moriy/workspace/soccernet/tracklab/outputs/sn-gamestate-gsr/2024-11-20/18-25-22/states/sn-gamestate-gsr.pklz \
#    pipeline=[] \


## Reid の学習結果
<< COMMENTOUT
=> Loaded ReidDataset
----------------------------------------
subset   | # ids | # images | # cameras
----------------------------------------
train    |   448 |   232552 |        21
query    |  1222 |   129508 |        58
gallery  |  1222 |   516012 |        58
----------------------------------------

train #images per id = 519.09

=> Loading test (target) dataset
**************** Summary ****************
source            : ['SoccerNet']
# source datasets : 1
# source ids      : 448
# source images   : 232552
# source cameras  : 21
target            : ['SoccerNet']
*****************************************

===================
Test Only
===================
Computing CMC and mAP for eval Team Affiliation metric 'mot_intra_video' ...
** Results **
mAP: 68.68%
CMC curve
Rank-1  : 89.98%
Rank-5  : 98.69%
Rank-10 : 99.71%
Rank-20 : 99.92%


===================
with training
===================

** Results **
mAP: 76.55%
CMC curve
Rank-1  : 95.42%
Rank-5  : 99.30%
Rank-10 : 99.71%
Rank-20 : 99.84%
skipping reid metrics




======================
GS-HOTA
======================

CLEAR: tracklab-cls_comb_cls_av    MOTA      MOTP      MODA      CLR_Re    CLR_Pr    MTR       PTR       MLR       sMOTA     CLR_TP    CLR_FN    CLR_FP    IDSW      MT        PT        ML        Frag
COMBINED                           -35.71    82.66     -35.601   24.436    28.928    19.563    14.148    66.288    -39.948   120563    372811    296211    538       224       162       759       2647

HOTA: tracklab-cls_comb_cls_av     HOTA      DetA      AssA      DetRe     DetPr     AssRe     AssPr     LocA      OWTA      HOTA(0)   LocA(0)   HOTALocA(0)
COMBINED                           27.155    12.992    56.766    20.952    24.803    60.073    83.044    84.686    34.485    33.147    80.501    26.683

Identity: tracklab-cls_comb_cls_av IDF1      IDR       IDP       IDTP      IDFN      IDFP
COMBINED                           23.131    21.336    25.257    105264    388110    311510

Count: tracklab-cls_comb_cls_av    Dets      GT_Dets   IDs       GT_IDs
COMBINED                           416774    493374    3814      1145

CLEAR: tracklab-cls_comb_det_av    MOTA      MOTP      MODA      CLR_Re    CLR_Pr    MTR       PTR       MLR       sMOTA     CLR_TP    CLR_FN    CLR_FP    IDSW      MT        PT        ML        Frag
COMBINED                           -35.71    82.66     -35.601   24.436    28.928    19.563    14.148    66.288    -39.948   120563    372811    296211    538       224       162       759       2647

HOTA: tracklab-cls_comb_det_av     HOTA      DetA      AssA      DetRe     DetPr     AssRe     AssPr     LocA      OWTA      HOTA(0)   LocA(0)   HOTALocA(0)
COMBINED                           27.155    12.992    56.766    20.952    24.803    60.073    83.044    84.686    34.485    33.147    80.501    26.683

Identity: tracklab-cls_comb_det_av IDF1      IDR       IDP       IDTP      IDFN      IDFP
COMBINED                           23.131    21.336    25.257    105264    388110    311510

Count: tracklab-cls_comb_det_av    Dets      GT_Dets   IDs       GT_IDs
COMBINED                           416774    493374    3814      1145
COMMENTOUT