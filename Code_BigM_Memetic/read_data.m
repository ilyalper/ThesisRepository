function [data, ga_Sheet_Name,preselected_set_of_features] = read_data(pathh,p,n,orig_m,q,param_features_is_taken)

%Burada veri çekme işlemi ve daha sonradan kullanılacak olan
%yazdırma işlemi için ilgili isimler yaratılıyor.
%In this function we read the data and save the data for the algorithm
%usage

rrr=[pathh,'/Datasets/p',num2str(p),'/n',num2str(n),'/m',num2str(orig_m),'negcovarq',num2str(q)]
cd (convertCharsToStrings(rrr))

%çıktıların yazdırılacağı sheet ismi
%name of the excel sheet in order to write results which will be utilized in the end
ga_Sheet_Name = [num2str(p), '_', num2str(n),'_', num2str(orig_m),'_',num2str(q)]; % that will be utilized in the end

%read the data from a txt file named as dataset.txt
data = textread('dataset.txt');

if param_features_is_taken==1
    preselected_set_of_features = textread('selected_features.txt');
else
    preselected_set_of_features=[];
end


cd (convertCharsToStrings(pathh))


%here we control the imported data. If data size is not match with our
%[m,n] set
%çektiğimiz verilerin boyutlarına bakıyoruz ve sorun varsa yazdırıyoruz.
data = data(:,1:end); %1 to d
[nn d] = size(data);
if (orig_m==d &&  n==nn) ~= 1
    fprintf('there is a problem')
end
end



