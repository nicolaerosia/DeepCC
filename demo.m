%% Options
opts = get_opts();
create_experiment_dir(opts);

%% Setup Gurobi
if ~exist('setup_done','var')
    setup;
    setup_done = true;
end

%% Run Tracker

% opts.visualize = true;
opts.sequence = 2; % trainval-mini

% Tracklets
fprintf('compute_L1_tracklets start\n')
opts.optimization = 'KL';
compute_L1_tracklets(opts);
fprintf('compute_L1_tracklets done\n')

% Single-camera trajectories
opts.optimization = 'KL';
opts.trajectories.appearance_groups = 1;
compute_L2_trajectories(opts);
fprintf('compute_L2_trajectories done')
opts.eval_dir = 'L2-trajectories';
evaluate(opts);
fprintf('evaluate L2 trajectories done')

% Multi-camera identities
opts.identities.appearance_groups = 0;
compute_L3_identities(opts);
opts.eval_dir = 'L3-identities';
evaluate(opts);

