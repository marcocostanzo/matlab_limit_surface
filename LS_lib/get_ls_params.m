function [params] = get_ls_params(k, mu, gamma, delta)

params = struct;

if(nargin < 1 || ~isempty(k))
    params.k = 4;
else
    params.k = k;
end

if(nargin < 2 || ~isempty(mu))
    params.mu = .6;
else
    params.mu = mu;
end

if(nargin < 3 || ~isempty(gamma))
    params.gamma = 0.2569;
else
    params.gamma = gamma;
end

if(nargin < 4 || ~isempty(delta))
    params.delta = 0.00349;
else
    params.delta = delta;
end

end

