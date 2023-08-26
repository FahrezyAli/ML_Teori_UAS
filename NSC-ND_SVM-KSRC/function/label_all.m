function label = label_all(labelin)
label_N = length(labelin);
label_len = 2^(label_N)-1;    
label = cell(1,label_len);
beg = 1;
for i = 1:label_N-1
    label_in = nchoosek(labelin,i);
    endl = length(label_in);
    for j = beg:(beg+endl-1)
        label{j} = label_in((j-beg+1),:);    
    end
    beg = beg + endl;
end
label{beg} = labelin;
