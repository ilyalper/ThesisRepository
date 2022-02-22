function [best_temp_assignments, better, is_changed] =neighborsearch_assignment(data,best_temp_assignments,best_temp_centers,p,n,d,q,number_of_neighbors)

%best_temp_assignments = new_parent_assignment_set_temp(1,:);
%best_temp_centers=new_parent_center_set_temp(1,:);
%number_of_neighbors = 2;

is_changed=1;


%Önce fitness ı hesaplıyoruz
for i=1:p
    
    % ilk önce i. clusterdaki noktaları grupluyoruz
    assigned_orders_of_i=find(best_temp_assignments==i);
    replication = length(assigned_orders_of_i);
    
    if replication==1
        sub_fitness(i)=0; %this cluster includes only one point
    else
        % ardından her feature için fitness değeri hesaplayıp fitness
        % değerlerine göre sıralıyoruz
        distances_of_features= sum(abs(data(assigned_orders_of_i,:)-repmat(data(best_temp_centers(i),:),replication,1)));
        [ordering index] = sort(distances_of_features,'ascend');
        
        %ilk q adet feature üzerinden değerleri topluyoruz
        sub_fitness(i)= sum(ordering(1:q));
        selected_features(i,:) = index(1:q);
        %burada da fitness hesaplamaya ek olarak en yakın komşuları detect
        %ediyoruz.
        % seçtiğimiz featurelar üzerinden o clustera atanan noktaların
        % merkeze olan uzaklığına bakıyoruz.
        distances_of_points= sum(abs(data(assigned_orders_of_i,index(1:q))-repmat(data(best_temp_centers(i),index(1:q)),replication,1)),2);
        [neighborhood_ordering neighborhood_index] = sort(distances_of_points,'descend');
        farthest_neighbors(i,:) = assigned_orders_of_i(neighborhood_index(1:number_of_neighbors));
        
    end
end

fitness_value = sum(sub_fitness);

is_better = fitness_value;

%Sonra en yakın number_of_neighbors*p tane assignment'ı en yakın cluster'a atıyoruz.
%ilk önce bakacağımız komşu*cluster kadar test space'imizi oluşturalım
%neigborhood_test_centers=repmat(best_temp_centers,number_of_neighbors*p,1);
test_assignment_points=unique(farthest_neighbors);

for i =1:length(test_assignment_points)
    for j = 1:p
        distance_of_ith_cluster_center(j)= sum(abs(data(test_assignment_points(i),selected_features(j,:))-data(best_temp_centers(j),selected_features(j,:))),2);
    end
    [new_dist(i), new_assignment(i)] = min(distance_of_ith_cluster_center);
end

best_temp_assignments(test_assignment_points) = new_assignment;
%Ardından değişim sonrası yeni fitness hesaplıyoruz


fitness_of_new_neighborhood = cluster_update(data,best_temp_assignments,best_temp_centers,p,n,d,q);

if fitness_of_new_neighborhood<is_better
    better=fitness_of_new_neighborhood;
    is_changed=1;
else 
    better=is_better;
    is_changed=0;
end

end

