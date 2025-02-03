# goalkeeper,others,staff も学習データに含める -> 傍観者の検出も可能になるかも..??
trained_weights="/local/moriy/model/soccernet/sn-gamestate/reid/sn-gamestate-v3-720p/2025-01-09-23-43-24/0/2025_01_09_23_43_59_43Sc2d362d0-4160-45ad-a28a-afd2530fe85amodel/job-0_59_model.pth.tar"
export CUDA_VISIBLE_DEVICES=3; python -m tracklab.main -cn soccernet-v2-exp005 \
    modules.reid.training_enabled=False \
    modules.team._target_=sn_gamestate.team.TrackletTeamClustering \
    wandb.name=exp003 \
    modules.reid.cfg.model.load_weights=$trained_weights \
    dataset.dataset_path="/local/moriy/SoccerNetGS/rag-eval"

# 可視化の結果:
