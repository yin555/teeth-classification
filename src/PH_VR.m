function dgm = PH_VR(paths,params,fname)
% compute persistence diagrams using Vietoris-Rips filtration

addpath(paths.in.ripser)

% read mesh
[T,X,Y,Z] = read_data(paths,fname);
% read fps sample points
I = load_fps(paths,params,fname);

[dm,~] = distance_matrix(params,I,T,X,Y,Z);
dgm = ripserDM(dm,2,2);

end