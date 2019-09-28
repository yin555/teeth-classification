function dm = compute_distance_matrix(params)
% compute the pairwise disatnce matrix for shapes using a specific
% approach
global paths;

if sum(strcmp(params.approach,{'OT','PH'})) == 0
    disp('Invalid approach')
    return
end

dataset = dir([paths.in.data '*.off']);
n = length(dataset);
p = nchoosek(1:n,2);

parfor k = 1:length(p)
    % compute distance for each pair of shapes and save to file
    ik = p(k,1);
    jk = p(k,2);
    
    if strcmp(params.approach,'OT')
%         compute TLB
        distij = compute_dist_OT(params,dataset(ik).name,dataset(jk).name,num2str(ik),num2str(jk),...
            paths);
    else
%         compute bt
        distij = compute_dist_PH(params,dataset(ik).name,dataset(jk).name,num2str(ik),num2str(jk),...
            paths);
    end
end

% assemble distances

% initialize the distance matrix
if strcmp(params.approach,'OT')
    dm = zeros(n);
else
%     gather all barcode distances across all dimensions in a cell
    dm = cell(params.maxdim,1);
    for i = 1:params.maxdim
        dm{i} = zeros(n);
    end
end

% load distances from file
for k = 1:length(p)
    ik = p(k,1);
    jk = p(k,2);
    if strcmp(params.approach,'OT')
        load(savepath_tlb(params,num2str(ik),num2str(jk)))
        dm(ik,jk) = tlb;
    else
        load(savepath_bt(params,num2str(ik),num2str(jk)))
        for i = 1:params.maxdim
            dm{i}(ik,jk) = bt(i);
        end
    end
end

end

