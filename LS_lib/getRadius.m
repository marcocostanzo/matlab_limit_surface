function R = getRadius(fn,varargin)

%% Parse Input
ip = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'fn', @isnumeric);
addParameter(ip,'delta', [], validScalarPosNum);
addParameter(ip,'gamma', [], validScalarPosNum);

parse(ip,fn,varargin{:})

if(~isempty(ip.UsingDefaults))
    error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
end

%% Calc

R = ip.Results.delta * ( ip.Results.fn.^(ip.Results.gamma) );


end

