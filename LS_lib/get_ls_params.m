function [params] = get_ls_params(k, mu, gamma, beta)

params = struct;

if(nargin < 1)
    params.k = 2;
else
    params.k = k;
end

if(nargin < 2)
    params.mu = .6;
else
    params.mu = mu;
end

if(nargin < 3)
    params.gamma = 0.2569;
else
    params.gamma = gamma;
end

if(nargin < 4)
    params.beta = 0.00349;
else
    params.beta = beta;
end

end

