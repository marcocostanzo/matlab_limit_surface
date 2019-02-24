function Xi_k = getXik( k )

%% Parse Input
ip = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'k', validScalarPosNum);

parse(ip,k);

%% Calc

Xi_k =  (3/2)*ip.Results.k.*(gamma(3./ip.Results.k))./  ...
        ( gamma(1./ip.Results.k) .* gamma(2./ip.Results.k) );

%Xi_k = ip.Results.k / (2* beta(2/ip.Results.k , 1/ip.Results.k + 1) );

end

