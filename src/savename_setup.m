function path = savename_setup(params)
% setup the saving path

if strcmp(params.approach,'OT')
%     for OT approach the file name is of the form
%     (OT/) metric ( -> _norm) -> measure -> K -> D
    path = [params.metric];
    if params.norm
        path = [path '_norm'];
    end
    path = [path '_' params.measure '_K' num2str(params.K) '_D' num2str(params.D)];
    
elseif strcmp(params.approach,'PH')
%     for PH approach the file name is of the form
%     (PH/) filtration method ( -> _norm -> metric) -> barcode distance
    path = params.filtration;
    if params.norm
        path = [path '_norm'];
    end
    if ~isempty(strfind(params.filtration,'VR'))
        path = [path '_' params.metric];
    end
    path = [path '_' params.barcode_distance];
else
    disp('Invalid approach')
    path = '';
end
path = [params.approach '/' path];
end