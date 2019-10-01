function I = load_fps(paths,params,fname)
try
%     load/create subsampled vertices by FPS
    load([paths.out.fps params.K '/' fname(1:end-4) '.mat'])
catch
    [~,X,Y,Z] = load_data(paths,fname);
    I = euclid_far_samp(X,Y,Z,params.K);
    if exist([paths.out.fps params.K '/'],'dir') ~= 7
        mkdir([paths.out.fps params.K '/'])
    end
    save([paths.out.fps params.K '/' fname(1:end-4) '.mat'],'I')
end

end