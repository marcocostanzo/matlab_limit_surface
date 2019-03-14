function R = getRadius(fn,varargin)
% GETRADIUS computes the radius of the contact area
%
%   R = GETRADIUS(fn, delta, gamma)
%   computes the radius of the contact area using the model:
%   y = delta * (fn^gamma)   
%
%   Inputs:
%       - fn: the normal force, must be positive.
%       - delta: delta, proportional value of the curve.
%       - gamma: gamma/exponent value of the curve.
%   Output:
%       - R: radius of the contact area.
%   Note:
%       Key-Value interface supported, but do NOT use it with the
%       codegeneration (e.g. Simulink)
%       R = GETRADIUS(fn, 'delta', delta, 'gamma', gamma)


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
validNonNegNum = @(x) isnumeric(x) && all(x >= 0);
validScalarNonNegNum = @(x) isnumeric(x) && isscalar(x) && (x >= 0);

if( numel(varargin) == 2 )
    %no keyvalue    
    delta = varargin{1};
    gamma = varargin{2};
    
else
    %keyvalue
    
    ip = inputParser;
    addRequired(ip,'fn', validNonNegNum);
    addParameter(ip,'delta', [], validScalarNonNegNum);
    addParameter(ip,'gamma', [], validScalarNonNegNum);

    parse(ip,fn,varargin{:})

    if(~isempty(ip.UsingDefaults))
        error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
    end
    
    delta = ip.Results.delta;
    gamma = ip.Results.gamma;
    
end

%check
assert( validNonNegNum(fn) , 'fn has to and non negative' )
assert( validScalarNonNegNum(delta) , 'delta has to be scalar and non negative' )
assert( validScalarNonNegNum(gamma) , 'gamma has to be scalar and non negative' )

%% Calc

R = delta * ( fn.^gamma );


end

