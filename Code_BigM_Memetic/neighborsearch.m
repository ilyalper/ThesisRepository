function [best_update, better, is_changed] =neighborsearch(data,best_temp_assignments,best_temp_centers,p,n,d,q,number_of_neighbors)
%best_temp_features=[1     0    0    0     0         1   1         1         0     0 0    0   ]

%best_temp_centers = [33,99];
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
        
        %burada da fitness hesaplamaya ek olarak en yakın komşuları detect
        %ediyoruz.
        % seçtiğimiz featurelar üzerinden o clustera atanan noktaların
        % merkeze olan uzaklığına bakıyoruz.
        distances_of_points= sum(abs(data(assigned_orders_of_i,index(1:q))-repmat(data(best_temp_centers(i),index(1:q)),replication,1)),2);
        [neighborhood_ordering neighborhood_index] = sort(distances_of_points,'ascend');
        closest_neighbors(i,:) = assigned_orders_of_i(neighborhood_index(2:number_of_neighbors+1));
    end
    
end

fitness_value = sum(sub_fitness);

is_better = fitness_value;

%Sonra en yakın number_of_neighbors tane (su an 10) nokta üzerinden tekrar birer fitness hesaplıyoruz.
%ilk önce bakacağımız komşu*cluster kadar test space'imizi oluşturalım
neigborhood_test_centers=repmat(best_temp_centers,number_of_neighbors*p,1);
for i =1:p
    %burada 2 cluster için dersek test spaceimizin önce ilk kolonunu sonra
    %da 2. kolonunu değiştiriyoruz
    neigborhood_test_centers ((number_of_neighbors*(i-1)+1:number_of_neighbors*i),i) = closest_neighbors(i,:);
    
end


%Ardından yeni adaylar için (neighbors*p) fitness hesaplıyoruz

for i = 1: number_of_neighbors*p
    
    fitness_of_neighborhood = cluster_update(data,best_temp_assignments,neigborhood_test_centers(i,:),p,n,d,q);
    
    if fitness_of_neighborhood<is_better
        is_better=fitness_of_neighborhood;
        best_updated_center = neigborhood_test_centers(i,:);
    end
end

                   

if is_better<fitness_value
    best_update = best_updated_center;
    better=is_better;
%    changed_cluster=ceil(temp_index/number_of_neighbors);
   %[best_update_2, better_2] = neighborsearch_2(data,best_temp_features,best_update,p,n,number_of_neighbors);
else 
    best_update = best_temp_centers;
    better=fitness_value;
    is_changed=0;
end


end

