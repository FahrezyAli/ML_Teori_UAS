function Ker = Gsker(A,B,seg2)
[~,N1] = size(A); 
[~,N2] = size(B);
ker = zeros(N1,N2);
for i = 1 : N1
    for j = 1: N2
        t =  A(:,i) - B(:,j); 
        ker(i,j) = t'*t/(2*seg2);
    end
end
Ker = exp(-ker);
