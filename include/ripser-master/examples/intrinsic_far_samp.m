function [D,mu] = intrinsic_far_samp(T,X,Y,Z,Index,numPoints)
    %samples numPoints using the intrinsic farthest point sampling
    %procedure. 
    %Index is an optional input, pass in if X,Y,Z are truncated
    %D is the distance matrix of the truncation
    %mu is the probability meassure
    disp('Sampling farthest point using intrinsic distance')
    if nargin == 4
        Index = 1:length(X);
    end
    disp('Initializing')
    reducedI = zeros(1,numPoints); %indices of Index chosen to sample
    dimVp = length(Index);
%     reducedI(1) = randi(dimVp);
    reducedI(1) = 4;
    dist = zeros(numPoints,dimVp);
    D = zeros(numPoints);
    sampable = 1:dimVp; %set of points that can be chosen
    sampable(reducedI(1)) = [];
    disp('Iterating over the space')
    for i = 1:numPoints
        disp([num2str(i),'th iteration'])
        for j = 1:dimVp
            dist(i,j) = intrinsicDistance_nq(Index(reducedI(i)),Index(j),T,X,Y,Z);
        end
        if i < numPoints
            [ma,ima] = max(dist(i,sampable));
            reducedI(i+1) = ima;
            sampable(find(sampable == ima)) = [];
        end
    end
    D = dist(:,reducedI);
    dist(dist==0) = Inf;
    mu = probabilityMeasure(dist);
end