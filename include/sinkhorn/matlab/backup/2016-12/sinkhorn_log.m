function [u,v,gamma,err] = sinkhorn_log(mu,nu,c,epsilon,options)

% sinkhorn_log - stabilized sinkhorn over log domain with acceleration
%
%   [u,v,err] = sinkhorn_log(mu,nu,c,epsilon,options);
%
%   mu and nu are marginals.
%   c is cost
%   epsilon is regularization
%   coupling is 
%       gamma = exp( (-c+u*ones(1,N(2))+ones(N(1),1)*v')/epsilon );
%
%   options.niter is the number of iterations.
%   options.tau is an avering step. 
%       - tau=0 is usual sinkhorn
%       - tau<0 produces extrapolation and can usually accelerate.
%
%   options.rho controls the amount of mass variation. Large value of rho
%   impose strong constraint on mass conservation. rho=Inf (default)
%   corresponds to the usual OT (balanced setting). 
%
%   Copyright (c) 2016 Gabriel Peyre

options.null = 0;
niter = getoptions(options, 'niter', 1000);
tau  = getoptions(options, 'tau', -.5);
verb = getoptions(options, 'verb', 1);
rho = getoptions(options, 'rho', Inf);

lambda = rho/(rho+epsilon);
if rho==Inf
    lambda=1;
end

N = [size(mu,1) size(nu,1)];
H1 = ones(N(1),1);
H2 = ones(N(2),1);


ave = @(tau, u,u1)tau*u+(1-tau)*u1;


lse = @(A)log(sum(exp(A),2));
M = @(u,v)(-c+u*H2'+H1*v')/epsilon;

err = [];
u = zeros(N(1),1); 
v = zeros(N(2),1);
for i=1:niter
    if verb==1
        progressbar(i,niter);
    end
    u1 = u;
    u = ave(tau, u, ...
        lambda*epsilon*log(mu) - lambda*epsilon*lse( M(u,v) ) + lambda*u );
    v = ave(tau, v, ...
        lambda*epsilon*log(nu) - lambda*epsilon*lse( M(u,v)' ) + lambda*v );
    if rho==Inf
        err(i,1) = norm( sum(exp(M(u,v)),2)-mu );
    else
        err(i,1) = norm(u(:)-u1(:), 1);
    end
end

gamma = exp(M(u,v));

end