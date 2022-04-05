[aa, bb] = size(ga_saved_cell);
%test_size=param_q_tobe_read;

for i=1:aa
  qeq= ga_saved_cell{i,5};
  result_test2(i,1)=max(sum(qeq==kaggle_data_set),sum(qeq==(3-kaggle_data_set)));
  result_test2(i,2)= length(intersect(find(qeq==1), find(kaggle_data_set==1)));
  result_test2(i,3)= length(intersect(find(qeq==1), find(kaggle_data_set==2)));
  result_test2(i,4)= length(intersect(find(qeq==2), find(kaggle_data_set==1)));
  result_test2(i,5)= length(intersect(find(qeq==2), find(kaggle_data_set==2)));

  
end