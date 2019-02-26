function ft_max = getFtMax(fn,varargin)
% GETFTMAX compute the maximum pure tangential force
%
%   y = GETFTMAX(fn, mu)
%   or
%   y = GETFTMAX(fn, 'mu', mu)
%   computes the maximum pure tangential force given the normal force fn
%   and the friction coefficient mu.



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

if(nargin > 2)
    addParameter(ip,'mu', [], validScalarPosNum);
else
    addRequired(ip,'mu', validScalarPosNum);
end

parse(ip,fn,varargin{:});

%if(~isempty(ip.UsingDefaults))
%    error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
%end

%% Calc

ft_max = ip.Results.mu .* ip.Results.fn;

end

