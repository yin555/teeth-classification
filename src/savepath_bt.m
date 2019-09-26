function path = savepath_bt(params,sname1,sname2)
% save barcode distance to file
pathName = saveDGM_setup(params);
savepath = [pathName 'distance/' params.barcode_distance '/'];
mkdir(savepath)
path = [savepath sname1 '_' sname2 '.txt'];
end