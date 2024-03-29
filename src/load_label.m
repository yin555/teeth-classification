function [true_label,conversion_key] = load_label(paths,category)
% load the label in integers, provided with the conversion key

% load the excel file
[~,spreadsheet] = xlsread(paths.in.label);
if strcmp(category,'diet')
    colnum = 7;
elseif strcmp(category,'family')
    colnum = 2;
elseif strcmp(category,'genus')
    colnum = 5;
else
    disp('Invalid category')
    colnum = 1;
end

labels = spreadsheet(2:end,colnum);
codes = spreadsheet(2:end,end);
% process the labels to drop special characters
labels = reorder_label(paths,labels,codes);
conversion_key = unique(labels);
[~,true_label] = ismember(labels,conversion_key);
end

function true_label = reorder_label(paths,label,codes)
% reorder the labels to match the ordering in the data directory
% param: codes are the names that match with the file names in the data
% directory

dir_meshes = dir([paths.in.data '*.off']);
meshnames = cell(length(dir_meshes),1);
% load the file names in the data path
for k=1:length(dir_meshes), meshnames{k} = lower(dir_meshes(k).name(1:end-8));end
for i=1:length(meshnames)
    if ismember(meshnames{i},{'i14-hom1','i15-hom1','i16-hom1','i17-hom1'})
        meshnames{i} = meshnames{i}(1:3);
    end
end

% clean the file names
meshnames = regexprep(meshnames,'#|*| ','');

[~,order] = ismember(meshnames,lower(codes));
true_label = label(order);
end