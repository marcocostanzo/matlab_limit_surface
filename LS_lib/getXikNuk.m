function XikNuk = getXikNuk( k )
%GETXIKNUK directly computes the product xik * nuk

%   XikNuk = GETXIKNUK(k)
%   implements the function
%   (3/8)  * ( gamma(3/k)^2 ) / (  gamma(2/k) * gamma(4/k) )


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

XikNuk =    (3/8)  * (gamma(3./ip.Results.k).^2) ./ ...
          (  gamma(2./ip.Results.k) .* gamma(4./ip.Results.k) );


end

