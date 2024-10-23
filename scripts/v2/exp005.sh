# 概要: kmeans_color
# 仮説: ptreidはSoccerNet映像にはうまく動かず、シンプルなkmeans_colorでは十分な結果が得られる
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ なし

export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v2-exp005

# 結果: そんなことなかった