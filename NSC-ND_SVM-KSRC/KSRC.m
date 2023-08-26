clc;clear;
addpath function
xlsdata = xlsread('NSC-ND.xlsx');

opt.lambda = 0.01;
opt.tol = 1e-6;
opt.iter_num = 2000;
p = 0.1;

accsum = 0;
sensum = 0;
spesum = 0;
for ten = 1:10
[test_data,test_label,train_data,train_label] = tenfold(xlsdata([1:100,101:150],1:260),xlsdata([1:100,101:150],261));  %%
testnum = 15;  %%
label = zeros(testnum,10);
rightnums = 0;
    for j = 1:10
         traindata = train_data{j};
         testdata = test_data{j};

         A = traindata(:,11:260)';
         testSC = testdata(:,11:260)';
         KAA = Gsker(A,A,p); 
         for i = 1:testnum
                y = testSC(:,i);
                KAy = Gsker(A,y,p); 
                [beta,~] = KernelCoorDescent(KAA,KAy,opt);
                beta1 = [beta(1:90);zeros(45,1)];  %%
                beta2 = [zeros(90,1);beta(91:135)]; %%
                err1 = y - A*beta1;
                err2 = y - A*beta2;
                err = [err1'*err1,err2'*err2];
                if err(1) == err(2)
                    continue;
                end
                label(i,j) = find(err==min(err)) - 1;           
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
disp(['Average£ºacc=',num2str(accsum/10),'%,','sen=',num2str(sensum/10),'%,','spe=',num2str(spesum/10),'%']);






