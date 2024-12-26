# ball,goalkeeper,others も学習データに含める -> 傍観者の検出、ballの検出も可能になるかも..??
trained_weights="/local/moriy/model/soccernet/sn-gamestate/reid/sn-gamestate-v3-720p/2024-12-21-19-42-35/0/2024_12_21_19_43_25_43S0c86cfc5-f34a-48ad-b819-bf419f96a0f4model/job-0_39_model.pth.tar"
export CUDA_VISIBLE_DEVICES=2; python -m tracklab.main -cn soccernet-v2-exp005 \
    modules.reid.training_enabled=False \
    modules.team._target_=sn_gamestate.team.TrackletTeamClustering \
    wandb.name=exp001 \
    modules.reid.cfg.model.load_weights=$trained_weights \
    dataset.dataset_path="/local/moriy/SoccerNetGS/rag-eval"

# 可視化の結果: 全然うまくいかなかった: なんなら、チーム分類が壊れた。タスクとして難しくなりすぎたかも
