[aa, bb] = size(ga_saved_cell);
test_size=param_q_tobe_read;

for i=1:aa
  wew= ga_saved_cell{i,4};
  result_test(i,1)=length(intersect(wew(1,:),param_preselected_set_of_features(1,:)));
  result_test(i,2)=length(intersect(wew(1,:),param_preselected_set_of_features(2,:)));
  result_test(i,3)=length(intersect(wew(2,:),param_preselected_set_of_features(1,:)));
  result_test(i,4)=length(intersect(wew(2,:),param_preselected_set_of_features(2,:)));
  result_test(i,5)=length(intersect(wew(1,:),wew(2,:)));

end
