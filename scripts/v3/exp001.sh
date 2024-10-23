# 概要: reidを学習する
# 仮説: SoccerNet映像でも、reidを学習することで、チーム分類で良い結果が得られるのではないか
# 設定:
#   映像データ SoccerNet FullHD 1080p
#   アノテーションデータ v3

export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v3