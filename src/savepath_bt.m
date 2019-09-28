function path = savepath_bt(paths,params,sname1,sname2)
% save barcode distance to file
% pathName = saveDGM_setup(paths,params);
savepath = [paths.out.db params.barcode_distance '/'];
mkdir(savepath)

pathName = params.filtration;
if params.norm
    pathName = [pathName '_norm/'];
else
    pathName = [pathName '/'];
end

if ~isempty(strfind(params.filtration,'VR'))
    pathName = [pathName params.metric '/'];
end

path = [savepath pathName sname1 '_' sname2 '.mat'];
end