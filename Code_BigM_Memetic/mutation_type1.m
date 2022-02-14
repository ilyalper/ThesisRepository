function final_assignment_set= mutation_type1(assignment_set,n)

%önce rastgele bir ikili seçiyoruz.ama eğer bu ikililer aynıysa tekrar yapıyoruz

mutated_set = randperm(n,2);

while assignment_set(mutated_set(1)) ==  assignment_set(mutated_set(2))
   mutated_set = randperm(n,2);
end

%ardindan yeni set'i oluşturup ilgili endeksleri yer değiştiriyoruz.
final_assignment_set=assignment_set;
final_assignment_set(mutated_set(1)) = assignment_set(mutated_set(2));
final_assignment_set(mutated_set(2)) = assignment_set(mutated_set(1));


end



