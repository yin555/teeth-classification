function dm_g = geodesic(params,T,X,Y,Z,I,cmean)
    % % I should contain the indices of your 1000 Euclidean FPS points
    % % for testing purposes I'll use I = 1:1000

    % create graph and compute distance
    N = length(T);
    Ag = sparse(length(X),length(X));
    
    if ~isempty(strfind(params.filtration,'modified'))
%         construct weight function for modified geodesic
        w = @(u,v,i,j) norm(u-v)*exp(-params.coef*min(cmean(i),cmean(j)));
    else
        w = @(u,v,i,j) norm(u-v);
    end

    for k=1:N

        i1 =  T(k,1);
        i2 =  T(k,2);
        i3 =  T(k,3);

        P1 = [X(i1) Y(i1) Z(i1)];
        P2 = [X(i2) Y(i2) Z(i2)];
        P3 = [X(i3) Y(i3) Z(i3)];

%         compute weights on each edge in the adjancency matrix
        Ag(i1,i2) = w(P1,P2,i1,i2);
        Ag(i2,i3) = w(P2,P3,i2,i3);
        Ag(i3,i1) = w(P3,P1,i3,i1);
    end

    %     disp('Building distance matrices...')
    % symmetrize adjacency matrix
    Ag = max(Ag,Ag');

    % create graph object
    Gg = graph(Ag);
    
    % compute distance matrix between all pairs of points in I.
    % Check the help for the function distances!
    dm_g = distances(Gg,I,I);
end

