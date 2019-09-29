function bt = compute_dist_PH(paths,params,fname1,fname2,sname1,sname2)

% compute persistence diagrams for shape 1 and shape 2
compute_persistenceDGM(paths,params,fname1,sname1)
compute_persistenceDGM(paths,params,fname2,sname2)

% compute the bottleneck/wasserstein distances between two shapes
bt_path = savepath_bt(paths,params,sname1,sname2);
if exist(bt_path,'file') ~= 2
    wd = pwd;
    base_directory = saveDGM_setup(paths,params);
    bt = zeros(params.maxdim+1,1);

    for dim = 1:params.maxdim+1
        
        directory = [base_directory 'dim' num2str(dim-1) '/'];
        savepath1 = [directory sname1 '.txt'];
        savepath2 = [directory sname2 '.txt'];
        if strcmp(params.barcode_distance,'bt')
    %         compute the bottleneck distance between the files
            cd([paths.in.hera 'geom_bottleneck/build/'])
            [~,bt_out] = system(['./bottleneck_dist ' savepath1 ' ' savepath2]);
        else
            cd([paths.in.hera 'geom_bottleneck/wasserstein/build/'])
            [~,bt_out] = system(['./wasserstein_dist ' savepath1 ' ' savepath2 ' 2']);
        end
        bt_dim = parse_bt(bt_out);
        bt(dim) = bt_dim;
    end
    cd(wd)


    save(bt_path,'bt')
end
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
if params.norm
    f = f/max(f);
end

end

function dgm = PH_sublevel(paths,params,fname)
[T,X,Y,Z] = read_data(paths,fname);
f = filtration(params,T,X,Y,Z);
[~,dgm,~] = sublevel_filtration_simp(T,f,params.maxdim+1,paths);
end

function dgm = compute_persistenceDGM(paths,params,fname,sname)
savepath = saveDGM_setup(paths,params);
if exist([savepath 'dim0/' sname '.txt'],'file') == 2
    return;
end

% compute persistence diagram for shape if not exist
dgm = filtration_method(paths,params,fname);

% save persistence diagrams
for dim = 1:params.maxdim+1
    saveDGM(dgm{dim},paths,params,dim-1,sname)
end

end

function dgm = filtration_method(paths,params,fname)
% build filtrations for the two shapes

if strcmp(params.filtration,'maxMeancurv')
%     build filtration function using mean curvature function
    dgm = PH_maxMeancurv(paths,params,fname);
elseif ~isempty(strfind(params.filtration,'VR'))
%     build VR filtration using Ripser/JavaPlex
    dgm = PH_VR(paths,params,fname);    
else
%     build sublevel filtration using JavaPlex
    dgm = PH_sublevel(paths,params,fname);
end
end

function bt = parse_bt(output_string)
% parse the output by hera
filebyline = regexp(output_string, '\n', 'split');
filebyline(cellfun(@isempty,filebyline)) = [];
bt = str2double(filebyline);
end
