function [ ft_norm , m_norm, n_processed ] = calculateLSNorm_internal(c_tilde_vec, k, Xi_k, nu_k, r_interval , theta_interval, int_points, time_disp_status, initial_time, n_processed, n_total)

%Generate domain
[ rr , ct , rr_spac, tt_spac] = trapz2_gpu_getGPUArrays( r_interval(1), r_interval(2), theta_interval(1), theta_interval(2), int_points );
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
    
    n_processed = n_processed + 1;

	if( toc(last_print_time) >  time_disp_status )
        %Print status
        last_print_time = tic;
        fprintf( repmat('\b',1,last_print_char) )
        last_print_char = 0;
        last_print_char = last_print_char + fprintf( ['processed = ' num2str(i) '/' num2str(l_vec) ' ' num2str(n_processed) '/' num2str(n_total) ' -> ' num2str((n_processed/n_total)*100,6) '%%' '\n']); 
        last_print_char = last_print_char + fprintf( [ 'run time = ' num2str(toc(initial_time)) ' s' '\n' ] );
	end

end

if ~isinf(time_disp_status)
    fprintf( repmat('\b',1,last_print_char) )
    %last_print_char = 0;
    %last_print_char = last_print_char + ...
        fprintf( ['processed = ' num2str(i) '/' num2str(l_vec) ' -> ' num2str((n_processed/n_total)*100,6) '%%' '\n']); 
    %last_print_char = last_print_char + ...
        fprintf( [ 'run time = ' num2str(toc(initial_time)) ' s' '\n' ] );
    disp(['Compute norm LS END! (k = ' num2str(k) ')'])
    disp(['elapsed time: ' num2str(toc(initial_time)) ' s'])
end

end

