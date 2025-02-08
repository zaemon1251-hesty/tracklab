# 公開重み(SoccerNet-Tracking Datasetで学習された重み)で選手同定を実行する
EXP_NAME=$(date '+%Y-%m-%d_%H-%M')

TMP_VIDEO_PATH=/local/moriy/SoccerNetGS/rag-eval

export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v2-exp005 \
    modules.reid.training_enabled=False \
    modules.team._target_=sn_gamestate.team.TrackletTeamClustering \
    wandb.name=$EXP_NAME \
    dataset.dataset_path="$TMP_VIDEO_PATH"

