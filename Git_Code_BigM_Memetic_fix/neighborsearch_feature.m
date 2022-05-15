function [best_features, current_best_fitness, is_changed] =neighborsearch_feature(data,best_temp_features,best_temp_centers,p,n,q)
%best_temp_features=[0     1    0    0     0         1   1         1         0     0 0    0   ]
%p=2;n=80;q=2
%best_temp_centers = [55,66];
is_changed=0;
dd=length(best_temp_features)/p ;
best_features=best_temp_features;
selected_features_index=[];
not_selected_features_index=[];
%ilk önce her cluster'ımıza ait seçili featureları listeliyoruz
for i=1:p
    selected_features_index(i,:) = find(best_temp_features(dd*(i-1)+1:dd*i));
    not_selected_features_index(i,:) = find(1-best_temp_features(dd*(i-1)+1:dd*i));
end
%p*q'luk bir matris elde ettik


% manhattan distance is utilized for assignment

cluster_distance=[];
for i=1:p
    
    %merkez noktamızın seçili feature'lar cinsinden değeri
    center_of_selected_features = best_temp_features(dd*(i-1)+1:dd*i).*data(best_temp_centers(i),:);
    
    % bu satırda önce i'inci center ile tüm noktaların uzaklıklarını
    % alıyoruz, ardından bu matrisin absolute value sını seçili olan
    % featurelar ile çarpıp toplamını alıyoruz, böylece her noktanın her
    % centera olan uzaklığını hesaplamış oluyoruz (n*p matris)
    cluster_distance(:,i) = sum(abs((data - repmat(center_of_selected_features,n,1)).*best_temp_features(dd*(i-1)+1:dd*i)),2);
    
end

% her point'in atandığı noktaya uzaklığı ve kime atanmığı bilgisi
[distance_of_point, cluster_set] = min(cluster_distance,[],2);




%sonra seçili olan featurelar üzerinden fitness a olan katkıyı hesaplıyoruz.
distance_of_selected=[];
substituted_feature=[];
for i=1:p
    %ilk önce bir clustera girelim sonra ilgili clusterın uzunluğunu bulalım
    [set_length, ~]=size(find(cluster_set==i));
    %ilgili centerdaki seçili featureların valularını çekiyoruz
    values_of_center_i=data(best_temp_centers(i),selected_features_index(i,:));
    %o centera atanan datapointlerin ilgili featurelar üzerinden value
    %larını çekiyorum.
    comparison_of_data=data(cluster_set==i,selected_features_index(i,:));
    %son olarak repmat ile her bir feature üzerinden uzaklık hesaplıyorum.
    if sum(sum(abs(comparison_of_data - repmat(values_of_center_i,set_length,1))))==0
        distance_of_selected(i,:) = zeros(1,q);
    else
        
        distance_of_selected(i,:) = sum(abs(comparison_of_data - repmat(values_of_center_i,set_length,1)));
    end 
    
    [~, b] = min(distance_of_selected(i,:));
    substituted_feature(i) = selected_features_index(i,b);
end

%fitness'ımız distance_of_selected'ın totaline eşit olacaktır.
fitness_value = sum(sum(distance_of_selected));

current_best_fitness=fitness_value;

test_features=best_temp_features;
for i=1:p
    for j=1:(dd-q)
        test_features=best_temp_features;
        test_features(dd*(i-1)+not_selected_features_index(i,j))=1;
        test_features(dd*(i-1)+substituted_feature(i))=0;
        
        [test_fitness,~] = cluster_update (data, test_features,best_temp_centers,p,n,dd);
        
        if test_fitness<current_best_fitness
            current_best_fitness=test_fitness;
            best_features=test_features;
            is_changed=1;
        end
    end
end

end

