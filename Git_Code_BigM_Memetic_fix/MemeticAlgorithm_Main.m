clear all
clc

ga_index_of_the_set = 1
% İlk olarak kullanacağımız data setini ve toplam featureların setini oluşturuyoruz
% N or n data sayısı
% orig_M or d toplam feature sayısını
% p toplam cluster sayısını
% q her cluster'da kullanılacak olan feature sayısını
ga_summary=[]; ga_checkpoint_summary=[]; ga_checkpoint_towrite=[];

p = 2; % number of clusters in each parent

param_features_is_taken = 1;

N=[80,100,200,500,1000]
%N=[80,100,200]
N=[500]

ga_clustering_control = [ones(1,N/2), 2*ones(1,N/2)];
ga_clustering_limits = [1,N/2;N/2+1,N];

bestfitness_values=ones(50,100);
%
Set_of_M = [5,6,8,10,12]
Set_of_M = [8]

%0 means no mutation, 1 means 1-type mutation, 2 means 3-type mutation
param_mutation_type= 2;
param_mutation_probability=0.03; %mutasyona girme olasılığını da buradan giriyoruz

%0 means no NS, 1 means recursion is allowed, 2 means 2 iteration is allowed
param_neighborsearchtype=2;
param_number_of_neighbors=10; % kontrol edilecek olan neighbor sayısına buradan bakabiliriz.

%0 means no NS_feature, 1 means yes NS_feature
param_neighbor_feature_searchtype=0;




%Her bir [m,p,q,n] seti için kaç repetition yapılacağını belirliyoruz
ga_number_of_repetition=3;

param_number_of_generations = 4;
param_checkpoint_repetition = 2;

%Initial population için ilk kırılımdaki oranları kümülatif olarak giriyoruz
param_init_random_ratio=0.5;
param_second_random_ratio = 0.75;
param_third_random_ratio = 1;


%Çıktılarımızı yazdıracağımız dokümanın adını baştan belirliyoruz.
ga_filename = ['results_p', num2str(p),'_Mut',num2str(param_mutation_type), '_NS',num2str(param_neighborsearchtype),'.xlsx'];



