function [init_rand_infeasibility_count,parent_features,parent_centers ] = random_initialization(p,d,q,population_size,n,data,init_start,init_end)


%Initial generation of the population
% ilk önce initial population'un yarısını random olarak
% oluşturuyoruz.
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
        
        %silinecek gibi?
        temp_selection((i-1)*d+1:i*d)= data(p2(i),:);
    end
    
    
    
    % önce data pointleri kontrol ediyoruz, eğer bir set
    % birden fazla aynı point'i center almışsa onu dikkate
    % almayıp başa dönmesini sağlıyoruz.
    if length(unique(p2)) == length(p2)
        parent_features(k,:) = p1;
        parent_centers(k,:) = p2;
        k=k+1;
    else
        init_rand_infeasibility_count=init_rand_infeasibility_count+1;
    end
end

end
