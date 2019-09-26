function [dm,vfilt] = distance_matrix(params,I,T,X,Y,Z)
% construct the distance matrix between sampled points according to
% specified metric
% param: dm is the distance matrix
% param: vfilt is the filtration value for each vertexs
options.curvature_smoothing = 1;
[~,~,~,~,cmean,~,~] = compute_curvature([X';Y';Z'],T',options);
cmean = abs(cmean);
if strcmp(params.metric,'euc')
    dm = squareform(pdist([X(I) Y(I) Z(I)]));
else
    dm = geodesic(params,T,X,Y,Z,I,cmean);
end
vfilt = abs(cmean(I));
cmeanMax = max(vfilt);

% allow vertices with high absolute mean curvature to enter the simplicial
% complex first
vfilt = cmeanMax - vfilt;

end