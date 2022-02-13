function [ind,child_centers,child_assignments] = uniform_crossover(ind,p,n,d,population_size,new_parent_assignment_set,new_parent_center_set)

child_assignments=zeros(1,n);
child_centers=zeros(1,p);
for k=1:population_size/2
    temp1_assignments=new_parent_assignment_set(k,:);
    temp2_assignments=new_parent_assignment_set(population_size-k+1,:);
    temp1_centers=new_parent_center_set(k,:);
    temp2_centers=new_parent_center_set(population_size-k+1,:);
    
    %ilk crossover da sadece assignmentları
    %çaprazlıyoruz
    
    child_temp_assignments1=[];
    child_temp_assignments2=[];
    
    %crossover mask imizi oluşturalım
    crossover_mask=randperm(n,round(n/2));
    selection_temp_1=ones(1,n);
    selection_temp_1(crossover_mask)=0;
   
    %unique cluster center listesi yapalım
    center_indexes= unique(cat(2,temp1_centers,temp2_centers));
    %cluster centerlar kendi merkezlerini elde tutacağı için o point
    %üzerinden crossover yapmıyoruz.
    for j=1:length(center_indexes)
        selection_temp_1(center_indexes)=1;
    end
    
    
    for i=1:n
        if selection_temp_1(i)==1
            child_temp_assignments1(i)=temp1_assignments(i);
            child_temp_assignments2(i)=temp2_assignments(i);
        elseif selection_temp_1(i)==0
            child_temp_assignments1(i)=temp2_assignments(i);
            child_temp_assignments2(i)=temp1_assignments(i);
        end
    end
    
    
    
    if (sum((child_temp_assignments1) ~= (temp1_assignments))~=0) && (sum((child_temp_assignments2) ~= (temp2_assignments))~=0)
        child_centers(ind,:)=temp1_centers;
        child_assignments(ind,:)= child_temp_assignments1;
        ind=ind+1;
    end
    
    if (sum((child_temp_assignments2) ~= (temp1_assignments))~=0) && (sum((child_temp_assignments2) ~= (temp2_assignments))~=0)
        child_centers(ind,:)=temp2_centers;
        child_assignments(ind,:)= child_temp_assignments2;
        ind=ind+1;
    end
    
    
    
    %ikinci crossover da sadece centerları
    %çaprazlıyoruz
    child_temp_centers1=zeros(1,p);
    child_temp_centers2=zeros(1,p);
    
    crossover_mask_2=randperm(p,round(p/2));
    center_selection_temp_1=ones(1,p);
    center_selection_temp_1(crossover_mask_2)=0;
    
    
    for i=1:p
        if center_selection_temp_1(i)==1
            child_temp_centers1(i)=temp1_centers(i);
            child_temp_centers2(i)=temp2_centers(i);
        elseif center_selection_temp_1(i)==0
            child_temp_centers1(i)=temp2_centers(i);
            child_temp_centers2(i)=temp1_centers(i);
            temp1_assignments(child_temp_centers1(i))=i;
            temp2_assignments(child_temp_centers2(i))=i;
        end
    end
    
    
    %çaprazlamanın ardından çoçuklardan birinin merkezleri parent'ı ile aynıysa ya da çocuk aynı centerdan birden fazla içeriyorsa bu çocuğu populasyona katmıyoruz.
    if (sum(sort(child_temp_centers1) ~= sort(temp1_centers))~=0) && (sum(sort(child_temp_centers1) ~= sort(temp2_centers))~=0) && (length(unique(child_temp_centers1)) == length(child_temp_centers1))
        child_centers(ind,:)=child_temp_centers1;
        child_assignments(ind,:)= temp1_assignments;
        ind=ind+1;
    end
    if (sum(sort(child_temp_centers2) ~= sort(temp1_centers))~=0) && (sum(sort(child_temp_centers2) ~= sort(temp2_centers))~=0) && (length(unique(child_temp_centers2)) == length(child_temp_centers2))
        child_centers(ind,:)=child_temp_centers2;
        child_assignments(ind,:)= temp2_assignments;
        ind=ind+1;
    end
    
    
end
end