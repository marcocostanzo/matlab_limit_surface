function y = constSigmaLine(x,varargin)
%CONSTSIGMALINE is the curve at constant sigma in the NLS space
%
%   y = CONSTSIGMALINE(x, ...key-value params...)
%   implements the function:
%   y = 1/sigma * |x|^(gamma+1) * sign(x)
%
%   Inputs:
%       - x: x-axis values of the curve (i.e., ft_norm values)
%   Key-Value Params:
%       - 'sigma': sigma param of the curve.
%       - 'gamma': gamma/exponent value of the curve.
%   Output
%       - y: y-axis value of the curve (i.e., taun_norm values)



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
validScalarNum = @(x) isnumeric(x) && isscalar(x);
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(ip,'x', @isnumeric);
addParameter(ip,'sigma', [], validScalarNum);
addParameter(ip,'gamma', [], validScalarPosNum);

parse(ip,x,varargin{:})

if(~isempty(ip.UsingDefaults))
    error('Parameter ''%s'' is mandatory%s',ip.UsingDefaults{1},s)
end

%% Calc

y = (1/ip.Results.sigma).*(abs(ip.Results.x).^(ip.Results.gamma+1)).*sign(ip.Results.x);

end

