# 概要: 
# 仮説: 
# 設定:
#   映像データ Swiss 1080p
#   アノテーションデータ gsr
export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-gsr-test-exp002

# 評価のみ 画像中のbboxの位置でgs-hotaの計算
export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-gsr-test-exp002-eval-image-space
