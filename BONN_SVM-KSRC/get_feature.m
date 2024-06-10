close all;
clear;
clc;
addpath function;
dataname ={'A_Z','B_O','C_N','D_F','E_S'};
Fs = 173.61;
xlsdata = zeros(500,1151);
num = 1;
N = 500;
for i = 1:5
    Data_path = strcat ('Bonn','\',dataname{i});
    p_mat = dir(strcat(Data_path,'\*.txt'));
    for j = 1:100   
        h = waitbar((i*100-100+j)/N);    
        name = strcat (Data_path,'\',p_mat(j).name);
        data = (load(name))'; 
        data = data - mean(data);
        [~,data_spectrum] = EEGspectrum(data,Fs);      
        xlsdata(num,1) = max(data_spectrum(12:95)); 
        xlsdata(num,2) = var(data_spectrum(12:95));
        xlsdata(num,3) = max(data_spectrum(96:189)); 
        xlsdata(num,4) = var(data_spectrum(96:189));
        xlsdata(num,5) = max(data_spectrum(190:307));
        xlsdata(num,6) = var(data_spectrum(190:307));
        xlsdata(num,7) = max(data_spectrum(308:709));   
        xlsdata(num,8) = var(data_spectrum(308:709));
        xlsdata(num,9) = max(data_spectrum(710:1156));     %710:1156
        xlsdata(num,10) = var(data_spectrum(710:1156));     %710:1156
        xlsdata(num,11:1150) = normalize_data(data_spectrum(12:1151)'); %12:1151
        xlsdata(num,1151) = (i==5);
        num = num + 1;
    end 
end
writematrix(xlsdata,"Bonn.csv");
close(h);

