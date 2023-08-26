close all;
clear;
addpath function;
dataname ={'X','Y','Z'};

Fs = 200;
num = 1;

for i = 1:3
    Data_path = strcat ('NewDelhi\','\',dataname{i});
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

        xlsdata(num,1) = max(data_spectrum(1:20)); 
        xlsdata(num,5) = var(data_spectrum(1:20));
        xlsdata(num,2) = max(data_spectrum(21:41));
        xlsdata(num,6) = var(data_spectrum(21:41)); 
        xlsdata(num,3) = max(data_spectrum(42:67));
        xlsdata(num,7) = var(data_spectrum(42:67));
        xlsdata(num,4) = max(data_spectrum(68:154)); 
        xlsdata(num,8) = var(data_spectrum(68:154));
        xlsdata(num,9) = max(data_spectrum(155:251));
        xlsdata(num,10) = var(data_spectrum(155:251)); 
        xlsdata(num,11:260) = normalize_data(data_spectrum(2:251)');
        xlsdata(num,261) = (i==3);
        num = num + 1;
    end 
end
xlswrite('NSC-ND.xlsx',xlsdata);
close(h);

 




