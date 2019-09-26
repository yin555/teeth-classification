function saveDGM(dgm,params,dim,sname)
% save the diagram as txt file for Hera
savepath = [saveDGM_setup(params) 'dim' num2str(dim) '/'];
% make sure the saving path exists
mkdir(savepath)

% save the file
dlmwrite([savepath sname '.txt'],dgm,'delimiter','\t')
end


