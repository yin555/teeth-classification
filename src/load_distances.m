function dm = load_distances(paths,params)
% assembles distance matrix from files
n = numel(dir([paths.in.data '*.off']));
p = nchoosek(1:n,2);

% initialize the distance matrix
%     gather all barcode distances across all dimensions in a cell
dm = cell(params.maxdim+1,1);
for i = 1:params.maxdim+1
    dm{i} = zeros(n);
end


% load distances from file
for k = 1:length(p)
    ik = p(k,1);
    jk = p(k,2);
    if strcmp(params.approach,'OT')
        load(savepath_tlb(paths,params,num2str(ik),num2str(jk)))
        dm{1}(ik,jk) = tlb;
    else
        load(savepath_bt(paths,params,num2str(ik),num2str(jk)))
        for i = 1:params.maxdim+1
            dm{i}(ik,jk) = bt(i);
        end
    end
end
end