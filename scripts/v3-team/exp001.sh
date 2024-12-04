# 概要: 同じチームに同じpid
# 仮説: 
# 設定:
#   映像データ SoccerNet 720p
#   アノテーションデータ v3


export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v3-720p-exp004 \
    experiment_name=sn-gamestate-v3-team \
    dataset.dataset_path=/local/moriy/SoccerNetGS/v3-team \
    modules.reid.cfg.loss.part_based.reid_weight=0.0 \
    modules.reid.cfg.loss.part_based.team_weight=1.0 \
    modules.reid.cfg.loss.part_based.role_weight=0.0 \
    modules.reid.dataset.train.max_samples_per_id=100 \
    modules.reid.dataset.test.max_samples_per_id=100 \

