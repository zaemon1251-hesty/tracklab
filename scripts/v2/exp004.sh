# 概要: 
# 仮説: calibなしでチーム分類を行う場合、bboxの中心位置のクラスタリングで十分な精度が得られる
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ なし

export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v2-exp004