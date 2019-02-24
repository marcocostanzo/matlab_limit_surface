function y = constSigmaLine(x,varargin)
%CONSTSIGMALINE is the curve at constant sigma in the NLS space
%
%   y = CONSTSIGMALINE(x, ...key-value params...)
%   implements the function:
%   y = 1/sigma * |x|^(gamma+1) * sign(x)
%
%   Inputs:
%       - x: x-axis values of the curve (i.e., ft_norm values)
%   Key-Value Params:
%       - 'sigma': sigma param of the curve.
%       - 'gamma': gamma/exponent value of the curve.
%   Output
%       - y: y-axis value of the curve (i.e., taun_norm values)

%% Parse Input
ip = inputParser;
validScalarNum = @(x) isnumeric(x) && isscalar(x);
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'x', @isnumeric);
addParameter(ip,'sigma', [], validScalarNum);
addParameter(ip,'gamma', [], validScalarPosNum);

parse(ip,x,varargin{:})

if(~isempty(ip.UsingDefaults))
    error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
end

%% Calc

y = (1/ip.Results.sigma).*(abs(ip.Results.x).^(ip.Results.gamma+1)).*sign(ip.Results.x);

end

