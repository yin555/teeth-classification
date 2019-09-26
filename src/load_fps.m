function I = load_fps(params,fname)
global paths
try
%     load/create subsampled vertices by FPS
    load([paths.out.fps fname(1:end-4) '.mat'])
catch
    I = euclid_far_samp(X,Y,Z,params.numPoints);
    save([paths.out.fps fname(1:end-4) '.mat'],'I')
end

end