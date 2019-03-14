function ft_max = getFtMax(fn,varargin)
% GETFTMAX compute the maximum pure tangential force
%
%   y = GETFTMAX(fn, mu)
%   or
%   y = GETFTMAX(fn, 'mu', mu)
%   computes the maximum pure tangential force given the normal force fn
%   and the friction coefficient mu.
%   Note:
%       Do NOT use the key-value interface with the codegeneration 
%       (e.g. Simulink)



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

if( numel(varargin) == 1 )
    %no keyvalue
    mu = varargin{1};
    
else
    %key value
    
    ip = inputParser;
    addRequired(ip,'fn', @isnumeric);
    addParameter(ip,'mu', [], validScalarNonNegNum);
    
    parse(ip,fn,varargin{:});
    
    %if(~isempty(ip.UsingDefaults))
    %    error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
    %end
    
    mu = ip.Results.mu;
    
end

%check
assert( isnumeric(fn) , 'fn has to be numeric' )
assert( validScalarNonNegNum(mu) , 'mu has to be scalar and non negative' )

%% Calc

ft_max = mu .* fn;

end

