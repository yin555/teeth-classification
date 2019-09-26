function d = intrinsicDistance_nq(x1,x2,T,X,Y,Z)
    %%%% x1 is the index of of the source, x2 is the index of the endpoint
    %x1,x2 indices of points
    %Q queue for Dijastra's algorithm
    %Index indices of current space
    %%%%Dijstra's algorithm
    currDist = 0;
    Q(1) = x1;
    pre = [];
    weight = [0];
    while ~isempty(Q)
        v = Q(1);
        [Q,weight] = addNeighborx1_nq(T,v,Q,weight,X,Y,Z,pre);
        if Q(1) == x2
            Q(1) = [];
%             pre(end+1) = v;
            currDist = min(weight);
            break
%         elseif size(Q) == 1
%             currDist = Inf;
        end
        Q(1) = [];
        weight(1) = [];
        pre(end+1) = v;
        currDist = min(weight(weight>0));
    end
    d = currDist;
end