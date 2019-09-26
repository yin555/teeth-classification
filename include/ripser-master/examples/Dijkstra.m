[T X Y Z] = readobj_fast('horse-01.obj');

tic
K = 500;
disp('Computing Euclidean Farthest sampling...')
I = euclid_far_samp(X,Y,Z,K);

% % I should contain the indices of your 1000 Euclidean FPS points
% % for testing purposes I'll use I = 1:1000
% I = 1:1000;
 
tic
% create graph and compute distance
N = length(T);
A = sparse(N,N);
 
for k=1:N
    
    i1 =  T(k,1);
    i2 =  T(k,2);
    i3 =  T(k,3);
    
    P1 = [X(i1) Y(i1) Z(i1)];
    P2 = [X(i2) Y(i2) Z(i2)];
    P3 = [X(i3) Y(i3) Z(i3)];
    
    A(i1,i2) = norm(P1-P2);
    A(i2,i3) = norm(P2-P3);
    A(i3,i1) = norm(P3-P1);
 
end
 
% symmetrize adjacency matrix
A = max(A,A');
 
% create graph object
G = graph(A);
 

% compute distance matrix between all pairs of points in I.
% Check the help for the function distances!
dm = distances(G,I,I);
toc

addpath('..');
disp('Doing Z2...');
Is2geo = ripserDM(dm, 2, 2);
name = 
save('')

figure
subplot(221);
plotDGM(Is2geo{2}, 'r', 20, 0), axis square;
hold on;
plotDGM(Is2geo{3}, [0, 0.5, 0]), axis square;
title('Z2 Coefficients / Geodesic');
