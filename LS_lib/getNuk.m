function nu_k  = getNuk( k )
%GETNIK from saved vector

%% Parse Input
ip = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'k', validScalarPosNum);

parse(ip,k);

%% Calc

nu_k = beta(3./ip.Results.k , 1./ip.Results.k  + 1)./ip.Results.k;

end

