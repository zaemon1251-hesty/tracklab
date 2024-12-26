export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v2-exp005 \
    modules.reid.training_enabled=False \
    modules.team._target_=sn_gamestate.team.TrackletTeamClustering \
    wandb.name=exp000 \
    dataset.dataset_path="/local/moriy/SoccerNetGS/rag-eval" \
    'dataset.vids_dict.test=["SNGS-0029","SNGS-0030","SNGS-0031","SNGS-0032","SNGS-0033"]'


