function [ ft_norm , m_norm ] = calculateLimitSurfaceNorm( c_tilde_vec, k, int_points, time_disp_status, initial_time )
%CALCULATELIMITSURFACENORM calculate the normalized values of the Limit
%Surface (LS)
%   [ ft_norm , m_norm ] = CALCULATELIMITSURFACENORM( c_tilde_vec, k, 
%                                       int_points, time_disp_status )
%   Inputs:
%       - c_tilde_vec: Vector containing the normalized COR positions
%                      (c_tilde). This function will compute a point of the
%                      LS for each point of c_tilde_vec.
%       - k: Value that characterizes the pressure distribution.
%            k = 2 Hertzian, k->inf Uniform. k can be a vector, in such
%            case, this function will compute various LS for each value of
%            k, columnwise.
%       - int_points: num of points to use in the discretization of
%                     integrals. Default 6000.
%       - time_disp_status: This function will print the status on the
%                           Command Window every time_disp_status seconds.
%                           Default inf (for codegen, e.g. Simulink, it 
%                           MUST be inf).
%   Outputs:
%       - ft_norm: f coordinates of the computed points.
%                  Size = numel(c_tilde_vec) x numel(k).
%       - m_norm: tau coordinates of the computed points.
%                 Size = numel(c_tilde_vec) x numel(k).
%   Note:
%       This function uses the GPU. Only CPU not supported yet.



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

%% Parse Inputs

if( nargin < 3 )
    int_points = 6000;
end
if( nargin < 4 )
    time_disp_status = inf;
end
if( nargin < 5 )
    initial_time = tic;
end
assert( all(k>0) && isnumeric(k) , 'k has to be numeric and positive' )
assert( isnumeric(c_tilde_vec) , 'c_tilde_vec has to be numeric' )
assert( isnumeric(int_points) && isscalar(int_points) &&  int_points>0, ...
        'int_points has to be scalar and positive' )
assert( isnumeric(time_disp_status) && isscalar(time_disp_status) &&  time_disp_status>0, ...
        'time_disp_status has to be scalar and positive' )
assert( isnumeric(initial_time) && isscalar(initial_time) &&  initial_time>0, ...
        'initial_time has to be scalar and positive' )

%% More than 1 LS
if( ~isscalar(k) )
   
    ft_norm = zeros( length(c_tilde_vec), length(k) );
    m_norm = zeros( length(c_tilde_vec), length(k) );
    
    if ~isinf(time_disp_status)
        disp(['Start compute norm LS (x ' num2str(numel(k)) ')...'])
    end
    
    for j = 1:numel(k)
        
        if ~isinf(time_disp_status)
            disp('')
            disp(['Start compute norm LS ' num2str(j) '/' num2str(numel(k)) '...']);
            disp('')
        end
        
        [ ft_norm_out, m_norm_out ] = calculateLimitSurfaceNorm( c_tilde_vec,... 
                                                                    k(j), ...
                                                                    int_points,... 
                                                                    time_disp_status,...
                                                                    initial_time ...
                                                                   );
        % Put outputs in columns                                                       
        ft_norm(:,j) = ft_norm_out(:);
        m_norm(:,j) = m_norm_out(:);
                                                               
        if ~isinf(time_disp_status)
            disp('')
            disp(['Done norm LS ' num2str(j) '/' num2str(numel(k))])
            disp(['Elapsed Time: ' num2str(toc(initial_time))]);
            disp('')
        end
    end
    
    if ~isinf(time_disp_status)
            disp('')
            disp(['Done compute all LS (x ' num2str(numel(k)) ')'])
            disp(['Elapsed Time: ' num2str(toc(initial_time)) ' s']);
            disp('')
    end
    
    return;
end

%% Just 1 LS

%Calc Xi_k
Xi_k = getXik(k);

%Calc nu_k
nu_k = getNuk(k);

%Calc Xi_k*nu_k
%Xi_k_nu_k = getXikNuk( k );

%Allocate gpu memory & calc LSN
[ft_norm, m_norm] = calculateLSNorm_catched(c_tilde_vec, k, Xi_k, nu_k,[0 1], [0 2*pi], int_points, time_disp_status, initial_time );

end

