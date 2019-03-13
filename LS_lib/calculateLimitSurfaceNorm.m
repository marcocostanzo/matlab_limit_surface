function [ ft_norm , m_norm ] = calculateLimitSurfaceNorm( c_tilde_vec, k, int_points, time_disp_status )
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
%                           Default inf.
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
assert( all(k>0) && isnumeric(k) , 'k has to be numeric and positive' )
assert( isnumeric(c_tilde_vec) , 'c_tilde_vec has to be numeric' )
assert( isnumeric(int_points) && isscalar(int_points) &&  int_points>0, ...
        'int_points has to be scalar and positive' )
assert( isnumeric(time_disp_status) && isscalar(time_disp_status) &&  time_disp_status>0, ...
        'int_points has to be scalar and positive' )    

%% More than 1 LS
if( ~isscalar(k) )
   
    ft_norm = zeros( length(c_tilde_vec), length(k) );
    m_norm = zeros( length(c_tilde_vec), length(k) );
    
    if ~isinf(time_disp_status)
        initial_time = tic;
    end
    
    if ~isinf(time_disp_status)
        disp(['Start compute norm LS (x ' num2str(numel(k)) ')...'])
    end
    
    for j = 1:numel(k)
        
        if ~isinf(time_disp_status)
            disp('')
            disp(['Start compute norm LS ' num2str(j) '/' num2str(numel(k)) '...']);
            disp('')
        end
        
        [ ft_norm(:,j), m_norm(:,j) ] = calculateLimitSurfaceNorm( c_tilde_vec,... 
                                                                    k(j), ...
                                                                    int_points,... 
                                                                    time_disp_status... 
                                                                   );
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

initial_time = tic;

%Calc Xi_k
Xi_k = getXik(k);

%Calc nu_k
nu_k = getNuk(k);

%Calc Xi_k*nu_k
%Xi_k_nu_k = getXikNuk( k );

%Allocate gpu memory
c_tilde_vec = gpuArray(c_tilde_vec);

%Define functions to integrate
function z = F_ft(c_tilde)
    %ct = cos(theta);
    if(c_tilde == 0)
        z = ct .* comm_num;
    else
        z =  ( rr_ct - c_tilde ) ./ sq .* comm_num ;
        if any((any(isnan((z))))) %NaN values should be zero (see the plot of F_ft)
            %warning('nan in F_ft')
            z(isnan(z)) = 0;
            %z(isnan(z)) = press(isnan(z)) .* rr(isnan(z)) ./ sqrt(2);
        end
    end   
end

function z = F_m(c_tilde)
    
    if(c_tilde == 0)
        z = rr.*comm_num;
    else
        z = (rr - c_tilde.*ct) .* rr ./ sq  .* comm_num;
        if any(any(isnan((z)))) %NaN values should be zero (see the plot of F_m)
            %warning('nan in F_m')
            z(isnan(z)) = 0;
            %z(isnan(z)) = press(isnan(z)) .* (rr(isnan(z)).^2) ./ sqrt(2);
        end
    end   
end

%Generate domain
% note: ct here is theta, not cos(theta).. the var is the same to not
% allocate usless memory
[ rr , ct , rr_spac, tt_spac] = trapz2_gpu_getGPUArrays( 0, 1, 0, 2*pi, int_points );

%pecalculate cos(tt);
ct = cos(ct);
%precalc common numerator
comm_num = rr.*((1-(rr.^k)).^(1/k));
rr2 = rr.^2;
rr_ct = rr.*ct;

%Constant values
cost1 = Xi_k/pi;
cost2 = 1/(2*pi*nu_k);

%Num points to compute
l_vec = length(c_tilde_vec);

%prealloc
ft_norm = zeros(l_vec,1);
m_norm = zeros(l_vec,1);

%Disp status vars
if ~isinf(time_disp_status)
    disp(['Start to compute norm LS (k = ' num2str(k) ')...'])
end
last_print_time = tic;
last_print_char = 0;

for  i = 1:l_vec
   
    %select c_tilde
	c_tilde = c_tilde_vec(i);

    %compute common square root
	sq = sqrt(rr2 + c_tilde.^2 - 2*rr_ct.*c_tilde);

    %function inside the integral
	Z = F_ft(c_tilde);

    %integrate
	Z = trapz(Z) * tt_spac;
	Z =  trapz(Z) * rr_spac;
	ft_norm(i) = cost1 * gather(Z);
	%ft(i) = trapz(theta_,trapz(r_,Z,2));

    %function inside the integral
	Z = F_m(c_tilde);

    %integrate
	Z = trapz(Z) * tt_spac;
	Z =  trapz(Z) * rr_spac;
	m_norm(i) = cost2 * gather(Z);
	%m(i) = trapz(theta_,trapz(r_,Z,2));

	if( toc(last_print_time) >  time_disp_status )
        %Print status
        last_print_time = tic;
        fprintf( repmat('\b',1,last_print_char) )
        last_print_char = 0;
        last_print_char = last_print_char + fprintf( ['processed = ' num2str(i) '/' num2str(l_vec) ' -> ' num2str((i/l_vec)*100,6) '%%' '\n']); 
        last_print_char = last_print_char + fprintf( [ 'run time = ' num2str(toc(initial_time)) ' s' '\n' ] );
	end

end

if ~isinf(time_disp_status)
    fprintf( repmat('\b',1,last_print_char) )
    %last_print_char = 0;
    %last_print_char = last_print_char + ...
        fprintf( ['processed = ' num2str(i) '/' num2str(l_vec) ' -> ' num2str((i/l_vec)*100,6) '%%' '\n']); 
    %last_print_char = last_print_char + ...
        fprintf( [ 'run time = ' num2str(toc(initial_time)) ' s' '\n' ] );
    disp(['Compute norm LS END! (k = ' num2str(k) ')'])
    disp(['elapsed time: ' num2str(toc(initial_time)) ' s'])
end


end

