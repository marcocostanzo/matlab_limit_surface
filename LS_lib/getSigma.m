function sigma = getSigma(ft,tau,varargin)
%GETSIGMA compute sigma given the force and the torque.
%
%   Normalized inputs:
%   sigma = getSigma(ft_norm,taun_norm,gamma)
%   or
%   sigma = getSigma(ft_norm,taun_norm,'gamma',gamma)
%   computes the value of sigma given the normalized force and torque, i.e.
%   ft_norm = ft/ft_max and taun_norm = taun/taun_max
%  
%   -----------------------------------------------------------------------
%
%   Non-Normalized inputs:
%   sigma = GETRADIUS(ft, taun, ...key-value params...)
%   Inputs:
%       - ft: tangential force.
%       - taun: torsional moment.
%   Key-Value Params:
%       - 'delta': delta, proportional value of the curve.
%       - 'gamma': gamma/exponent value of the curve.
%       - 'k': pressure distribution coefficient.
%       - 'mu': Friction coefficient.
%   Output
%       - sigma: sigma value.


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
