function [T X Y Z] = readobj_fast(filename)
fid = fopen(filename);

if fid==-1
  error('File not found or permission denied');
end

C = textscan(fid,'%s %f %f %f %f %f %f','Whitespace',' //','commentStyle','#');

fclose(fid);

vertices = strcmp(C{1}(:), 'v');
 
 X = C{2}(vertices);
 Y = C{3}(vertices);
 Z = C{4}(vertices);
 
triangles = strcmp(C{1}(:),'f');

ntriangles = sum(triangles);

T1 = C{2}(triangles);
T2 = C{4}(triangles);
T3 = C{6}(triangles);
T = [T1 T2 T3];

% trisurf(T,X,Y,Z);

end