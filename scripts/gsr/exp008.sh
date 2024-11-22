# 概要: 
# 仮説: siglipでteamはいい感じになるのでは？ -> gsrにおいては、prtreidの方が強い
# 設定:
#   映像データ Swiss 1080p
#   アノテーションデータ gsr
export CUDA_VISIBLE_DEVICES=3; 
python -m tracklab.main -cn soccernet-gsr-exp008


<< COMMENTOUT
CLEAR: tracklab-cls_comb_cls_av    MOTA      MOTP      MODA      CLR_Re    CLR_Pr    MTR       PTR       MLR       sMOTA     CLR_TP    CLR_FN    CLR_FP    IDSW      MT        PT        ML        Frag
COMBINED                           -37.257   82.915    -37.15    18.654    25.053    13.799    15.109    71.092    -40.444   92035     401339    275324    529       158       173       814       2250

HOTA: tracklab-cls_comb_cls_av     HOTA      DetA      AssA      DetRe     DetPr     AssRe     AssPr     LocA      OWTA      HOTA(0)   LocA(0)   HOTALocA(0)
COMBINED                           23.38     10.256    53.307    16.072    21.585    55.905    83.752    84.779    29.269    28.29     80.206    22.691

Identity: tracklab-cls_comb_cls_av IDF1      IDR       IDP       IDTP      IDFN      IDFP
COMBINED                           18.464    16.106    21.631    79462     413912    287897

Count: tracklab-cls_comb_cls_av    Dets      GT_Dets   IDs       GT_IDs
COMBINED                           367359    493374    3427      1145

CLEAR: tracklab-cls_comb_det_av    MOTA      MOTP      MODA      CLR_Re    CLR_Pr    MTR       PTR       MLR       sMOTA     CLR_TP    CLR_FN    CLR_FP    IDSW      MT        PT        ML        Frag
COMBINED                           -37.257   82.915    -37.15    18.654    25.053    13.799    15.109    71.092    -40.444   92035     401339    275324    529       158       173       814       2250

HOTA: tracklab-cls_comb_det_av     HOTA      DetA      AssA      DetRe     DetPr     AssRe     AssPr     LocA      OWTA      HOTA(0)   LocA(0)   HOTALocA(0)
COMBINED                           23.38     10.256    53.307    16.072    21.585    55.905    83.752    84.779    29.269    28.29     80.206    22.691

Identity: tracklab-cls_comb_det_av IDF1      IDR       IDP       IDTP      IDFN      IDFP
COMBINED                           18.464    16.106    21.631    79462     413912    287897

Count: tracklab-cls_comb_det_av    Dets      GT_Dets   IDs       GT_IDs
COMBINED                           367359    493374    3427      1145
COMMENTOUT