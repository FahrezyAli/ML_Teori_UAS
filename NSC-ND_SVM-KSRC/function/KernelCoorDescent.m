
function [beta,iter] = KernelCoorDescent ( R, Z, opt )

if isfield( opt, 'lambda')  
    lambda  = opt.lambda ;
else
    lambda  = 0.01 ;
end

if isfield( opt, 'tol')  
    tol  = opt.tol ;
else
    tol  = 1e-6 ;
end
if isfield( opt, 'iter_num')  
    iter_num  = opt.iter_num ;
else
    iter_num  = 50 ;
end
% initializition


[P, N]= size(R);
beta = zeros( N, 1 );
for iter = 1: iter_num
    prebeta = beta;
    for j = 1 : N   %%
        a = Z(j) - R( j, : )*beta;
        a = a + beta(j, :);
        if abs( a ) < lambda        
            beta( j, : ) = 0;        
        else        
            beta( j, : ) = sign( a ).*( abs( a ) - lambda );        
        end
    end
    if norm(beta-prebeta, 2) < tol
        break;
    end
end