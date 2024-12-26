trained_weights="/local/moriy/model/soccernet/sn-gamestate/reid/sn-gamestate-v3-720p/2024-11-26-10-21-36/0/2024_11_26_10_22_05_22S9c0e99da-e916-4634-95c1-4ab4e94998e5model/job-0_29_model.pth.tar"
export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v2-exp005 \
    modules.reid.training_enabled=False \
    modules.team._target_=sn_gamestate.team.TrackletTeamClustering \
    wandb.name=exp001 \
    modules.reid.cfg.model.load_weights=$trained_weights \
    dataset.dataset_path="/local/moriy/SoccerNetGS/rag-eval" \
    'dataset.vids_dict.test=["SNGS-0029","SNGS-0030","SNGS-0031","SNGS-0032","SNGS-0033"]'
