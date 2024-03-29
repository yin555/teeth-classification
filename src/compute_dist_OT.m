function compute_dist_OT(paths,params,fname1,fname2,sname1,sname2)
% compute the distance (TLB) between a pair of shapes using optimal transport

addpath(genpath(paths.in.sinkhorn))

savetlb_path = savepath_tlb(paths,params,sname1,sname2);
if exist(savetlb_path,'file') ~= 2
%     setup local shape distribution and measure for shape 1
    path = [paths.out.localDist '/' params.metric '/' params.measure '/' num2str(params.K) '/'];
    
    if exist(path,'dir') ~= 7
        mkdir(path)
    end
    
    try
        T = load([path sname1 '.mat']);
        vX = T.v;
        wX = T.w;
    catch
        [vX,wX] = process_dm(paths,fname1,params,sname1);
    end
    
%     setup local shape distribution and measure for shape 2
    try
        T = load([path sname2 '.mat']);
        vY = T.v;
        wY = T.w;
    catch
        [vY,wY] = process_dm(paths,fname2,params,sname2);
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
    
    % options for sinkhorn solver
    options.tau = 0;
    options.niter = params.niter;
    options.verb = 0;
    [~,~,gamma,~,~,~] = sinkhorn_log(wX,wY,Q,epsParam,options);
%     [ct gamma] = solveTranspProblem(wX,wY,Q);
    tlb = sum(sum(Q.*gamma)); % this will calculate the TLB (p=1)
    save(savetlb_path,'tlb')
end
end

function [v,w]= process_dm(paths,filename,params,sname)
% compute fps and local shape distribution
[T,X,Y,Z] = read_data(paths,filename);
%         disp('Computing Euclidean Farthest Point Sampling...')
if params.K < length(X)
    I = euclid_far_samp(X,Y,Z,params.K);
else
    I = 1:length(X);
end

% compute dm
dmX = distance_matrix(params,I,T,X,Y,Z);
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
w = w(:);
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
% 
% function savetlb(tlb_path,tlb)
% fid = fopen(tlb_path,'w');
% fprintf(fid,'%12.8f\n',tlb);
% fclose(fid);
% end
