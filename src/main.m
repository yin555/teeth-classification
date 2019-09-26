% The main executible file responsible for the classification

%% Path setup
global paths

basepath = '~/Desktop/Math/teeth_classification/';

% set up input paths (absolute paths only)
paths.in.data = [basepath 'data/'];
paths.in.label = [basepath 'data/Boyer_with_order.xlsx'];

paths.in.sinkhorn = [basepath 'include/sinkhorn/'];
paths.in.toolboxGeneral = [basepath 'include/toolbox_general/'];
paths.in.toolboxSignal = [basepath 'include/toolbox_signal/'];
paths.in.ripser = [basepath 'include/ripser-master/'];
paths.in.javaplex = [basepath 'include/appliedtopology-javaplex-6a2ef48/'];
paths.in.shortloop = [basepath 'include/ShortLoop'];
paths.in.hera = [basepath 'include/hera'];

% set up output paths
paths.out.fps = [basepath 'data/cache/fps/'];
paths.out.localDist = [basepath 'data/cache/localDist/'];
paths.out.filledTriangle = [basepath 'data/cache/filledTriangle/'];
paths.out.tlb = [basepath 'data/cache/tlb/'];
paths.out.dgm = [basepath 'data/cache/dgm/'];
paths.out.bt = [basepath 'data/cache/bt/'];

paths.out.fig = [basepath 'out/figures/'];
paths.out.pe = [basepath 'out/Pe/'];

% create folders for each output field
fn = fieldname(paths.out);
for i = 1:numel(fn)-1
    mkdir([basepath 'data/cache/' fn{i}]);
end
mkdir(paths.out.fig)
mkdir(paths.out.pe)

%% Choose approach
% choose from 'OT' (optimal transport)
%          or 'PH' (persistent homology)
approach = 'OT';
D = 0.3;
epsilon = 0.05;
norm = false;
K = 2000;

% % parameters for the PH approach
% approach = 'PH';
% norm = false;
% maxdim = 2;
% numPoints = 500;

%% Parameters setup
% global params
if strcmp(approach,'OT')
    params = param_setup_OT('uniform','euc',norm,D,epsilon, K);
elseif strcmp(approach,'PH')
    params = param_setup_PH('VR','euc',norm,'bt',maxdim,numPoints);
else
    disp('Invalid approach')
end

%% Clean data (fill cavities)
fill_cavities();

%% Compute distance matrix
dm = compute_distance_matrix(params);

%% Classification accuracy
% classify using leave-one-out

% load labels by category: family, genus, diet
category = 'diet';
true_label = load_label(category);

predict = leave_one_out(dm,true_label);

savename = savename_setup(params);
% compute the probability of error
Pe = sum(true_label==predict)/length(true_label);
save([paths.out.pe savename '.mat'],'Pe')

% plot distance matrix and single-linkage dendrogram
fig = clustergram(dm,'ColumnLabels',true_label);
savefig(gcf,[paths.out.fig savename '.jpg'])