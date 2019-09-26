function mu = probabilityMeasure(dist)
    %dist a distance matrix (with no zero entries)
    %mu the probability measure
    [mi,imin] = min(dist); %returns the min and index of each column
    minIndex = min(imin); 
    if minIndex ~= 1
        imin = [zeros(1,minIndex) imin];
    end
    mu = histcounts(imin,'Normalization','probability');
end
