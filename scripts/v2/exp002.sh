# 概要: 
# 仮説: なし
# 設定:
#   映像データ SoccerNet 224p
#   アノテーションデータ なし
export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v2-exp002

# エラー吐きまくり