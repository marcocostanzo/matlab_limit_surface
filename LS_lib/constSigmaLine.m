function y = constSigmaLine(x,varargin)

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

