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

for j=1:numel(CoR) %for all CoRs
for i=1:numel(contacts) %for all contacts
    
    % Build R_i, rotation matrix of contact {i} in frame {0}
    try
        x_hat_i = unit(CoR{j} - contacts{i}.CoP);
        R_i = [
            unit(x_hat_i), [-x_hat_i(2); x_hat_i(1)]
        ];
    catch ME
        switch ME.identifier
            case {'RTB:unit:zero_norm'}
                % x_hat_i undefined! R can be anything!
                R_i = eye(2);
            otherwise
                rethrow(ME)
        end   
    end

    % Compute c_tilde_i, normalized CoR in frame {i}
    c_tilde_i = norm(CoR{j} - contacts{i}.CoP) ...
        / ...
        getRadius( ...
            contacts{i}.fn, ...
            contacts{i}.contact_params.delta, ...
            contacts{i}.contact_params.gamma ...
            );

    % Compute normalized LS for contact {i}
    [ ft_tilde_iy , taun_tilde_i ] = ...
        calculateLimitSurfaceNorm( ...
            c_tilde_i, ...
            contacts{i}.contact_params.k, ...
            int_points, ...
            inf ...
            );
    
    % Denormalize and sum up all contacts
    
    ft{j} = ft{j} ...
        + ...
        getFtMax(contacts{i}.fn,contacts{i}.contact_params.mu) ...
        * ...
        R_i * [0; ft_tilde_iy];
    
    corss_ft_tilde_i = ...
        cross( [contacts{i}.CoP; 0], [ R_i*[0; ft_tilde_iy] ; 0] );
    
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
        taun_tilde_i ...
        + ...
        getFtMax(contacts{i}.fn,contacts{i}.contact_params.mu) ...
        * ...
        corss_ft_tilde_i(3);
    
    if( toc(last_print_time) >  time_disp_status )
        %Print status
        last_print_time = tic;
        fprintf( repmat('\b',1,last_print_char) )
        last_print_char = 0;
        last_print_char = last_print_char + fprintf( ['processed = ' num2str(j) '/' num2str(numel(CoR)) ' -> ' num2str((j/numel(CoR))*100,6) '%%' '\n']); 
        last_print_char = last_print_char + fprintf( [ 'run time = ' num2str(toc(initial_time)) ' s' '\n' ] );  
    end
        
end




end

