function tlb = compute_dist_OT(params,fname1,fname2,sname1,sname2)
% compute the distance (TLB) between a pair of shapes using optimal transport
global paths
addpath(paths.in.sinkhorn)

if exist([paths.out.tlb '/tlb' sname1 '_' sname2 '.mat'],'file') ~= 2
%     setup local shape distribution and measure for shape 1
    path = [paths.out.localDist '/' params.metric '/' params.measure '/' num2str(params.K) '/'];
    mkdir(path)
    try
        T = load([path sname1 '.mat']);
        vX = T.v;
        wX = T.w;
    catch
        [vX,wX] = process_dm([paths.in.data fname1],params,sname1);
    end
    
%     setup local shape distribution and measure for shape 2
    try
        T = load([path sname2 '.mat']);
        vY = T.v;
        wY = T.w;
    catch
        [vY,wY] = process_dm([paths.in.data fname2],params,sname2);
    end
    
    K = params.K;
    DD = params.D;
    NN = params.N;
    epsParam = params.eps;
    
    % compute cost matrix (p=1)
    Q = zeros(K,K);
    for i = 1:K
        vi = vX(i,:);
        for j = 1:K
            vj = vY(j,:);
            Q(i,j) = sum(abs(vi-vj))*DD/NN;
        end
    end
    
    disp('Computing tlb...')
    [~,~,gamma,~,~,~] = sinkhorn_log(wX,wY,Q,epsParam,options);
%     [ct gamma] = solveTranspProblem(wX,wY,Q);
    tlb = sum(sum(Q.*gamma)); % this will calculate the TLB (p=1)
    save(savepath_tlb(params,sname1,sname2),'gamma','tlb')
end
end

function [v,w]= process_dm(filename,params,sname)
global paths
[T,X,Y,Z] = read_data(filename);
%         disp('Computing Euclidean Farthest Point Sampling...')
if params.K < length(X)
    I = euclid_far_samp(X,Y,Z,params.K);
else
    I = 1:length(X);
end

% compute dm
dmX = distance_matrix(metric_type,I,T,X,Y,Z);
diamX = max(max(dmX));
if params.norm
    dmX = dmX/diamX; %normalize dm
end

% initialize measure
if strcmp(params.measure,'uniform')
    w = ones(1,params.K)/params.K;
elseif strcmp(params.measure,'voronoi')
    w = voronoi_measure(dmX,I);
end

v = localDist(dmX,params.N,params.D,w);

save([paths.out.localDist '/' params.metric '/' params.measure '/' num2str(params.K) '/' ...
    sname '.mat'],'v','w','I','dmX');
end

function v = voronoi_measure(dm,I)
    %%%%dm is the full distance matrix of the shape
    dmI = dm(I,:);
    [~,ind_min] = min(dmI);
    v = zeros(length(I),1);
    for i = 1:length(I)
        v(i) = sum(ind_min == i)/size(dm,1);
    end
end

function v = localDist(dm,NN,DD,mu)
% compute the local shape distribution
    n = length(dm);
    TimeMesh = linspace(0,DD,NN);

    v = zeros(n,NN);
    for i = 1:n
        for j = 1:NN
            v(i,j) = sum(mu(dm(i,:) <= TimeMesh(j)));
        end
    end
    v = v/max(v(:));
end

