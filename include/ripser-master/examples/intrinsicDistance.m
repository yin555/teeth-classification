function d = intrinsicDistance(x1,x2,T,X,Y,Z)
    %%%% x1 is the index of of the source, x2 is the index of the endpoint
    %x1,x2 indices of points
    %Q queue for Dijastra's algorithm
    %Index indices of current space
    %%%%Dijstra's algorithm
    import java.util.LinkedList
    currDist = 0;
    Q = LinkedList();
    Q.add(x1);
    pre = [];
    weight = [0];
    while ~Q.isEmpty()
        v = Q.peek();
        [Q,weight] = addNeighborx1(T,v,Q,weight,X,Y,Z,pre);
        if Q.get(0) == x2
            Q.pop();
            pre(end+1) = v;
            currDist = min(weight);
            break
        elseif Q.size() == 1
            currDist = Inf;
        end
        Q.pop();
        weight(1) = [];
        pre(end+1) = v;
        currDist = min(weight(weight>0));
    end
    d = currDist;
end