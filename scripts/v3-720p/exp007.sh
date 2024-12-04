# 概要: reidを学習する
# 仮説: train.max_samples_per_id=10000、 のせいで過適合していたのでは -> 別に全然ダメ
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


# export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
#     wandb.name=exp007 \
#     modules.reid.dataset.train.max_samples_per_id=15 \
#     modules.reid.dataset.test.max_samples_per_id=10 \

# 評価
trained_weights="/local/moriy/model/soccernet/sn-gamestate/reid/sn-gamestate-v3-720p/2024-11-26-10-21-36/0/2024_11_26_10_22_05_22S9c0e99da-e916-4634-95c1-4ab4e94998e5model/job-0_29_model.pth.tar"
export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
    modules.reid.training_enabled=False \
    wandb.name=exp007 \
    modules.reid.cfg.model.load_weights=$trained_weights \
    dataset.nvid=20

# 一応評価
trained_weights="/local/moriy/model/soccernet/sn-gamestate/reid/prtreid-soccernet-baseline.pth.tar"
export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
    modules.reid.training_enabled=False \
    wandb.name=swiss \
    modules.reid.cfg.model.load_weights=$trained_weights \
    dataset.nvid=20

<< COMMENTOUT
COMMENTOUT
