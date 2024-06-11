% Matlab code for extracting features from New Delhi dataset

close all;
clear;
addpath function;
dataname ={'X','Y','Z'};

Fs = 200;
csvdata = zeros(150,261);
num = 1;

for i = 1:3
    Data_path = strcat ('NewDelhi_Raw_Dataset','\',dataname{i});
    p_mat = dir(strcat(Data_path,'\*.mat'));
    for j = 1:50
        h = waitbar(((i-1)*50 + j)/150);
        name = strcat (Data_path,'\',p_mat(j).name);
        datastruct = (load(name));
        if i == 1
            dataload = datastruct.preictal';
        end
        if i == 2
            dataload = datastruct.interictal';
        end
        if i == 3
            dataload = datastruct.ictal';
        end
        data = dataload;  
        data = data - mean(data);
        [~,data_spectrum] = EEGspectrum(data,Fs);

        csvdata(num,1) = max(data_spectrum(1:20)); 
        csvdata(num,5) = var(data_spectrum(1:20));
        csvdata(num,2) = max(data_spectrum(21:41));
        csvdata(num,6) = var(data_spectrum(21:41)); 
        csvdata(num,3) = max(data_spectrum(42:67));
        csvdata(num,7) = var(data_spectrum(42:67));
        csvdata(num,4) = max(data_spectrum(68:154)); 
        csvdata(num,8) = var(data_spectrum(68:154));
        csvdata(num,9) = max(data_spectrum(155:251));
        csvdata(num,10) = var(data_spectrum(155:251)); 
        csvdata(num,11:260) = normalize_data(data_spectrum(2:251)');
        csvdata(num,261) = (i==3);
        num = num + 1;
    end 
end
writematrix(csvdata,'NSC-ND.csv');
close(h);
