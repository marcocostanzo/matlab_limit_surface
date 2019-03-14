function sigma = getSigma(ft,tau,varargin)
%GETSIGMA compute sigma given the force and the torque.
%
%   Normalized inputs:
%   sigma = GETSIGMA(ft_norm,taun_norm,gamma)
%   or
%   sigma = GETSIGMA(ft_norm,taun_norm,'gamma',gamma)
%   computes the value of sigma given the normalized force and torque, i.e.
%   ft_norm = ft/ft_max and taun_norm = taun/taun_max
%  
%   -----------------------------------------------------------------------
%
%   Non-Normalized inputs:
%   sigma = GETSIGMA(ft, taun, gamma, k, delta, mu)
%   or
%   sigma = GETSIGMA(ft, taun, ...key-value params...)
%   Inputs:
%       - ft: tangential force.
%       - taun: torsional moment.
%       - gamma: gamma/exponent value of the radius model.
%       - k: pressure distribution coefficient.
%       - delta: delta, proportional value of the radius model.
%       - mu: Friction coefficient.
%   Output
%       - sigma: sigma value.
%   Note:
%       Key-Value interface supported, but do NOT use it with the
%       codegeneration (e.g. Simulink)


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

if numel(varargin) == 1
    %no keyvalue
    % ft_norm,taun_norm,gamma
    
    gamma = varargin{1};
    normalized = true;
    
elseif numel(varargin) == 4
    %no keyvalue
    %ft,taun,gamma,k,delta,mu
    
    gamma = varargin{1};
    k = varargin{2};
    delta = varargin{3};
    mu = varargin{4};
    normalized = false;

else
    %keyvalue
    
    ip = inputParser;
    addRequired(ip,'ft', @isnumeric);
    addRequired(ip,'tau', @isnumeric);
    
    if nargin < 4
       normalized = true;
       gamma = varargin{1};
       addRequired(ip,'gamma', validScalarNonNegNum);
       parse(ip,ft,tau,gamma)
    else

        addParameter(ip,'gamma', [],validScalarNonNegNum);

        if nargin > 4
            normalized = false;
            addParameter(ip,'k', [], validScalarNonNegNum);
            addParameter(ip,'delta', [], validScalarNonNegNum);
            addParameter(ip,'mu', [], validScalarNonNegNum);
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
    
    gamma = ip.Results.gamma;
    if ~normalized
        k = ip.Results.k;
        delta = ip.Results.delta;
        mu = ip.Results.mu;
    end
        
end

%Dimension check
assert( isequal(size(ft),size(tau)), 'ft and tau has to be same size' )
assert( validScalarNonNegNum(gamma) , 'gamma has to be scalar and non negative' )
if ~normalized
    assert( validScalarNonNegNum(k) , 'k has to be scalar and non negative' )
    assert( validScalarNonNegNum(delta) , 'delta has to be scalar and non negative' )
    assert( validScalarNonNegNum(mu) , 'mu has to be scalar and non negative' )
end

%% Calc
if normalized
    
    const = 1;
    
else
    
    const = 2 * getXikNuk(k) * delta / ( mu^gamma );
    
end
    
sigma = const*(abs(ft).^(gamma+1)).* sign(ft) ./ tau;
