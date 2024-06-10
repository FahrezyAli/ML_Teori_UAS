clc;clear;
addpath function
csvdata = readmatrix('NSC-ND.csv');
[~,data_len] = size(csvdata);
fealabel = [10,55,175,385,637,847,967,1012,1022,1023];
Case = {1:50,51:100,1:100};
f = 1;
Test = 3;
SvmLabel = label_all(1:10);
tennum = 10;
testrange = Case{Test};
testnum = 5+length(testrange)/10;
for sl = (fealabel(f)+1):fealabel(f+1)
    SvmFeature =  SvmLabel{sl};
    disp(['Feature No.',num2str(SvmFeature)]);
    accsum = 0;
    sensum = 0;
    spesum = 0;
    for ten = 1:tennum
    [test_data,test_label,train_data,train_label] = tenfold(csvdata([testrange,101:150],1:10),csvdata([testrange,101:150],data_len));  

    label = zeros(testnum,10);
    rightnums = 0;
    for j = 1:10
        traindata = train_data{j};
        testdata = test_data{j};

        trainsvm = traindata(:,SvmFeature); 
        testsvm = testdata(:,SvmFeature);

        SVMModel = fitcsvm(trainsvm,train_label{j},'Standardize',true,'KernelFunction','linear'); 
        for i = 1:testnum
                [predict_label_s,scores_s] = predict(SVMModel, testsvm(i,:));
                label(i,j) = predict_label_s;
        end
    end
    TP = length(find(label(testnum-4:testnum,1:10)==1));
    FP = length(find(label(1:testnum-5,1:10)==1));
    TN = length(find(label(1:testnum-5,1:10)==0));
    FN = length(find(label(testnum-4:testnum,1:10)==0));

    rightnum = TP + TN; 
    acc = 100*rightnum/(testnum*10);
    sen = 100*TP/(TP+FN);
    spe = 100*TN/(TN+FP);
    disp(['acc=',num2str(acc),'%,','sen=',num2str(sen),'%,','spe=',num2str(spe),'%']);
    accsum = accsum + acc;
    sensum = sensum + sen;
    spesum = spesum + spe;

    end
    disp(['Average: acc=',num2str(accsum/tennum),'%,','sen=',num2str(sensum/tennum),'%,','spe=',num2str(spesum/tennum),'%']);

end
