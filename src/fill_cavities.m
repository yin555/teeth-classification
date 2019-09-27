function fill_cavities()
% fill the 1-cycles in each mesh file
global paths;

mesh_files = dir([paths.in.data '*.off']);

for i = 1:length(mesh_files)
    fname = mesh_files(i).name;
    if check_holes([paths.in.data fname])
        fill_cavities_helper([paths.in.data fname],fname(1:end-4))
    end
end

end

function bool_1cycle = check_holes(path2file)
% check if there is 1-cycle in the mesh
global paths
wd = pwd;
bool_1cycle = false;
cd(paths.in.shortloop)
if exist([path2file(1:end-4) '_loops.txt'],'file') ~= 2
    system(['./ShortLoop ' path2file ' -v -t'])
end
fid = fopen([path2file(1:end-4) '_loops.txt'],'r');
first_line = textscan(fid,'%f %s',1,'delimiter',' ');
n_loop = first_line(1);
if n_loop{1} > 0
    bool_1cycle = true;
else
%     delete the files if there is no 1-cycles in the mesh
    delete([path2file(1:end-4) '_loops.txt'])
end
delete([path2file(1:end-4) '_loops.off'])
delete([path2file(1:end-4) '_timing.txt'])
cd(wd)
end

function fill_cavities_helper(path2file,sname)
% fill 1-cycles in the mesh using the generators output by ShortLoop
global paths
disp('loading loops')
all_loops = load_loop([path2file(1:end-4) '_loops.txt']);
[Tp,Xp,Yp,Zp] = read_off_ph(path2file);
disp('filling holes')
[T,X,Y,Z] = fill_holes(Tp,Xp,Yp,Zp,all_loops);
save([paths.in.filledTriangle sname '.mat'],'T','X','Y','Z');
end

function all_loops = load_loop(fname)
%load shortest loop and fill
filestr = fileread(fname);
filebyline = regexp(filestr, '\n', 'split');
filebyline(cellfun(@isempty,filebyline)) = [];
all_loops = cell(length(filebyline)-2,1);
for l = 2:length(filebyline)-1
    line = regexp(filebyline{l}, ':', 'split');
    loop = regexp(line{2}, ' ', 'split');
    loop(cellfun(@isempty,loop)) = [];
    loop_id = str2double(loop)+1;
    all_loops{l-1} = loop_id;
end
end

function [Tp,Xp,Yp,Zp] = fill_holes(T,X,Y,Z,all_loops)
% fill loops by adding an extra vertex at the center of each loop and fill
% the triangles formed by the centroid and two adjacent generating vertices
% of the loop
num_holes = length(all_loops);
Tp = T;
Xp = X;
Yp = Y;
Zp = Z;
for h = 1:num_holes
    hole = all_loops{h};
    if length(hole) == 3
        Tp(end+1,:) = hole;
    else
        Xp = [Xp;mean(X(hole))];
        Yp = [Yp;mean(Y(hole))];
        Zp = [Zp;mean(Z(hole))];
        center = length(Xp);
        for j = 1:length(hole)
            if j == length(hole)
                k = 1;
            else
                k = j + 1;
            end
            curr_triangle = [center,hole(j),hole(k)];
            Tp(end+1,:) = curr_triangle;
        end
    end
end
end