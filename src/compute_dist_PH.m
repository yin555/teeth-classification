function bt = compute_dist_PH(params,fname1,fname2,sname1,sname2)
global paths

% compute persistence diagrams for shape 1 and shape 2
compute_persistenceDGM(params,fname1,sname1)
compute_persistenceDGM(params,fname2,sname2)

% compute the bottleneck/wasserstein distances between two shapes
wd = pwd;
cd(paths.in.hera)
bt = zeros(params.maxdim,1);

for dim = 1:params.maxdim
    
    directory = [saveDGM_setup(params) 'dim' num2str(dim-1) '/'];
    savepath1 = [directory sname1 '.txt'];
    savepath2 = [directory sname2 '.txt'];
    if strcmp(params.barcode_distance,'bt')
%         compute the bottleneck distance between the files
        [~,bt_out] = system(['./bottleneck_dist ' savepath1 ' ' savepath2]);
    else
        [~,bt_out] = system(['./wasserstein_dist ' savepath1 ' ' savepath2 ' 2']);
    end
    bt_dim = parse_bt(bt_out);
    bt(dim) = bt_dim;
end
cd(wd)

bt_path = savepath_bt(params,sname1,sname2);
save(bt_path,'bt')
end

function f = filtration(params,T,X,Y,Z)
% build the filtration function for sublevel filtration 
options.curvature_smoothing = 1;
[~,~,~,~,cmean,~,~] = compute_curvature([X';Y';Z'],T',options);

% construct filtration function
if strcmp(params.filtration,'absMeancurv')
    f = abs(cmean);
elseif strcmp(params.filtration,'MinusAbsMeancurv')
    f =  max(abs(cmean)) - abs(cmean);
end

% normalize filtration function
if param.norm
    f = f/max(f);
end

end

function dgm = PH_sublevel(params,fname)
global paths
[T,X,Y,Z] = read_ph_off([paths.in.data fname]);
f = filtration(params,T,X,Y,Z);
[~,dgm,~] = sublevel_filtration_simp(T,f,params.maxdim);
end

function dgm = compute_persistenceDGM(params,fname,sname)
savepath = saveDGM_setup(params);
if exist([savepath 'dim0/' sname '.txt'],'file') == 2
    return;
end

% compute persistence diagram for shape if not exist
dgm = filtration_method(params,fname);

% save persistence diagrams
for dim = 1:params.maxdim
    saveDGM(dgm{dim},params,dim-1,sname)
end

end

function dgm = filtration_method(params,fname)
% build filtrations for the two shapes

if strcmp(params.filtration,'maxMeancurv')
%     build filtration function using mean curvature function
    dgm = PH_maxMeancurv(params,fname);
elseif ~isempty(strfind(params.filtration,'VR'))
%     build VR filtration using Ripser/JavaPlex
    dgm = PH_VR(params,fname);    
else
%     build sublevel filtration using JavaPlex
    dgm = PH_sublevel(params,fname);
end
end

function bt = parse_bt(output_string)
% parse the output by hera
filebyline = regexp(output_string, '\n', 'split');
filebyline(cellfun(@isempty,filebyline)) = [];
bt = str2double(filebyline);
end
