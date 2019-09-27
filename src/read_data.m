function [T,X,Y,Z] = read_data(fname)
% read filled shapes
global paths

try
    load([paths.out.filledTriangle fname])
catch
    [T,X,Y,Z] = read_off_ph([paths.in.data fname]);
end