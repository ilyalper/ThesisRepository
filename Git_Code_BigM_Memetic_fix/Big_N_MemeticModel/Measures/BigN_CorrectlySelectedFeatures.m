[aa, bb] = size(ga_saved_cell);
test_size=param_q_tobe_read;

for i=1:aa
    
    wew=[];
    assigned_pts = ga_saved_cell{i,6};
    selected_features= ga_saved_cell{i,5};
    
    correct_assignment=ga_saved_cell{i,12};

    
    %% for big N results
    
    sel_integers=reshape(selected_features,length(selected_features)/p,p)';
    
    for j=1:p
        wew(j,:)=find(sel_integers(j,:)==1);
        for k=1:p
            dda((j-1)*p+k)=length(intersect(wew(j,:),param_preselected_set_of_features(k,:)));
        end
    
    end
    %%
    
    for r=1:p
        ter(r)=sum(find(assigned_pts==r));
    end
    
    [v,b]=sort(ter);
    
    correct_pts=0;
    for ii=1:p
        correct_pts=correct_pts+max(correct_assignment(ii,:));
    end
    
    result_summary=[correct_pts,0,b,0,dda];
    
    
    ga_saved_result_test(i,:)=result_summary;

    
       

end
