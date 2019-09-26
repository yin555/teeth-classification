function [Q,weight] = addNeighborx1(T,x1,Q,weight,X,Y,Z,pre)
    %finds the nodes that share a triangle with x1 and set/update the queue
    %and weight accordingly
    %returns the modified queue with the min being the first element and
    %the associated weight function according to the euclidean distance
    %x1 is the index of the source point
    Trix1 = T(:,1) == x1 | T(:,2) == x1 | T(:,3) == x1; %row number of a triangulation containing x1
    Trix1 = T(Trix1,:); %all the triangulation that contains x1
    nbx1 = Trix1(:); 
    nbx1 = unique(nbx1(nbx1 ~= x1)); %consider all the points that is not x1
    nbx1 = setdiff(nbx1,pre);
    for i = 1:length(nbx1)
        weighti = norm([X(nbx1(i)) Y(nbx1(i)) Z(nbx1(i))] ...
                        - [X(x1) Y(x1) Z(x1)],2);
        if Q.contains(nbx1(i))
            if weight(Q.indexOf(nbx1(i))) > weight(1) + weighti
                weight(Q.indexOf(nbx1(i))) = weight(1) + weighti;
            end
        else
            Q.add(nbx1(i));
            weight(end+1) = weight(1) + weighti; 
        end
    end
end