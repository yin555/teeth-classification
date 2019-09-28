function path = savepath_tlb(paths,params,sname1,sname2)
% set up the saving path for tlb results

pathName = [paths.out.tlb params.metric];
if params.norm
    pathName = [pathName '_norm/'];
else
    pathName = [pathName '/'];
end

pathName = [pathName params.measure];

% set up a subdirectory for each choice of K when using Voronoi measure
if strcmp(params.measure,'voronoi')
    pathName = [pathName '/' num2str(params.K)];
end

pathName = [pathName '/' num2str(params.D)];

mkdir(pathName)

path = [pathName sname1 '_' sname2 '.mat'];
end