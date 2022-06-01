function [init_rand_infeasibility_count,parent_features,parent_centers ] = random_init_center_assignment(p,d,q,n,data,init_start,init_end,parent_features,parent_centers)

kk=init_start;
init_rand_infeasibility_count=0;

while kk < init_end+1
    reshuffle=1;
    %feasible bir assignment yaptığımızdan emin oluyoruz.
    while reshuffle == 1
        %tüm noktaları sırayla random bir clustera atıyoruz
        for i=1:n
            random_assignment(i)=unidrnd(p);
        end
        %Herhangi bir clustera hiç bir data point atanmamış ise o clustera
        if length(unique(random_assignment))~= p
            reshuffle=1;
        else
            reshuffle=0;
        end
    end
    
    %Ardından random featurelar, randomly yapılan assignmentın içinden seçiliyor
    for i = 1:p
        %önce i'inci clustera atanan assignmentları grupluyoruz ardından bu gruptan 1 tanesini randperm le seçiyoruz.
        assigned_orders_of_i=find(random_assignment==i);
        temp_random_center=randperm(length(assigned_orders_of_i),1);
        %Ardından baştaki liste assigned_orders_of_i'den ilgili data
        %center'ın endeksini çekiyoruz ve cluster center olarak atıyoruz.
        cluster_centers(i)=assigned_orders_of_i(temp_random_center);
    end
    
    %Son olarak seçili olan center ve atanmış assignmentlar doğrultusunda
    %cluster featurelar belirleniyor
    for i = 1:p
        
        assigned_orders_of_i=find(random_assignment==i);
        number_of_points=length(assigned_orders_of_i);
        for j=1:d
            feature_distance(j,:) = sum(abs((data(assigned_orders_of_i,j) - repmat(data(cluster_centers(i),j),number_of_points,1))));
        end
        [ordering, index] = sort(feature_distance,'ascend');
        current_cluster_assignment=zeros(1,d);
        current_cluster_assignment(index(1:q))=1;
        p1((i-1)*d+1:i*d)=current_cluster_assignment;
        
    end
    
    uniqueness_test=1;
    for i=1:kk-1
        
        if sum((parent_features(i,:)==p1))==d*p && sum(parent_centers(i,:)==cluster_centers)==p
            uniqueness_test=0;
            init_rand_infeasibility_count=init_rand_infeasibility_count+1;
            % aslında burada bu elseife gerek yok
        elseif length(unique(cluster_centers)) ~= length(cluster_centers)
            uniqueness_test=0;
            init_rand_infeasibility_count=init_rand_infeasibility_count+1;
        end
    end
    if uniqueness_test==1
        parent_features(kk,:) = p1;
        parent_centers(kk,:) = cluster_centers;
        kk=kk+1;
    end
    
end

end