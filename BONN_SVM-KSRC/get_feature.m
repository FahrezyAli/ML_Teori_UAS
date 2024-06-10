close all;
clear;
clc;
addpath function;
dataname ={'A_Z','B_O','C_N','D_F','E_S'};
Fs = 173.61;
csvdata = zeros(500,1151);
num = 1;
N = 500;
for i = 1:5
    Data_path = strcat ('Bonn_Raw_Dataset','\',dataname{i});
    p_mat = dir(strcat(Data_path,'\*.txt'));
    for j = 1:100   
        h = waitbar((i*100-100+j)/N);    
        name = strcat (Data_path,'\',p_mat(j).name);
        data = (load(name))'; 
        data = data - mean(data);
        [~,data_spectrum] = EEGspectrum(data,Fs);      
        csvdata(num,1) = max(data_spectrum(12:95)); 
        csvdata(num,2) = var(data_spectrum(12:95));
        csvdata(num,3) = max(data_spectrum(96:189)); 
        csvdata(num,4) = var(data_spectrum(96:189));
        csvdata(num,5) = max(data_spectrum(190:307));
        csvdata(num,6) = var(data_spectrum(190:307));
        csvdata(num,7) = max(data_spectrum(308:709));   
        csvdata(num,8) = var(data_spectrum(308:709));
        csvdata(num,9) = max(data_spectrum(710:1156));     %710:1156
        csvdata(num,10) = var(data_spectrum(710:1156));     %710:1156
        csvdata(num,11:1150) = normalize_data(data_spectrum(12:1151)'); %12:1151
        csvdata(num,1151) = (i==5);
        num = num + 1;
    end 
end
writematrix(csvdata,"Bonn.csv");
close(h);
