function [test_data,test_label,train_data,train_label] = tenfold(dataset,labelset)

indices = crossvalind('Kfold', labelset, 10);   
test_data = cell(1,10);
test_label = cell(1,10);
train_data = cell(1,10);
train_label = cell(1,10);
for i = 1 : 10
    test = (indices == i);   
    train = ~test;           
    
    test_data{i} = dataset(test,:);  
    test_label{i} = labelset(test,:);
    train_data{i} = dataset(train,:);
    train_label{i} = labelset(train,:);
end
