id = [6389 5220 8298 6389];
for i = 1:4
    for j = 1:4
        dist(i,j) = sqrt((X(id(i))-X(id(j))).^2 + (Y(id(i))-Y(id(j))).^2 + (Z(id(i))-Z(id(j))).^2);
        dist(j,i) = dist(i,j);
    end
end