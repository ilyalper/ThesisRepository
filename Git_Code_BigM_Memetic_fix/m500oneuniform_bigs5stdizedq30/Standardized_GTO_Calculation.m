data_calc = textread('dataset.txt');
selected_feat = textread('selected_features.txt');

first_cluster = data_calc(1:50,selected_feat(1,:));
second_cluster = data_calc(51:100,selected_feat(2,:));

for j=1:50
    minimum_distance_1(j) = sum(sum(abs((first_cluster - repmat(first_cluster(j,:),50,1)))));
end

made_obj = min(minimum_distance_1);

for j=1:50
    minimum_distance_2(j) = sum(sum(abs((second_cluster - repmat(second_cluster(j,:),50,1)))));
end

made_obj_2 = min(minimum_distance_2);

Obj_value = made_obj+made_obj_2