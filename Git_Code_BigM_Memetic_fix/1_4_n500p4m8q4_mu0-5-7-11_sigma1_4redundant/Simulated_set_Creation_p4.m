%%
clear
clc

% N data sayısı
% M toplam feature sayısı
% p toplam cluster sayısı
% q her cluster'da kullanılacak olan feature sayısı

N=[500];
Q=[4];
M=[300,500,750,1000];
M=[8];
p=4;
index_of_the_set=0;
number_of_created_sets=length(N)*length(M)*length(Q);
for n_index=1:length(N)
    n=N(n_index);
    for q_index=1:length(Q)
        q=Q(q_index);
        for m_index=1:length(M)
            m=M(m_index);
            made_obj=0;  % her yeni seti oluştururken true_objective value'yu 0 layalım
            index_of_the_set=index_of_the_set+1; % en sonda cell array'e kaydetmek için veri oluşturma endeksimizi tutalım
            var_value=0;
            selected_feature_save=[];
            sigma_coefficient=1;
            
            
            first_limit=n/4;
            second_limit=n/2;
            third_limit=3*n/4;
            fourth_limit=n;
            %ilk önce tüm dataset için redundantlardan oluşan bir dataset oluşturalım
            %ardından oluşturduğumuz normal dağılımları overwrite edeceğiz
            
            for i=1:m
                k=rand;
                if k<1/4
                    %Uniform distribution [0,10]
                    redundant_dataset(:,i) = 0 + (10-0).*rand(n,1);
                elseif k>=1/4 && k<2/4
                    %Uniform distribution [0,20]
                    redundant_dataset(:,i) = 0 + (20-0).*rand(n,1);
                elseif k>=2/4 && k<3/4
                    %Uniform distribution [0,5]
                    redundant_dataset(:,i) = 0 + (5-0).*rand(n,1);
                else
                    %Uniform distribution [-10,0]
                    redundant_dataset(:,i) = 0 + (0-10).*rand(n,1);
                end
            end
            
            deneme_1_2=redundant_dataset;
            
            %Cluster 1
            mu_1 = 0*ones(1,q);   % mean of 1st cluster
            sigma_1 = sigma_coefficient*(eye(q)+(var_value*(1-eye(q))));    % standart errors of 1st cluster
            rng('shuffle')  % For reproducibility
            %first, create datas for selected features (q)
            cluster1_n_over_p_top = mvnrnd(mu_1,sigma_1,n/p);
            % then, calculate the total distance for each datapoint with
            % respect to created values of selected q features
            for j=1:length(cluster1_n_over_p_top)
                minimum_distance(j) = sum(sum(abs((cluster1_n_over_p_top - repmat(cluster1_n_over_p_top(j,:),n/p,1)))));
            end
            %minimum of the distance is selected as the cluster center and
            %its distance value is saved in true obj
            made_obj = min(minimum_distance);
            
            %data creation for cluster 2, which is almost identical to cluster 1
            %Cluster 2 Gaussian Cluster
            mu_2 = 5*ones(1,q);
            sigma_2 = sigma_coefficient*(eye(q)+(var_value*(1-eye(q))));
            rng('shuffle')  % For reproducibility
            cluster2_n_over_p = mvnrnd(mu_2,sigma_2,n/p);
            for j=1:length(cluster2_n_over_p)
                minimum_distance(j) = sum(sum(abs((cluster2_n_over_p - repmat(cluster2_n_over_p(j,:),n/p,1)))));
            end
            made_obj =made_obj+ min(minimum_distance);
            
        
            
            %data creation for cluster 3, which is almost identical to cluster 1
            %Cluster 3 Gaussian Cluster
            mu_3 = -7*ones(1,q);
            sigma_3 = sigma_coefficient*(eye(q)+(var_value*(1-eye(q))));
            rng('shuffle')  % For reproducibility
            cluster3_n_over_p = mvnrnd(mu_3,sigma_3,n/p);
            for j=1:length(cluster3_n_over_p)
                minimum_distance(j) = sum(sum(abs((cluster3_n_over_p - repmat(cluster3_n_over_p(j,:),n/p,1)))));
            end
            made_obj =made_obj+ min(minimum_distance);
            
            
            %data creation for cluster 4, which is almost identical to cluster 1
            %Cluster 4 Gaussian Cluster
            mu_4 = 11*ones(1,q);
            sigma_4 = sigma_coefficient*(eye(q)+(var_value*(1-eye(q))));
            rng('shuffle')  % For reproducibility
            cluster4_n_over_p = mvnrnd(mu_4,sigma_4,n/p);
            for j=1:length(cluster4_n_over_p)
                minimum_distance(j) = sum(sum(abs((cluster4_n_over_p - repmat(cluster4_n_over_p(j,:),n/p,1)))));
            end
            made_obj =made_obj+ min(minimum_distance);
            
            for i=1:p
                reshuffle_of_columns=randperm(m);
                selected_feature_save(i,:)=reshuffle_of_columns(1:q);
                
            end
            
            redundant_dataset(1:first_limit,selected_feature_save(1,:))= cluster1_n_over_p_top;
            redundant_dataset(first_limit+1:second_limit,selected_feature_save(2,:))= cluster2_n_over_p;
            redundant_dataset(second_limit+1:third_limit,selected_feature_save(3,:))= cluster3_n_over_p;
            redundant_dataset(third_limit+1:fourth_limit,selected_feature_save(4,:))= cluster4_n_over_p;
            
            final_set = redundant_dataset;
            
            %% Standardization of data
            
            
            for i=1:m
                final_set_standardized(:,i) = normalize(final_set(:,i),'range');
            end
            
            first_cluster = final_set_standardized(1:first_limit,selected_feature_save(1,:));
            second_cluster = final_set_standardized(first_limit+1:second_limit,selected_feature_save(2,:));
           
            for j=1:first_limit
                minimum_distance_1(j) = sum(sum(abs((first_cluster - repmat(first_cluster(j,:),first_limit,1)))));
            end
            
            made_obj_std = min(minimum_distance_1);
            
            for j=1:(second_limit-first_limit)
                minimum_distance_2(j) = sum(sum(abs((second_cluster - repmat(second_cluster(j,:),(second_limit-first_limit),1)))));
            end
            
            made_obj_std_2 = min(minimum_distance_2);
            
            std_obj_value = made_obj_std+made_obj_std_2;
            
            
            
            %%
            
            %Saving datas in a cell array
            dataset_name = ['clusters', num2str(p),'_m',num2str(m), '_n',num2str(n),'_q',num2str(q)];
            saved_cell{index_of_the_set,1}=dataset_name;
            saved_cell{index_of_the_set,2}=final_set;
            saved_cell{index_of_the_set,3}=made_obj;
            saved_cell{index_of_the_set,4}=std_obj_value;
            saved_cell{index_of_the_set,5}=selected_feature_save;
            saved_cell{index_of_the_set,6}=final_set_standardized;
            
        end
    end
end

%% write simulated datasets in seperate sheets
for i=1:number_of_created_sets %length(saved_cell)
    writematrix(saved_cell{i,2},'DataSets.xlsx','Sheet',saved_cell{i,1});
end

for i=1:number_of_created_sets %length(saved_cell)
    writematrix(saved_cell{i,6},'DataSet_Standardized.xlsx','Sheet',saved_cell{i,1});
end


%% write mean objectives in a sheet

for i=1:number_of_created_sets %length(saved_cell)
    def=saved_cell{i,1};
    cell_index=['A', num2str(i)];
    writematrix(def,'Made_Objectives_of_sets.xlsx','Sheet','values','Range',cell_index);
    
    def2=saved_cell{i,3};
    cell_index2=['B', num2str(i)];
    writematrix(def2,'Made_Objectives_of_sets.xlsx','Sheet','values','Range',cell_index2);
    
    def3=saved_cell{i,4};
    cell_index3=['C', num2str(i)];
    writematrix(def3,'Made_Objectives_of_sets.xlsx','Sheet','values','Range',cell_index3);
end

for i=1:number_of_created_sets %length(saved_cell)
    writematrix(saved_cell{i,5},'Made_Objectives_of_sets.xlsx','Sheet',saved_cell{i,1});
    
end


