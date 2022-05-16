function [init_rand_infeasibility_count,parent_features,parent_centers ] = random_init_feature_assignment(p,d,q,n,data,init_start,init_end,parent_features,parent_centers)

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
    
    %Ardından random featurelar seçiliyor
    p1= zeros(1,d*p);
    for i = 1:p
        % select the initial random features
        a = randperm(d,q);
        p1(a+((i-1)*d)) = 1;
        
    end
    
    %Son olarak seçili olan featurelar ve atanmış assignmentlar doğrultusunda
    %cluster centerlar belirleniyor
    for i = 1:p
        %rastgele atanan clusterlar için indexleri çekip sonra ilgili
        %fature'larla çarpıyoruz.
        assigned_orders_of_i=find(random_assignment==i);
        current_cluster_assignment=p1((i-1)*d+1:i*d).*data(assigned_orders_of_i,:);
        
        %ardından her cluster için içerdiği data pointler üzerinden bir
        %uzaklık hesaplıyoruz.
        [len1 len2]=size(current_cluster_assignment);
        cluster_distance=[];
        for j=1:len1
            cluster_distance(j,:) = sum(abs((current_cluster_assignment - repmat(current_cluster_assignment(j,:),len1,1))));
        end
        %hesaplanan uzaklıklardan minimum uzaklığa sahip olan datapointi
        %cluster centeri olarak atıyoruz.
        center_of_ith_cluster=find((sum(cluster_distance,2)==min(sum(cluster_distance,2))));
        
        %eğer ki 1 den fazla center aynı uzaklığa sahip olursa içlerinden
        %birini randomly seçiyoruz
        if length(center_of_ith_cluster)>1
            center_of_ith_cluster=center_of_ith_cluster(unidrnd(length(center_of_ith_cluster)));
        end
        
        cluster_centers(i)=assigned_orders_of_i(center_of_ith_cluster);
    end
    
    uniqueness_test=1;
    for i=1:kk-1
        
        if d==q
            %do nothing just choose all features
        elseif sum((parent_features(i,:)==p1))==d*p && sum(parent_centers(i,:)==cluster_centers)==p
            uniqueness_test=0;
            init_rand_infeasibility_count=init_rand_infeasibility_count+1;
        elseif length(unique(cluster_centers)) ~= length(cluster_centers)
            uniqueness_test=0;
            init_rand_infeasibility_count=init_rand_infeasibility_count+1;
        end
    end
    if  uniqueness_test==1
        parent_features(kk,:) = p1;
        parent_centers(kk,:) = cluster_centers;
        kk=kk+1;
    end
    
    
end

end