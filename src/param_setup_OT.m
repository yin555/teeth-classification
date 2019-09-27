function params = param_setup_OT(pmeasure, dist, norm, DD, epsilon, K)
params.approach = 'OT';
params.norm = norm;
params.measure = pmeasure;
params.metric = dist;
params.D = DD;
% parameters to set up sinkhorn
params.eps = epsilon;
params.K = K;
params.N = 100;
params.maxdim = 1;
end