for iiii=1:length(N)
    n=N(iiii);
    % algoritma boyunca kullanılacak populasyon büyüklüğünü belirliyoruz
    % population size
    if n<250
        param_population_size=500
    else
        param_population_size=n
    end
    
    param_population_size=1000;
    
    for jjj=1:length(Set_of_M)
        orig_m=Set_of_M(jjj);
        d=orig_m;
        param_q_tobe_read = 4;
        for q=4:4
            clearvars -except ga_* q p n Set_of_M d orig_m orig_M N param_*
            
            %% Data Input Start
            %Buraya Datasets klasörünü koyduğumuz Path'i yazıyoruz ya da cd
            %ile path i alıyoruz
            pathh = cd;% cd işe yaramazsa yedek pathh= ('/Users/ilyasalpersener/Desktop/ThesisModel/Matlab/')
            [data, ga_Sheet_Name,param_preselected_set_of_features] = read_data(pathh,p,n,orig_m,q,param_features_is_taken);
            % Data Input End
            
            %% Start of GA
            
            for ga_algorithm_repetition=1:ga_number_of_repetition
                
                % o ana kadar elimizde olan parametreleri sıfırlıyoruz
                clearvars -except ga_* param_* data* q p n d Set_of_M orig_m orig_M N feature_indexes ;
                
                tic % Süre tutmaya başlıyoruz, her GA de ayrı bir süre tutuyoruz.
                %% Initializations  - Start
                % generation of the Initial population
                
                parent_features=[];parent_centers=[];
                checkpoint_index=0;
                % ilk önce initial population'un seçtiğimiz bir oranını
                % random feature ve random center seçerek oluşturuyoruz.
                
                
                if param_init_random_ratio~=0
                    init_rand_start=1; init_rand_end=ceil(param_population_size*param_init_random_ratio);
                    [init_rand_infeasibility_count,parent_features,parent_centers ] = random_initialization(p,d,q,param_population_size,n,data,init_rand_start,init_rand_end);
                end
                
                % random feature seçimi ve random assignment ile initial populasyonun bir kısmını oluşturma.
                if param_second_random_ratio-param_init_random_ratio~=0
                    init_rand_feature_start=ceil(param_population_size*param_init_random_ratio)+1;
                    init_rand_feature_end=ceil(param_population_size*param_second_random_ratio);
                    [init_rand_infeasibility_count,parent_features,parent_centers ] = random_init_feature_assignment(p,d,q,n,data,init_rand_feature_start,init_rand_feature_end,parent_features,parent_centers);
                end
                
                % random center seçimi ve random assignment ile initial populasyonun bir kısmını oluşturma.
                %Not: aslında param_third_random_ratio = 1 diye assume edip
                %buradan ilerleyebilirdik ama ek bir tanım gerekirse
                %diye onu da oransal tuttum.
                if param_third_random_ratio-param_second_random_ratio~=0
                    init_rand_center_start=ceil(param_population_size*param_second_random_ratio)+1;
                    init_rand_center_end=ceil(param_population_size*param_third_random_ratio);
                    [init_rand_infeasibility_count,parent_features,parent_centers ] = random_init_center_assignment(p,d,q,n,data,init_rand_center_start,init_rand_center_end,parent_features,parent_centers);
                end
                
                
                % initial'da oluşan seti kontrol etmek için aşağıdaki iki satır kullanılabilir
                %ga_initial_parent_features = parent_features;
                %ga_initial_parent_centers = parent_centers;
                % Initializations end
                
                %% parent selection for the first generation
                
                for i=1:param_population_size
                    [fitness_set(i), clusters] = cluster_update(data,parent_features(i,:),parent_centers(i,:),p,n,d);
                    current_population_feature_set(i,:) = parent_features(i,:);
                    current_population_center_set(i,:) = parent_centers(i,:);
                end
                
                %sorting
                [ordering index] = sort(fitness_set,'ascend');
                new_parent_feature_set_temp = current_population_feature_set(index,:);
                new_parent_center_set_temp = current_population_center_set(index,:);
                
                new_parent_feature_set = new_parent_feature_set_temp (1:param_population_size,:);
                new_parent_center_set = new_parent_center_set_temp (1:param_population_size,:);
                
                %% start of Generations
                generation_index=0;
                ind=0;
                keep_going=1; % eğer 10 jenerasyon boyunca iyileştirme yoksa algoritmamızı durduruyoruz.
                
                while generation_index < param_number_of_generations && ind~=1 && keep_going==1
                    generation_index=generation_index+1;
                    ind=1;
                    
                    %% do cross-over operation for all parents
                    %[ind,child_centers,child_features]= crossover(ind,p,d,population_size,feature_indexes,new_parent_feature_set,new_parent_center_set);
                    
                    [ind,child_centers,child_features]= uniform_crossover(ind,p,d,param_population_size,new_parent_feature_set,new_parent_center_set);
                    % Cocuklar oluştuktan sonra, parentlarla birleştirerek
                    % yeni populasyonumuzu oluşturmuş oluyoruz.
                    current_population_feature_set=[]; current_population_center_set=[];
                    current_population_feature_set= [new_parent_feature_set; child_features];
                    current_population_center_set = [new_parent_center_set; child_centers];
                    [current_inhabitants, columns_total1] = size(current_population_center_set);
                    
                    %%% Crossover - end
                    
                    %% Mutation - start
                    
                    % burada elimizdeki en iyi noktayı mutasyona sokmamak
                    % mantıklı olur mu?? yoksa randomnessta bir problem
                    % oluşturur mu
                    
                    % mutation operation
                    mutation_count=0;
                    if param_mutation_type==0
                    elseif param_mutation_type ==1
                        
                        for i=1:current_inhabitants
                            r=rand;
                            if r < param_mutation_probability
                                %new_parent_feature_set(i,:) = mutation_trial(new_parent_feature_set(i,:),p,r,param_mutation_probability);
                                current_population_feature_set(i,:) = mutation(current_population_feature_set(i,:),p);
                                mutation_count=mutation_count+1;
                            end
                        end
                    elseif param_mutation_type ==2
                        for i=1:current_inhabitants
                            r=rand;
                            if r < param_mutation_probability
                                current_population_feature_set(i,:) = mutation_trial(current_population_feature_set(i,:),p,r,param_mutation_probability);
                                %new_parent_feature_set(i,:) = mutation(new_parent_feature_set(i,:),p);
                                mutation_count=mutation_count+1;
                            end
                        end
                    end
                    
                    %%% Mutation - end
                    
                    %% fitness calculation
                    
                    fitness_set=[];
                    
                    %for i=1:length(new_parent_set)
                    for i=1:current_inhabitants
                        [fitness_set(i), cluster_set] = cluster_update(data,current_population_feature_set(i,:),current_population_center_set(i,:),p,n,d);
                    end
                    
                    %% sorting
                    [ordering, index] = sort(fitness_set,'ascend');
                    new_parent_feature_set_temp = current_population_feature_set(index,:);
                    new_parent_center_set_temp = current_population_center_set(index,:);
                    
                    %% Neighbor Search
                    ga_ct=0;% neighborsearch ile ilgili count yapmak için kullanılan parametre
                    
                    if param_neighborsearchtype==0
                    elseif param_neighborsearchtype==1
                        [new_center_set_fromNS, best_fit, is_changed]= neighborsearch_recursive(data,new_parent_feature_set_temp(1,:),new_parent_center_set_temp(1,:),p,n,param_number_of_neighbors);
                        if is_changed==1
                            ga_ct=ga_ct+1;
                            new_parent_center_set_temp = [new_center_set_fromNS; new_parent_center_set_temp];
                            new_parent_feature_set_temp =[new_parent_feature_set_temp(1,:); new_parent_feature_set_temp];
                        end
                    elseif param_neighborsearchtype==2
                        [new_center_set_fromNS, best_fit, is_changed]= neighborsearch(data,new_parent_feature_set_temp(1,:),new_parent_center_set_temp(1,:),p,n,param_number_of_neighbors);
                        if is_changed==1
                            ga_ct=ga_ct+1;
                            new_parent_center_set_temp = [new_center_set_fromNS; new_parent_center_set_temp];
                            new_parent_feature_set_temp =[new_parent_feature_set_temp(1,:); new_parent_feature_set_temp];
                        end
                    end
                    
                    % NS'in sonuçlarını en başa, en iyi set olarak
                    % koyuyoruz
                    
                    %% Neighbor Search for features
                    
                    
                    if param_neighbor_feature_searchtype==1
                        [new_feature_set_fromNS, current_best_fitness, is_changed] =neighborsearch_feature(data,new_parent_feature_set_temp(1,:),new_parent_center_set_temp(1,:),p,n,q);
                        if is_changed==1
                            new_parent_center_set_temp = [new_parent_center_set_temp(1,:); new_parent_center_set_temp];
                            new_parent_feature_set_temp =[new_feature_set_fromNS; new_parent_feature_set_temp];
                        end
                    end
                    
                    
                    
                    
                    %% offspring selection
                    
                    new_parent_features_set_1 = new_parent_feature_set_temp (1:floor(param_population_size/20),:);
                    new_parent_center_set_1 = new_parent_center_set_temp (1:floor(param_population_size/20),:);
                    
                    %Random olan kısmı ekleyelim
                    A = find(fitness_set~=100000 & fitness_set>ordering(floor(param_population_size/20)));
                    B = length(A);
                    C = randperm(B);
                    
                    new_random_parent_features_set_temp1 = current_population_feature_set(A(C),:);
                    new_random_parent_center_set_temp1  = current_population_center_set(A(C),:);
                    
                    new_random_parent_features_set_temp2 = new_random_parent_features_set_temp1(1:(param_population_size-floor(param_population_size/20)),:);
                    new_random_parent_center_set_temp2 = new_random_parent_center_set_temp1(1:(param_population_size-floor(param_population_size/20)),:);
                    
                    new_parent_feature_set = [new_parent_features_set_1; new_random_parent_features_set_temp2];
                    new_parent_center_set = [new_parent_center_set_1; new_random_parent_center_set_temp2];
                    
                    %save_parent_set (generation_index,:,:) = new_parent_set;
                    
                    %% Value saving
                    bestfitness_set(generation_index) = ordering(1);
                    ga_bestfitness_values(ga_algorithm_repetition,generation_index)=min(fitness_set);
                    ga_worstfitness_values(ga_algorithm_repetition,generation_index)=max(fitness_set);
                    
                    bestparent(generation_index,:) = current_population_center_set(index(1),:);
                    number_of_mutations(generation_index) = mutation_count;
                    number_of_NS(generation_index) = ga_ct;
                    
                    
                    % Eğer best fitness'a göre bir CPU time kısaltması
                    % yapmak istersek diye tutuyorum
                    %if generation_index>19 && bestfitness_set(generation_index)==bestfitness_set(generation_index-10)
                    %    keep_going=0;
                    %end
                    
                    %burada her jenerasyondan sonra bir kontrol var, eğer
                    %en iyi fitness'a sahipsek o denemeye ait atamaları
                    %centerları ve seçilmiş feature'ları kaydediyoruz.
                    
                    if  generation_index==2
                        best_features=new_parent_features_set_1(1,:);
                        best_centers =new_parent_center_set_1(1,:);
                        [best_fitness_value, best_assignments] = cluster_update(data,best_features,best_centers,p,n,d);
                        for cluster_no=1:p
                            for k=1:p
                                cluster_allocation(cluster_no,k) = sum(best_assignments(ga_clustering_limits(k,1):ga_clustering_limits(k,2))== cluster_no);
                            end
                        end
                        total_ones = sum(best_assignments(1:n)==1); 
                    elseif generation_index>2 && bestfitness_set(generation_index) < min(bestfitness_set(1:generation_index-1))
                        best_features=new_parent_features_set_1(1,:);
                        best_centers =new_parent_center_set_1(1,:);
                        [best_fitness_value, best_assignments] = cluster_update(data,best_features,best_centers,p,n,d);
                        for cluster_no=1:p
                            for k=1:p
                                cluster_allocation(cluster_no,k) = sum(best_assignments(ga_clustering_limits(k,1):ga_clustering_limits(k,2))== cluster_no);
                            end
                        end
