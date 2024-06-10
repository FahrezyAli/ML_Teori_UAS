clc;clear;
addpath function
csvdata = readmatrix('Bonn.csv');  % Read in feature data
[~,data_len] = size(csvdata);
%parameter assignment
opt.lambda = 0.01;
opt.tol = 1e-6;
opt.iter_num = 2000;
p = 0.1;

Case = {1:100,101:200,201:300,301:400,1:200,201:400,1:400};
%best_feature = [31,28,52,37,34,50,54];
Test = 4;
tennum = 10;
SvmLabel = label_all(1:10);
testrange = Case{Test}; 
testnum = 10+length(testrange)/10;
for sl = 11:55
 
    
    SvmFeature = SvmLabel{sl};
    disp(['SVM feature No.',num2str(SvmFeature)]);
    accsum = 0;
    sensum = 0;
    spesum = 0;

    for ten = 1:tennum
        [test_data,test_label,train_data,train_label] = tenfold(csvdata([testrange,401:500],1:data_len-1),csvdata([testrange,401:500],data_len));
        label = zeros(testnum,10);

        rightnums = 0;
        for j = 1:10
             traindata = train_data{j};
             testdata = test_data{j};

             trainsvm = traindata(:,SvmFeature); 
             testsvm = testdata(:,SvmFeature);
             %Train SVM 
             SVMModel = fitcsvm(trainsvm,train_label{1},'Standardize',true,'KernelFunction','linear'); 
             supportvector = [trainsvm(SVMModel.IsSupportVector,1),trainsvm(SVMModel.IsSupportVector,2)];
             supportarea = ScatterHull(supportvector,180); 
             [in,on] = inpolygon(testsvm(:,1),testsvm(:,2),supportarea(:,1),supportarea(:,2));
             %KSRC data
             A = traindata(:,11:data_len-1)';
             testSC = testdata(:,11:data_len-1)';
             KAA = Gsker(A,A,p); 
             for i = 1:testnum

                if in(i) == 1 || on(i) == 1    %KSRC when conditions are met   
                    y = testSC(:,i);
                    KAy = Gsker(A,y,p); 
                    Kyy = Gsker(y,y,p);
                    [beta,~] = KernelCoorDescent(KAA,KAy,opt);
                    beta1 = [beta(1:(9*testnum-90));zeros(90,1)];   
                    beta2 = [zeros((9*testnum-90),1);beta((9*testnum-89):9*testnum)]; 
                    err1 = Kyy - 2*beta1'*KAy + beta1'*KAA*beta1;         %y - A*beta1;
                    err2 = Kyy - 2*beta2'*KAy + beta2'*KAA*beta2;         %y - A*beta2;
                    err = [err1'*err1,err2'*err2];
                    if err(1) == err(2)
                        continue;
                    end
                    label(i,j) = find(err==min(err)) - 1;  
             
                else   %SVM when conditions are met
                    [predict_label_s,scores_s] = predict(SVMModel, testsvm(i,:));
                    label(i,j) = predict_label_s;
                   
                end
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
    disp(['Average: acc=',num2str(accsum/tennum),'%,','sen=',num2str(sensum/tennum),'%,','spe=',num2str(spesum/tennum),'%']);
end


