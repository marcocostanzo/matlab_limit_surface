function [ ft, taun ] = LSMultiContact(CoR, contacts, int_points, time_disp_status)
%LSMULTICONTACT Summary of this function goes here
%   Detailed explanation goes here

%parametri come struttura
% CoR: coordinate del CoR in terna {0}
% contacts[]: vettore di struct contenente le info dei vari contatti
%   fn: forza normale del contatti i-esimo
%   CoP: posizione centro di pressione 2D rispetto a terna {o}
%   contact_params: parametri fisici del contatti
%       mu: coefficiente di attrito
%       delta: coefficiente della legge del raggio R=delta*fn^gamma
%       gamma: esponente della legge del raggio R=delta*fn^gamma
%       k: coefficiente che discrimina la distribuzione di pressione
% int_points: punti da usare per l'integrale
% time_disp_status: tempo da usare nel display

%% Parse inputs

if( nargin < 3 )
    int_points = 6000;
end
if( nargin < 4 )
    time_disp_status = inf;
end

%% Calc for all contacts

ft = cell(size(CoR));
ft(:) = {zeros(2,1)};
taun = zeros(size(CoR));

last_print_time = tic;
initial_time = tic;
last_print_char = 0;

if ~isinf(time_disp_status)
	disp(['Start compute LS MultiContact (numContacts=' num2str(numel(contacts)) ' numCoRs=' num2str(numel(CoR)) ')...'])
end

for i=1:numel(contacts) %for all contacts
    
    if ~isinf(time_disp_status)
        disp('')
    	disp(['Start compute LS of contact ' num2str(i) '/' num2str(numel(contacts)) '...']);
     	disp('')
  	end
    
    % Build c_tilde vec of contact i and R_i for all CoRs
    c_tilde_vec_i = zeros(size(CoR));
    R_i = cell(size(CoR));
    for j=1:numel(CoR) %for all CoRs
        c_ij = CoR{j} - contacts{i}.CoP;
        norm_c_ij = norm(c_ij);
        if norm_c_ij == 0
            c_tilde_vec_i(j) = 0;
            x_hat_i = [1;0];
        else
            c_tilde_vec_i(j) = norm_c_ij ...
                / ...
                getRadius( ...
                    contacts{i}.fn, ...
                    contacts{i}.contact_params.delta, ...
                    contacts{i}.contact_params.gamma ...
                    );
            x_hat_i = c_ij/norm_c_ij;
        end
        R_i{j} = [
            x_hat_i, [-x_hat_i(2); x_hat_i(1)]
        ];
    end

    % Compute normalized LS for contact {i}
    [ ft_tilde_iy , taun_tilde_i ] = ...
        calculateLimitSurfaceNorm( ...
            c_tilde_vec_i, ...
            contacts{i}.contact_params.k, ...
            int_points, ...
            time_disp_status,...
            initial_time...
            );
    
    % Denormalize and sum up all contacts
    ft_max = getFtMax(contacts{i}.fn,contacts{i}.contact_params.mu);
    for j=1:numel(CoR) %for all CoRs
        
        ft_tilde_rotated = R_i{j} * [0; ft_tilde_iy(j)];
        
        ft{j} = ft{j} ...
            + ...
            ft_max ...
            * ...
            ft_tilde_rotated;
        
        corss_ft_tilde_i = ...
            cross( [contacts{i}.CoP; 0], [ ft_tilde_rotated ; 0] );
        
        taun(j) = taun(j) ...
            + ...
            getTaunMax( ...
                contacts{i}.fn, ...
                'mu', contacts{i}.contact_params.mu, ...
                'k', contacts{i}.contact_params.k, ...
                'delta', contacts{i}.contact_params.delta, ...
                'gamma', contacts{i}.contact_params.gamma ...
                ) ...
            * ...
            taun_tilde_i(j) ...
            + ...
            ft_max ...
            * ...
            corss_ft_tilde_i(3);
        
    end
    
    if ~isinf(time_disp_status)
        ETA = (numel(contacts)/i - 1)*(toc(initial_time)/60);
        disp('')
    	disp(['END compute LS of contact ' num2str(i) '/' num2str(numel(contacts)) '...']);
        disp(['ETA MultiLS ' num2str(ETA) ' m']);
     	disp('')
    end
        
end

