function dgm = PH_VR(params,fname)
% compute persistence diagrams using Vietoris-Rips filtration
global paths
addpath(paths.in.ripser)

% read mesh
[T,X,Y,Z] = read_off_ph([paths.in.data fname]);
% read fps sample points
I = load_fps(params,fname);

[dm,~] = distance_matrix(params,I,T,X,Y,Z);
dgm = ripserDM(dm,2,2);

end