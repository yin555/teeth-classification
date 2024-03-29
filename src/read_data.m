function [T,X,Y,Z] = read_data(paths,fname)
% read filled shapes
% global paths;

try
    load([paths.out.filledTriangle fname(1:end-4) '.mat'])
catch
    [T,X,Y,Z] = read_off_ph([paths.in.data fname]);
end