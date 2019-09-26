function reducedX = euclid_far_samp(X,Y,Z,numPoints)
    %samples numPoints using the intrinsic farthest point sampling
    %procedure. 
    %reducedX is a set of indices of the sample
    reducedX = zeros(1,numPoints);
    reducedX(1) = randi(length(X));
%     reducedX(1) = 1; testing
    dm = squareform(pdist([X Y Z]));
    curr_inf = dm(reducedX(1),:);
    for i = 1:numPoints-1
        ind = setdiff(1:length(X),reducedX);
        [ma,~] = max(curr_inf(ind));
        candidate = setdiff(find(curr_inf == ma),reducedX);
        reducedX(i+1) = candidate(1);
        curr_inf = min([curr_inf;dm(reducedX(i+1),:)]);    
    end
end