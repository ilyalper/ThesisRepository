function[fitness_value, cluster_set] = cluster_update (data, feature_set,center_set,p,n,d)
%absolute_distance'a göre clusterlara assignment yapılıyor ve  her cluster
%için fitness hesaplanıyor

%[n d] = size(data);

dd=length(feature_set)/p; % number of clusters

% manhattan distance is utilized for assignment

cluster_distance=[];
for i=1:p
    
    %merkez noktamızın seçili feature'lar cinsinden değeri
    center_of_selected_features = feature_set(dd*(i-1)+1:dd*i).*data(center_set(i),:);
    
    % bu satırda önce i'inci center ile tüm noktaların uzaklıklarını
    % alıyoruz, ardından bu matrisin absolute value sını seçili olan
    % featurelar ile çarpıp toplamını alıyoruz, böylece her noktanın her
    % centera olan uzaklığını hesaplamış oluyoruz (n*p matris)
    cluster_distance(:,i) = sum(abs((data - repmat(center_of_selected_features,n,1)).*feature_set(dd*(i-1)+1:dd*i)),2);
end

% her point'in atandığı noktaya uzaklığı ve kime atanmığı bilgisi
[distance_of_point, cluster_set] = min(cluster_distance,[],2);

for j=1:p
    fitness(j) = sum((distance_of_point.*(cluster_set==j)));
end

fitness_value = sum(fitness);

end