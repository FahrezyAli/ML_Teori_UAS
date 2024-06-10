clc;
clear;
addpath function
xlsdata = readmatrix('Bonn.xlsx');
[~,data_len] = size(xlsdata);
fealabel = [10,55,175,385,637,847,967,1012,1022,1023];
Case = {1:100,101:200,201:300,301:400,1:200,201:400,1:400};
f = 3;
Test = 7;
SvmLabel = label_all(1:10);
tennum = 10;
testrange = Case{Test};
testnum = 10+length(testrange)/10;
for sl = (fealabel(f)+1):fealabel(f+1)
    SvmFeature =  SvmLabel{sl};
    disp(['Feature No.��',num2str(SvmFeature)]);
    accsum = 0;
    sensum = 0;
    spesum = 0;

    for ten = 1:tennum
     [test_data,test_label,train_data,train_label] = tenfold(xlsdata([testrange,401:500],1:data_len-1),xlsdata([testrange,401:500],data_len));
    label = zeros(testnum,10);
    rightnums = 0;

        for j = 1:10
             traindata = train_data{j};
             testdata = test_data{j};
             %SVM data
             trainsvm = traindata(:,SvmFeature); 
             testsvm = testdata(:,SvmFeature);
             %Train SVM
             SVMModel = fitcsvm(trainsvm,train_label{j},'Standardize',true,'KernelFunction','linear'); 
             for i = 1:testnum
                    [predict_label_s,scores_s] = predict(SVMModel, testsvm(i,:));
                    label(i,j) = predict_label_s;
             end
        end
        TP = length(find(label(testnum-9:testnum,1:10)==1));
        FP = length(find(label(1:testnum-10,1:10)==1));
        TN = length(find(label(1:testnum-10,1:10)==0));
        FN = length(find(label(testnum-9:testnum,1:10)==0));
        rightnum = TP + TN;  
        acc = 100*rightnum/(testnum*10);
        sen = 100*TP/(TP+FN);
        spe = 100*TN/(TN+FP);
        disp(['acc=',num2str(acc),'%,','sen=',num2str(sen),'%,','spe=',num2str(spe),'%']);
        accsum = accsum + acc;
        sensum = sensum + sen;
        spesum = spesum + spe;

    end
    disp(['Average��acc=',num2str(accsum/tennum),'%,','sen=',num2str(sensum/tennum),'%,','spe=',num2str(spesum/tennum),'%']);
end


