function assignment_set= mutation_type2(assignment_set,center_set,p,n)
%önce rastgele bir endeks seçiyoruz mutasyon için
mutated_index = unidrnd(n);
%eğer seçilen endex cluster centersa geçersiz, tekrar bir nokta seçiyoruz
while sum(mutated_index==center_set)==1
   mutated_index = unidrnd(n);
end
%switch edeceğimiz cluster no'yu seçiyoruz
new_cluster=unidrnd(p);
%eğer seçilen cluster mevcuttakiyle aynıysa, tekrar bir cluster seçiyoruz
while assignment_set(mutated_index)==new_cluster
   new_cluster=unidrnd(p);
end
%değiştirme
assignment_set(mutated_index)=new_cluster;
end