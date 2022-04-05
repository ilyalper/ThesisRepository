function [init_rand_infeasibility_count,parent_assignments,parent_centers ] = random_init_center_assignment(p,d,q,n,data,init_start,init_end,parent_assignments,parent_centers)

kk=init_start;
init_rand_infeasibility_count=0;

while kk < init_end+1
    reshuffle=1;
    %feasible bir assignment yaptığımızdan emin oluyoruz.
    while reshuffle == 1
        %tüm noktaları sırayla random bir clustera atıyoruz
        for i=1:n
            p3(i)=unidrnd(p);
        end
        %Herhangi bir clustera hiç bir data point atanmamış ise o clustera
        if length(unique(p3))~= p
            reshuffle=1;
        else
            reshuffle=0;
        end
    end
    
    %Ardından random centerlar, randomly yapılan assignmentın içinden seçiliyor
    for i = 1:p
        %önce i'inci clustera atanan assignmentları grupluyoruz ardından bu gruptan 1 tanesini randperm le seçiyoruz.
        assigned_orders_of_i=find(p3==i);
        temp_random_center=randperm(length(assigned_orders_of_i),1);
        %Ardından baştaki liste assigned_orders_of_i'den ilgili data
        %center'ın endeksini çekiyoruz ve cluster center olarak atıyoruz.
        cluster_centers(i)=assigned_orders_of_i(temp_random_center);
    end
    
    
    uniqueness_test=1;
    for i=1:kk-1
        
        if sum((parent_assignments(i,:)==p3))==n && sum(parent_centers(i,:)==cluster_centers)==p
            uniqueness_test=0;
            init_rand_infeasibility_count=init_rand_infeasibility_count+1;
            % aslında burada bu elseife gerek yok
        elseif length(unique(cluster_centers)) ~= length(cluster_centers)
            uniqueness_test=0;
            init_rand_infeasibility_count=init_rand_infeasibility_count+1;
        end
    end
    if uniqueness_test==1
        parent_assignments(kk,:) = p3;
        parent_centers(kk,:) = cluster_centers;
        kk=kk+1;
    end
    
end

end