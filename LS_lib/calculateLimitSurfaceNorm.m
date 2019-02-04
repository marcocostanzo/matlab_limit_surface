function [ ft_norm , m_norm ] = calculateLimitSurfaceNorm( c_tilde_vec, k, int_points, time_disp_status )
%CALCULATELIMITSURFACE Summary of this function goes here
%   Detailed explanation goes here

if( ~isscalar(k) )
   
    ft_norm = zeros( length(c_tilde_vec), length(k) );
    m_norm = zeros( length(c_tilde_vec), length(k) );
    
    if ~isinf(time_disp_status)
        disp('Start compute norm LS')
    end
    
    for j = 1:length(k)
        if ~isinf(time_disp_status)
            disp('')
            disp(['norm LS ' num2str(j) '/' num2str(length(k))]);
        end
        [ ft_norm(:,j), m_norm(:,j) ] = calculateLimitSurfaceNorm( c_tilde_vec,... 
                                                                    k(j), ...
                                                                    int_points,... 
                                                                    time_disp_status... 
                                                                   );
    end
    return;
end

if( nargin < 3 )
    int_points = 6000;
end
if( nargin < 4 )
    time_disp_status = inf;
end

initial_time = tic;

%calcola C_k
Xi_k = getXik(k);

%Calcola ni_k
nu_k = getNuk( k );

%Calcola C_k*ni_k
%C_k_ni_k = getCkNik( k );

c_tilde_vec = gpuArray(c_tilde_vec);

%Define functions to integrate
function z = F_ft(c_tilde)
    %ct = cos(theta);
    if(c_tilde == 0)
        z = ct .* comm_num;
    else
        z =  ( rr_ct - c_tilde ) ./ sq .* comm_num ;
        if any((any(isnan((z)))))
            %warning('nan in F_ft')                                                  ')
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
        if any(any(isnan((z))))
            %warning('nan in F_m')                                                   ')
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

cost1 = Xi_k/pi;
cost2 = 1/(2*pi*nu_k);

l_vec = length(c_tilde_vec);

ft_norm = zeros(l_vec,1);
m_norm = zeros(l_vec,1);

if ~isinf(time_disp_status)
    disp('Start compute norm LS...')
end
last_print_time = tic;
last_print_char = 0;

for  i = 1:l_vec %[0 logspace(-2,-1,(1+2)*10) linspace(0.1,10,1000) logspace(1,3,40)] %alfa =[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.2 1.5 2 3 10 10000000] % [0 logspace(-2,1,20)]% 0:0.1:3  %alfa = c/R   ---> c = alfa*R
   %clc,actual_c 
   %keyboard
   %disp(num2str(i/l_vec*100))
   
   c_tilde = c_tilde_vec(i);
   
   sq = sqrt(rr2 + c_tilde.^2 - 2*rr_ct.*c_tilde);
   
   Z = F_ft(c_tilde);
   
   Z = trapz(Z) * tt_spac;
   Z =  trapz(Z) * rr_spac;
   ft_norm(i) = cost1 * gather(Z);
   %ft(i) = trapz(theta_,trapz(r_,Z,2));
   
   Z = F_m(c_tilde);
   
   Z = trapz(Z) * tt_spac;
   Z =  trapz(Z) * rr_spac;
   m_norm(i) = cost2 * gather(Z);
   %m(i) = trapz(theta_,trapz(r_,Z,2));
   
   if( toc(last_print_time) >  time_disp_status )
      last_print_time = tic;
      fprintf( repmat('\b',1,last_print_char) )
      last_print_char = 0;
      last_print_char = last_print_char + fprintf( ['processed = ' num2str(i) '/' num2str(l_vec) ' -> ' num2str((i/l_vec)*100,6) '%%' '\n']); 
      last_print_char = last_print_char + fprintf( [ 'run time = ' num2str(toc(initial_time)) ' s' '\n' ] );
   end
   
end

if ~isinf(time_disp_status)
    fprintf( repmat('\b',1,last_print_char) )
    last_print_char = 0;
    last_print_char = last_print_char + fprintf( ['processed = ' num2str(i) '/' num2str(l_vec) ' -> ' num2str((i/l_vec)*100,6) '%%' '\n']); 
    last_print_char = last_print_char + fprintf( [ 'run time = ' num2str(toc(initial_time)) ' s' '\n' ] );
    disp('Compute norm LS END!')
    disp(['elapsed time ' num2str(toc(initial_time)) ' s'])
end


end
