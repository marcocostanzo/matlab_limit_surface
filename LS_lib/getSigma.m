function sigma = getSigma(ft,tau,varargin)
%NB FROM ft_norm m_norm

%% Parse Input
ip = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'ft', @isnumeric);
addRequired(ip,'tau', @isnumeric);

if nargin < 4
   normalized = true;
   gamma = varargin{1};
   addRequired(ip,'gamma', validScalarPosNum);
   parse(ip,ft,tau,gamma)
else
    
    addParameter(ip,'gamma', [],validScalarPosNum);

    if nargin > 4
        normalized = false;
        addParameter(ip,'k', [], validScalarPosNum);
        addParameter(ip,'delta', [], validScalarPosNum);
        addParameter(ip,'mu', [], validScalarPosNum);
    else
        normalized = true;
    end
    
    parse(ip,ft,tau,varargin{:})

end



if(~isempty(ip.UsingDefaults))
    s = '';
    if ~normalized
       s = ' in the normalized formula'; 
    end
    error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
end

%Dimension check
assert( isequal(size(ft),size(tau)), 'ft and tau has to be same size' )

%% Calc
if normalized
    
    const = 1;
    
else
    
    const = 2* getXikNuk(ip.Results.k) * ip.Results.delta / ...
            ( (ip.Results.mu)^(ip.Results.gamma+1) );
    
end
    
sigma = const*(abs(ft).^(ip.Results.gamma+1)).* sign(ft) ./ tau;
