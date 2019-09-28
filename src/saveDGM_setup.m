function pathName = saveDGM_setup(paths,params)
% setup the directory for saving persistence diagrams
% the structure of the directory is
% filtration method (-> metric for VR) -> dimension for persistence diagrams

pathName = [paths.out.dgm params.filtration];

if params.norm
    pathName = [pathName '_norm/'];
else
    pathName = [pathName '/'];
end

if ~isempty(strfind(params.filtration,'VR'))
    pathName = [pathName params.metric '/'];
end

end