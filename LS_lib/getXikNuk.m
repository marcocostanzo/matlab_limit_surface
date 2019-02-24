function XikNuk = getXikNuk( k )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Parse Input
ip = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'k', validScalarPosNum);

parse(ip,k);

%% Calc

XikNuk =    (3/8)  * (gamma(3./ip.Results.k).^2) ./ ...
          (  gamma(2./ip.Results.k) .* gamma(4./ip.Results.k) );


end

