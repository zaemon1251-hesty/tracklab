# 概要: reidを学習する
# 仮説: ballやreferee otherも含めて学習して、いい感じかどうか確認
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
    wandb.name=exp007 \
    modules.reid.dataset.train.max_samples_per_id=15 \
    modules.reid.dataset.test.max_samples_per_id=10 

# 評価
# trained_weights=""
# export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
#     modules.reid.training_enabled=False \
#     wandb.name=exp007 \
#     modules.reid.cfg.model.load_weights=$trained_weights \
#     dataset.nvid=20

<< COMMENTOUT
COMMENTOUT
