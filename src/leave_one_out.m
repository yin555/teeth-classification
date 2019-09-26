function predict = leave_one_out(dm,true_label)
[~,nearest_neighbor] = sort(dm,2);
predict = true_label(nearest_neighbor(:,2));
end
