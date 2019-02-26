function Xi_k = getXik( k )
%GETNIK compute the xik function

%   Xi_k = GETNIK(k)
%   implements the function
%   (3/2) * k * (gamma(3/k))/( gamma(1/k) * gamma(2/k) )


% Copyright 2018 Università della Campania Luigi Vanvitelli
% Author: Marco Costanzo <marco.costanzo@unicampania.it>
%
% This file is part of matlab_limit_surface by Marco Costanzo
% https://github.com/marcocostanzo/matlab_limit_surface
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% https://github.com/marcocostanzo

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

