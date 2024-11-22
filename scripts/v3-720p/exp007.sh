# 概要: reidを学習する
# 仮説: train.max_samples_per_id=10000、 のせいで過適合していたのでは
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
    wandb.name=exp007 \
    modules.reid.dataset.train.max_samples_per_id=15 \
    modules.reid.dataset.test.max_samples_per_id=10 \


<< COMMENTOUT
    modules.reid.cfg.loss.part_based.reid_weight=0.0 \
    modules.reid.cfg.loss.part_based.team_weight=1.0 \
    modules.reid.cfg.loss.part_based.role_weight=0.0 \

COMMENTOUT
