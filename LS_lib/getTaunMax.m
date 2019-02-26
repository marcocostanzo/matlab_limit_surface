function tau_max = getTaunMax(fn, varargin)
% GETTAUNMAX compute the maximum pure torsional moment
%
%   taun_max = GETTAUNMAX(fn, ...key-value params...)
%   computes the maximum pure torsional moment given the normal force fn
%   and the friction and contact parameter.
%   Inputs:
%       - fn: normal force.
%   Key-Value Params:
%       - 'delta': delta, proportional value of the curve.
%       - 'gamma': gamma/exponent value of the curve.
%       - 'k': pressure distribution coefficient.
%       - 'mu': Friction coefficient.
%   Output
%       - taun_max: maximum pure torsional friction moment.



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
                                        'delta', ip.Results.delta,...
                                        'gamma', ip.Results.gamma);


end

