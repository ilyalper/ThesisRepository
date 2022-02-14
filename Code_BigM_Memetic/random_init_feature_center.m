function [init_rand_infeasibility_count,parent_assignments,parent_centers ] = random_init_feature_center(p,d,q,n,data,init_start,init_end)


%Initial generation of the population
% ilk önce initial population'un istenen kadarını random feature ve center
% seçerek oluşturuyoruz.
k=init_start;
init_rand_infeasibility_count=0;
while k < init_end+1
    %p1 = unidrnd(2,1,d*2)-1;
    p1= zeros(1,d*p);
    temp_selection=[];
    for i = 1:p
        % select the initial random features
        a = randperm(d,q);
        p1(a+((i-1)*d)) = 1;
        
        %select the initial random datapoints
        p2(i) = randperm(n,1);
        
        
        center_of_selected_features = p1(d*(i-1)+1:d*i).*data(p2(i),:);
   
        cluster_distance(:,i) = sum(abs((data - repmat(center_of_selected_features,n,1)).*p1(d*(i-1)+1:d*i)),2);

    end
    
   [distance_of_point, cluster_set] = min(cluster_distance,[],2);
 
    p3=cluster_set';
    
    % burada data pointleri kontrol ediyoruz, eğer bir set
    % birden fazla aynı point'i center almışsa onu dikkate
    % almayıp başa dönmesini sağlıyoruz.
    if length(unique(p2)) == length(p2)
        parent_assignments(k,:) = p3;
        parent_centers(k,:) = p2;
        k=k+1;
    else
        init_rand_infeasibility_count=init_rand_infeasibility_count+1;
    end
end



end
