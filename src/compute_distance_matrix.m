function dm = compute_distance_matrix(paths,params)
% compute the pairwise disatnce matrix for shapes using a specific
% approach

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
        compute_dist_OT(paths,params,dataset(ik).name,dataset(jk).name,num2str(ik),num2str(jk));
    else
%         compute bt
        compute_dist_PH(paths,params,dataset(ik).name,dataset(jk).name,num2str(ik),num2str(jk));
    end
end

% assemble distances

dm = load_distances(paths,params);

end

