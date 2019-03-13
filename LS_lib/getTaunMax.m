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

%validators
validScalarNonNegNum = @(x) isnumeric(x) && isscalar(x) && (x >= 0);

if numel(varargin) == 4
    %no keyvalue
    mu = varargin{1};
    k = varargin{2};
    delta = varargin{3};
    gamma = varargin{4};
    
else
    %keyvalue
    
    ip = inputParser;
    addRequired(ip,'fn', @isnumeric);
    addParameter(ip,'mu', [], validScalarNonNegNum);
    addParameter(ip,'k', [], validScalarNonNegNum);
    addParameter(ip,'delta', [], validScalarNonNegNum);
    addParameter(ip,'gamma', [], validScalarNonNegNum);

    parse(ip,fn,varargin{:})

    if(~isempty(ip.UsingDefaults))
        error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
    end
    
    mu = ip.Results.mu;
    k = ip.Results.k;
    delta = ip.Results.delta;
    gamma = ip.Results.gamma;
    
end

%check
assert( isnumeric(fn) , 'fn has to be numeric' )
assert( validScalarNonNegNum(mu) , 'mu has to be scalar and non negative' )
assert( validScalarNonNegNum(k) , 'k has to be scalar and non negative' )
assert( validScalarNonNegNum(delta) , 'delta has to be scalar and non negative' )
assert( validScalarNonNegNum(gamma) , 'gamma has to be scalar and non negative' )


%% Calc

tau_max =   2 * mu * getXikNuk(k) * ...
            fn .* getRadius( fn,...
                             delta,...
                             gamma);


end

