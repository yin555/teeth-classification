% import java.util.LinkedList

% disp('Loading data...')
[T X Y Z] = readobj_fast('horse-01.obj');

tic
K = 1000;
disp('Computing Euclidean Farthest sampling...')
euclid_index = euclid_far_samp(X,Y,Z,K);
toc
tic
disp('Computing Intrinsic Farthest sampling...')
[dprime,mu] = intrinsic_far_samp(T,X,Y,Z,euclid_index,K);
toc
disp('Done.')

addpath('..');
disp('Doing Z2...');
Is2geo = ripserDM(dprime, 2, 2);
figure
subplot(221);
plotDGM(Is2geo{2}, 'r', 20, 0), axis square;
hold on;
plotDGM(Is2geo{3}, [0, 0.5, 0]), axis square;
title('Z2 Coefficients / Geodesic');