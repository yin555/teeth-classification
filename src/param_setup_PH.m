function params = param_setup_PH(filt,dist,norm,bar_dist,maxdim,K,coefs)
% setup parameters for the PH approach
% param: coef is optional, only used in some filtration functions
params.approach = 'PH';
params.filtration = filt;
params.metric = dist;
params.norm = norm;
if strcmp(params.filtration,'maxMeancurv')
    params.maxdim = 0;
elseif any(strcmp(params.filtration,{'absMeancurv','MinusAbsMeancurv'}))
    params.maxdim = 1;
else
    params.maxdim = maxdim;
end

params.barcode_distance = bar_dist;
params.K = K;
if nargin < 7
    params.coef = -1;
else
    params.coef = coefs;
end
end