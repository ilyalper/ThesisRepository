function[fitness_value,selected_features] = feature_selection (data, assignment_set,center_set,p,n,d,q)
%absolute_distance'a göre clusterlara assignment yapılıyor ve  her cluster
%için fitness hesaplanıyor

%assignment_set=new_parent_assignments_set_1(1,:);
%center_set=new_parent_center_set_1(1,:);
% manhattan distance is utilized for assignment


%cluster_distance=[];
for i=1:p
    
    % ilk önce i. clusterdaki noktaları grupluyoruz
    assigned_orders_of_i=find(assignment_set==i);
    replication = length(assigned_orders_of_i);
    
    if replication==1
        sub_fitness(i)=0;
    else
        % ardından her feature için fitness değeri hesaplayıp fitness
        % değerlerine göre sıralıyoruz
        distances_of_features= sum(abs(data(assigned_orders_of_i,:)-repmat(data(center_set(i),:),replication,1)));
        [ordering index] = sort(distances_of_features,'ascend');
        
        %ilk q adet feature üzerinden değerleri topluyoruz
        sub_fitness(i)= sum(ordering(1:q));
        selected_features(i,:) = index(1:q);
    end
    
end


fitness_value = sum(sub_fitness);

end