%                         first_cluster_set_1 = sum(best_assignments(1:n/2)==1);
%                         second_cluster_set_1 = sum(best_assignments(n/2+1:n)==1);
%                         first_cluster_set_2 = sum(best_assignments(1:n/2)==2);
%                         second_cluster_set_2 = sum(best_assignments(n/2+1:n)==2);
                        total_ones = sum(best_assignments(1:n)==1);
                    end                    
                    
                    
                    
                    %% Sonuçları yazdırma
                    
                    if mod (generation_index,param_checkpoint_repetition) == 0   && generation_index~= param_number_of_generations
                        checkpoint_index=checkpoint_index+1;
                        [aaa, bbb] = min(bestfitness_set);
                        ga_checkpoint_summary = [ga_checkpoint_summary;checkpoint_index,generation_index, aaa,bbb];
                    end
                    
                end
                
                
                ga_duration(ga_algorithm_repetition) = toc ;
                %bestfitness_set(number_of_generations);
                %mean(bestfitness_set);
                [aa, bb] = min(bestfitness_set);
                ga_results(ga_algorithm_repetition)=aa;
                ga_indexes(ga_algorithm_repetition)=bb;
                ga_neighborsearch(ga_algorithm_repetition) = sum(number_of_NS);
                ga_total_mutate(ga_algorithm_repetition) = sum(number_of_mutations);
                
                
                %Saving best assignments in a cell array
                dataset_name = ['clusters', num2str(p),'_m',num2str(d), '_n',num2str(n),'_q',num2str(q),'_trial',num2str(ga_algorithm_repetition)];
                ga_saved_cell{ga_index_of_the_set,1}=q;
                ga_saved_cell{ga_index_of_the_set,2}=dataset_name;
                ga_saved_cell{ga_index_of_the_set,3}=best_fitness_value;
                ga_saved_cell{ga_index_of_the_set,4}=best_centers;
                ga_saved_cell{ga_index_of_the_set,5}=best_features;
                ga_saved_cell{ga_index_of_the_set,6}=best_assignments;
                ga_saved_cell{ga_index_of_the_set,7}=cluster_allocation(1,1);
                ga_saved_cell{ga_index_of_the_set,8}=cluster_allocation(1,2);
                ga_saved_cell{ga_index_of_the_set,9}=cluster_allocation(2,1);
                ga_saved_cell{ga_index_of_the_set,10}=cluster_allocation(2,2);
                ga_saved_cell{ga_index_of_the_set,11}=total_ones;
                ga_index_of_the_set=ga_index_of_the_set+1;
              
                
            end
            
            %% Sonuçları yazdırma
            
            Final = [ga_results' ga_indexes' ga_duration' ga_total_mutate' ga_neighborsearch'];
            table_results = array2table(Final);
            writetable(table_results,ga_filename,'Sheet',ga_Sheet_Name);
            best_of_all=min(ga_results);
            worst_of_all=max(ga_results);
            ga_summary=[ga_summary; n, p, q, orig_m, best_of_all, worst_of_all, mean(ga_results), median(ga_results),mean(ga_duration), sum(ga_results==best_of_all), sum(ga_results==worst_of_all)];
            %ga_results=[];ga_indexes=[];ga_duration=[];ga_total_mutate=[];ga_neighborsearch=[];
            
            for i=1:max(ga_checkpoint_summary(:,1))
                checkpoint_final= ga_checkpoint_summary(find(ga_checkpoint_summary(:,1)==i),:);
                checkpoint_final_towrite = array2table(checkpoint_final);
                this_Sheet_Name = [num2str(ga_checkpoint_summary(i,2)),'_',ga_Sheet_Name];
                writetable(checkpoint_final_towrite,ga_filename,'Sheet',this_Sheet_Name);
                
                best_of_all_check=min(checkpoint_final(:,3));
                worst_of_all_check=max(checkpoint_final(:,3));
                
                ga_checkpoint_towrite=[ga_checkpoint_towrite;n, p, q, orig_m, ga_checkpoint_summary(i,2),best_of_all_check,worst_of_all_check,mean(checkpoint_final(:,3)), median(checkpoint_final(:,3)),0,sum(checkpoint_final(:,3)==best_of_all_check),sum(checkpoint_final(:,3)==worst_of_all_check)];
            end
            
            ga_checkpoint_summary = [];
        end
    end
end

writematrix(ga_summary,ga_filename,'Sheet','SummaryOfResults');

writematrix(ga_checkpoint_towrite,ga_filename,'Sheet','SummaryOfResults_Checkpoints');