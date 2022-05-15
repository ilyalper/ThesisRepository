function [init_kmedoid_infeasibility_count,parent_features,parent_centers ] = medoid_initialization(p,d,q,population_size,n,data,init_random_ratio,parent_features,parent_centers)

kk=population_size*init_random_ratio+1;

init_kmedoid_infeasibility_count=0;

while kk < population_size+1
    
    
    p1=zeros(1,d);
    temp_selection=[];
    a = randperm(d,q);
    p1(a) = 1;
    
    [idx, selected_center_of_clusters, cluster_distance, each_distance, p2] = kmedoids(data.*p1,p,'Distance','cityblock');
    
    temp_kmedoid =[];
    for i = 1:p
        temp_kmedoid = [temp_kmedoid p1];
    end
    
    %parent_test = init_test_manhattan(data,temp_kmedoid,m);
    if length(unique(p2)) == length(p2)
        parent_features(kk,:) = temp_kmedoid;
        parent_centers(kk,:) = p2;
        kk=kk+1;
    else
        init_kmedoid_infeasibility_count=init_kmedoid_infeasibility_count+1;
    end
end