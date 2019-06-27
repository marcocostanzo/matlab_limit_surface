function [ ft_norm , m_norm, n_processed ] = calculateLSNorm_catched(c_tilde_vec, k, Xi_k, nu_k, r_interval , theta_interval, int_points, time_disp_status, initial_time, n_processed, n_total)

if nargin < 11
    n_total = numel(c_tilde_vec);
end
if nargin < 10 
    n_processed = 0;
end

%Generate domain
try

    [ ft_norm , m_norm ] = calculateLSNorm_internal(c_tilde_vec, k, Xi_k, nu_k, r_interval , theta_interval, int_points, time_disp_status, initial_time, n_processed, n_total);
    
catch ME
    switch ME.identifier
        case {'parallel:gpu:array:pmaxsize', 'parallel:gpu:array:OOM' }
            if nargin < 11
                n_total = 4*numel(c_tilde_vec);
            else
                n_total = n_total + 4*numel(c_tilde_vec);
            end
            warning(['GPU Memory error - dividing domain in ' num2str(2^ceil(log2(n_total/numel(c_tilde_vec)))) ' sets...'])
            gpuDevice(1);
            ze_r = r_interval(1);
            r_2 = (r_interval(2) + r_interval(1))/2;
            m_r = r_interval(2);
            ze_t = theta_interval(1);
            t_2 = (theta_interval(2) + theta_interval(1))/2;
            m_t = theta_interval(2);
            [ft_norm1, m_norm1, n_processed] = calculateLSNorm_catched(c_tilde_vec, k, Xi_k, nu_k, [ze_r r_2], [ze_t t_2], floor(int_points/2), time_disp_status, initial_time, n_processed, n_total );
            [ft_norm2, m_norm2, n_processed] = calculateLSNorm_catched(c_tilde_vec, k, Xi_k, nu_k, [r_2 m_r], [ze_t t_2], floor(int_points/2), time_disp_status, initial_time, n_processed, n_total );
            [ft_norm3, m_norm3, n_processed] = calculateLSNorm_catched(c_tilde_vec, k, Xi_k, nu_k, [ze_r r_2], [t_2 m_t], floor(int_points/2), time_disp_status, initial_time, n_processed, n_total );
            [ft_norm4, m_norm4, n_processed] = calculateLSNorm_catched(c_tilde_vec, k, Xi_k, nu_k, [r_2 m_r], [t_2 m_t], floor(int_points/2), time_disp_status, initial_time, n_processed, n_total );
            ft_norm = ft_norm1+ft_norm2+ft_norm3+ft_norm4;
            m_norm = m_norm1+m_norm2+m_norm3+m_norm4;
            return;
        otherwise
            rethrow(ME)
    end  
end

end

