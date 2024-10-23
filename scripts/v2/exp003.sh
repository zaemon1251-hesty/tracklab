# 概要: 解像度上げてみる
# 仮説: 解像度上げたら背番号の認識割合が上がるかも
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ なし

export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v2-exp003

# 結果: 上がった 4倍くらい