# 概要: 
# 仮説: 一番普通？(defaultとの差分がわからない。。。)
# 設定:
#   映像データ Swiss 1080p
#   アノテーションデータ gsr
export CUDA_VISIBLE_DEVICES=0; python -m tracklab.main -cn soccernet-gsr-test-exp002-eval-image-space

<< COMMENTOUT
CLEAR: tracklab-cls_comb_cls_av    MOTA      MOTP      MODA      CLR_Re    CLR_Pr    MTR       PTR       MLR       sMOTA     CLR_TP    CLR_FN    CLR_FP    IDSW      MT        PT        ML        Frag
COMBINED                           -23.089   82.246    -22.94    26.801    35.015    18.603    22.271    59.127    -27.848   132228    361146    245409    736       213       255       677       3534

HOTA: tracklab-cls_comb_cls_av     HOTA      DetA      AssA      DetRe     DetPr     AssRe     AssPr     LocA      OWTA      HOTA(0)   LocA(0)   HOTALocA(0)
COMBINED                           27.755    15.158    50.839    22.898    29.916    53.686    82.647    84.346    34.118    34.023    80.046    27.234

Identity: tracklab-cls_comb_cls_av IDF1      IDR       IDP       IDTP      IDFN      IDFP
COMBINED                           25.516    22.523    29.426    111125    382249    266512

Count: tracklab-cls_comb_cls_av    Dets      GT_Dets   IDs       GT_IDs
COMBINED                           377637    493374    3983      1145

CLEAR: tracklab-cls_comb_det_av    MOTA      MOTP      MODA      CLR_Re    CLR_Pr    MTR       PTR       MLR       sMOTA     CLR_TP    CLR_FN    CLR_FP    IDSW      MT        PT        ML        Frag
COMBINED                           -23.089   82.246    -22.94    26.801    35.015    18.603    22.271    59.127    -27.848   132228    361146    245409    736       213       255       677       3534

HOTA: tracklab-cls_comb_det_av     HOTA      DetA      AssA      DetRe     DetPr     AssRe     AssPr     LocA      OWTA      HOTA(0)   LocA(0)   HOTALocA(0)
COMBINED                           27.755    15.158    50.839    22.898    29.916    53.686    82.647    84.346    34.118    34.023    80.046    27.234

Identity: tracklab-cls_comb_det_av IDF1      IDR       IDP       IDTP      IDFN      IDFP
COMBINED                           25.516    22.523    29.426    111125    382249    266512

Count: tracklab-cls_comb_det_av    Dets      GT_Dets   IDs       GT_IDs
COMBINED                           377637    493374    3983      1145
COMMENTOUT