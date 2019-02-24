function tau_max = getTaunMax(fn, varargin)

%% Parse Input
ip = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'fn', @isnumeric);
addParameter(ip,'mu', [], validScalarPosNum);
addParameter(ip,'k', [], validScalarPosNum);
addParameter(ip,'delta', [], validScalarPosNum);
addParameter(ip,'gamma', [], validScalarPosNum);

parse(ip,fn,varargin{:})

if(~isempty(ip.UsingDefaults))
    error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
end

%% Calc

tau_max =   2 * ip.Results.mu * getXikNuk(ip.Results.k) * ...
            ip.Results.fn .* getRadius( ip.Results.fn,...
                                        ip.Results.delta,...
                                        ip.Results.gamma);


end

