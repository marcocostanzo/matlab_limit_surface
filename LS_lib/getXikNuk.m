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

%validetors
validNonNegNum = @(x) isnumeric(x) && all(x >= 0);

%check
assert( validNonNegNum(k) , 'k has to be numeric and non-negative' )

b_zero = false;
zero_index = (k == 0);
if any(zero_index)
    if coder.target('MATLAB')
        warning('k contains zero elements -> xi_k(0)*nu_k(0) = 0')
    end
    b_zero = true;
end

b_inf = false;
inf_idex = ( isinf(k) );
if any(inf_idex)
    if coder.target('MATLAB')
        warning('k contains inf elements -> xi_k(inf)*nu_k(inf) = 1/3') 
    end
    b_inf = true;
end

%% Calc

XikNuk =    (3/8)  * (gamma(3./k).^2) ./ ...
          (  gamma(2./k) .* gamma(4./k) );

if b_zero
   XikNuk(zero_index) = 0; 
end

if b_inf
   XikNuk(inf_idex) = 1/3; 
end
      
end

