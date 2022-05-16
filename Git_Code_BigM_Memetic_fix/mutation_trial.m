function final_feature_set= mutation_trial(feature_set,p,r,mutation_probability)
%r=rand
%mutation_probability = 1;
%feature_set=[0,0,0,0,1,1,1,0,0,0,1,0];
%p=2;
d = length(feature_set)/p;

%Mutasyon tip 1
if r< mutation_probability/3
    %Hangi clustera gireceğimi seçiyorum
    i = unidrnd(p);
    %İlgili clustera ait featureları bir sette topluyorum
    mutated_feature_set=feature_set(d*(i-1)+1:d*i);
    
    if (sum(mutated_feature_set)==length(mutated_feature_set)) || (sum(mutated_feature_set)==0)
        %Eğer tüm featurelar seçiliyse ya da 0 adet feature seçiliyse
        %burada bir problem var demektir, kontrol mesajı atıyorum.
        final_feature_set=feature_set;
        fprintf('please control mutation operator');
    else
        [unneces one_indexes] = find(mutated_feature_set==1);
        [unneces zero_indexes] = find(mutated_feature_set==0);
        
        mutated_feature_set(one_indexes(unidrnd(length(one_indexes))))=0;
        mutated_feature_set(zero_indexes(unidrnd(length(zero_indexes))))=1;
        
        feature_set(d*(i-1)+1:d*i) = mutated_feature_set;
        final_feature_set=feature_set;
        tip=1;
    end
    
    %Mutasyon tip 2
    %Yine bir adet feature seçiyoruz ve
elseif r>= mutation_probability/3 && r<= mutation_probability*(2/3)
    %Hangi clustera gireceğimi seçiyorum
    i = unidrnd(p);
    %İlgili clustera ait featureları bir sette topluyorum
    mutated_feature_set=feature_set(d*(i-1)+1:d*i);
    
    if (sum(mutated_feature_set)==length(mutated_feature_set)) || (sum(mutated_feature_set)==0)
        %Eğer tüm featurelar seçiliyse ya da 0 adet feature seçiliyse
        %burada bir problem var demektir, kontrol mesajı atıyorum.
        final_feature_set=feature_set;
        fprintf('please control mutation operator');
    else
        %İlgili feature setteki seçili featureları rastgele olarak dağıtıyoruz.
        j = randperm(d,sum(mutated_feature_set));
        mutated_feature_update=zeros(1,d);
        mutated_feature_update(j)=1;
        feature_set(d*(i-1)+1:d*i) = mutated_feature_update;
        final_feature_set=feature_set;
        tip=2;
    end
    %Mutasyon tip 3
    %BUrada tip 1 de yaptığımızı tüm feature setlerde yapıyoruz
else
    %Hangi clustera gireceğimi seçiyorum
    i = 1;
    while i<=p
        
        %İlgili clustera ait featureları bir sette topluyorum
        mutated_feature_set=feature_set(d*(i-1)+1:d*i);
        
        if (sum(mutated_feature_set)==length(mutated_feature_set)) || (sum(mutated_feature_set)==0)
            %Eğer tüm featurelar seçiliyse ya da 0 adet feature seçiliyse
            %burada bir problem var demektir, kontrol mesajı atıyorum.
            final_feature_set=feature_set;
            fprintf('please control mutation operator');
        else
            [unneces one_indexes] = find(mutated_feature_set==1);
            [unneces zero_indexes] = find(mutated_feature_set==0);
            
            mutated_feature_set(one_indexes(unidrnd(length(one_indexes))))=0;
            mutated_feature_set(zero_indexes(unidrnd(length(zero_indexes))))=1;

            final_feature_set(d*(i-1)+1:d*i)=mutated_feature_set;
            tip=3;
        end
        i=i+1;
    end
    
    
      
end


end





