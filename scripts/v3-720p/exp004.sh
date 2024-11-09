# 概要: reidを学習する
# 仮説: lossの team の重みを 1.0 を変更した方がチーム分類の精度が高いのではないか
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004

<< COMMENTOUT

COMMENTOUT