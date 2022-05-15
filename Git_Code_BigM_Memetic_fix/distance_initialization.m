function [init_distance_infeasibility_count,parent_features,parent_centers ] = distance_initialization(p,d,q,population_size,n,data,init_random_ratio,parent_features,parent_centers)

kk=population_size*(1-init_random_ratio)+1;
start_set=kk;
init_distance_infeasibility_count=0;

while kk < population_size+1
    
    p1= zeros(1,d*p);
    
    for i = 1:p
        % select the initial random features
        a = randperm(d,q);
        p1(a+((i-1)*d)) = 1;
    end
    
    for i = 1:p
        data_temp = data.*p1(d*(i-1)+1:d*i);
        for j=1:n
            center_cantidate(j)=sum(sum(abs(data_temp - repmat(data_temp(j,:),n,1))));
        end
        [a center_temp(i)] = min(center_cantidate);
    end
    
    uniqueness_test=1;
    for i=1:kk-1
        
        if sum((parent_features(i,:)==p1))==d*p && sum(parent_centers(i,:)==center_temp)==p
            uniqueness_test=0;
            init_distance_infeasibility_count=init_distance_infeasibility_count+1;
        elseif length(unique(center_temp)) == length(center_temp)
            uniqueness_test=0;
            init_distance_infeasibility_count=init_distance_infeasibility_count+1;
        else
            parent_features(kk,:) = p1;
            parent_centers(kk,:) = center_temp;
            kk=kk+1;
        end
    end
    
    
    
end
