function [best_update better] =neighborsearch_2(data,best_temp_features,best_temp_centers,p,n,number_of_neighbors)
%best_temp_features=[1     0    0    0     0         1   1         1         0     0 0    0   ]

%best_temp_centers = [33,99];

dd=   length(best_temp_features)/p ;


%Önce fitness ı hesaplıyoruz
best_feature_values=[];
cluster_distance=[];
for i=1:p
    
    %merkez noktamızın seçili feature'lar cinsinden değeri
    center_of_selected_features = best_temp_features(dd*(i-1)+1:dd*i).*data(best_temp_centers(i),:);
    
    %komşulara bakarken mevcut değerleri de kullanacağımız için burada
    %kayıt ediyoruz.
    
    best_feature_values=[best_feature_values, center_of_selected_features];
    % bu satırda önce i'inci center ile tüm noktaların uzaklıklarını
    % alıyoruz, ardından bu matrisin absolute value sını seçili olan
    % featurelar ile çarpıp toplamını alıyoruz, böylece her noktanın her
    % centera olan uzaklığını hesaplamış oluyoruz (n*p matris)
    cluster_distance(:,i) = sum(abs((data - repmat(center_of_selected_features,n,1)).*best_temp_features(dd*(i-1)+1:dd*i)),2);
end

% her point'in atandığı noktaya uzaklığı ve kime atandığı bilgisi
[distance_of_point, cluster_set] = min(cluster_distance,[],2);

for j=1:p
    fitness(j) = sum((distance_of_point.*(cluster_set==j)));
end

fitness_value = sum(fitness);


%Sonra en yakın number_of_neighbors tane (su an 10) nokta üzerinden tekrar birer fitness hesaplıyoruz.
test_centers=repmat(best_temp_centers,number_of_neighbors*p,1);
test_centroids_features= repmat(best_feature_values,number_of_neighbors*p,1);
[ordering, index] = sort(cluster_distance(:,:),'ascend');

for k=1:number_of_neighbors
    for i=1:p
        test_centroids_features(k*p+1-i,dd*(i-1)+1:dd*i) = best_temp_features(dd*(i-1)+1:dd*i).* data(index(k+1,i),:);
        test_centers(k*p+1-i,i)=index(k+1,i);
    end
end


%Ardından yeni adaylar için (10*m) fitness hesaplıyoruz
cluster_distancei=[];
for new_trials = 1:number_of_neighbors*p
    
    temp_set=test_centroids_features(new_trials,:);
    
    for i = 1:p
        cluster_distancei(:,i) = sum(abs((data - repmat(temp_set(dd*(i-1)+1:dd*i),n,1)).* best_temp_features(dd*(i-1)+1:dd*i)),2);
    end
    
    [a, cluster_set] = min(cluster_distancei,[],2);
    
    for j=1:p
        fitnessi(j) = sum((a.*(cluster_set==j)));
    end
    
    fitness_value_new(new_trials) = sum(fitnessi);
    
end

[temp_min_fitness, temp_index] = min(fitness_value_new);

if temp_min_fitness<fitness_value
    best_update = test_centers(temp_index,:);
    better=temp_min_fitness;
else 
    best_update = best_temp_centers;
    better=fitness_value;
end


end

