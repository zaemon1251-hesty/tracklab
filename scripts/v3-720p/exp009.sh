# 概要: reidを学習する
# 仮説: player と staffだけで学習する？
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
    wandb.name=exp008 \
    modules.reid.dataset.train.max_samples_per_id=15 \
    modules.reid.dataset.test.max_samples_per_id=10 

# 評価
# trained_weights="/local/moriy/model/soccernet/sn-gamestate/reid/sn-gamestate-v3-720p/2024-12-21-19-42-35/0/2024_12_21_19_43_25_43S0c86cfc5-f34a-48ad-b819-bf419f96a0f4model/job-0_39_model.pth.tar"
# export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
#     modules.reid.training_enabled=False \
#     wandb.name=exp008 \
#     modules.reid.cfg.model.load_weights=$trained_weights \
#     dataset.nvid=20

<< COMMENTOUT
COMMENTOUT
