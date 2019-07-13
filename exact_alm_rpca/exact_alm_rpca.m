function [A_hat,E_hat, iter] = exact_alm_rpca(D, lambda, tol, maxIter)

% Oct 2009
% This matlab code implements the augmented Lagrange multiplier method for
% Robust PCA.
%
% D - m x n matrix of observations/data (required input)
%
% lambda - weight on sparse error term in the cost function
%
% tol - tolerance for stopping criterion.
%     - DEFAULT 1e-7 if omitted or -1.
%
% maxIter - maximum number of iterations
%         - DEFAULT 1000, if omitted or -1.
% 
% Initialize A,E,Y,u
% while ~converged 
%   minimize
%     L(A,E,Y,u) = |A|_* + lambda * |E|_1 + <Y,D-A-E> + mu/2 * |D-A-E|_F^2;
%   Y = Y + \mu * (D - A - E);
%   \mu = \rho * \mu;  
% end
%
% Minming Chen, October 2009. Questions? v-minmch@microsoft.com ; 
% Arvind Ganesh (abalasu2@illinois.edu)
%
% Copyright: Perception and Decision Laboratory, University of Illinois, Urbana-Champaign
%            Microsoft Research Asia, Beijing

addpath PROPACK  %引入lansvd（）；

[m n] = size(D);

if nargin < 2  %nargin表示函数输入值的数量。
    lambda = 1 / sqrt(max(m,n));  
end

if nargin < 3  
    tol = 1e-7;
elseif tol == -1
    tol = 1e-7;
end

if nargin < 4
    maxIter = 1000;
elseif maxIter == -1
    maxIter = 1000;
end

% initialize
Y = sign(D);
norm_two = svds(Y, 1); %得到Y中最大的一个特征值  %修改norm_two=lansvd(Y,1,'L')为norm_two=svds(Y,1).
norm_inf = norm( Y(:), inf) / lambda;   %矩阵的无穷范数除以lambda
dual_norm = max(norm_two, norm_inf);  
Y = Y / dual_norm;

A_hat = zeros( m, n);
E_hat = zeros( m, n);
dnorm = norm(D, 'fro');
tolProj = 1e-6 * dnorm;  %内部循环的判断条件
total_svd = 0;  %？？？？
mu = .5/norm_two % this one can be tuned
rho = 6          % this one can be tuned

iter = 0;
converged = false;
stopCriterion = 1;
sv = 5;  %这是对奇异值空间维度的预测值
svp = sv; %这是比1/mu大的奇异值的个数
while ~converged       
    iter = iter + 1;
    
    % solve the primal problem by alternative projection 用交替投影法求解原始问题
    primal_converged = false;
    primal_iter = 0;
    sv = sv + round(n * 0.1); %round取最近的小数或者整数，是对奇异空间维度的预测吗？
    while primal_converged == false
        
        temp_T = D - A_hat + (1/mu)*Y;
        temp_E = max( temp_T - lambda/mu,0) + min( temp_T + lambda/mu,0); %max(,0)小于0的数替换成0；
        
        if choosvd(n, sv) == 1
            [U S V] = svds(D - temp_E + (1/mu)*Y, sv, 'L'); %修改lansvd为svd；
        else
            [U S V] = svd(D - temp_E + (1/mu)*Y, 'econ');
        end
        diagS = diag(S);   %获取矩阵S的对角元素向量；
        svp = length(find(diagS > 1/mu));  %获取比1/mu大的奇异值
        if svp < sv  %prediction
            sv = min(svp + 1, n);  
        else
            sv = min(svp + round(0.05*n), n);
        end
        temp_A = U(:,1:svp)*diag(diagS(1:svp)-1/mu)*V(:,1:svp)';    
        
        if norm(A_hat - temp_A, 'fro') < tolProj && norm(E_hat - temp_E, 'fro') < tolProj  
            primal_converged = true; 
        end
        A_hat = temp_A;
        E_hat = temp_E;
        primal_iter = primal_iter + 1;
        total_svd = total_svd + 1;
               
    end
        
    Z = D - A_hat - E_hat;        
    Y = Y + mu*Z;
    mu = rho * mu;
    
    %% stop Criterion    
    stopCriterion = norm(Z, 'fro') / dnorm;  %只用了一个终止条件，因为第二个判断条件由于E_hat-temp_E—>0自然是成立的。
    if stopCriterion < tol
        converged = true;
    end    
    
    disp(['Iteration' num2str(iter) ' #svd ' num2str(total_svd) ' r(A) ' num2str(svp)...
        ' |E|_0 ' num2str(length(find(abs(E_hat)>0)))...
        ' stopCriterion ' num2str(stopCriterion)]);
    
    if ~converged && iter >= maxIter
        disp('Maximum iterations reached') ;
        converged = 1 ;       
    end
end

if nargin == 5
    fclose(fid);
end