function ft_max = getFtMax(fn,varargin)

%% Parse Input
ip = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'fn', @isnumeric);

if(nargin > 2)
    addParameter(ip,'mu', [], validScalarPosNum);
else
    addRequired(ip,'mu', validScalarPosNum);
end

parse(ip,fn,varargin{:});

%if(~isempty(ip.UsingDefaults))
%    error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
%end

%% Calc

ft_max = ip.Results.mu .* ip.Results.fn;

end

