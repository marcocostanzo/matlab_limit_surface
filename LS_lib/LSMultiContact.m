function [ ftx, fty, taun, contacts ] = LSMultiContact(CoRx, CoRy, contacts, int_points, time_disp_status)
%LSMULTICONTACT Summary of this function goes here
%   Detailed explanation goes here

%parametri come struttura
% CoR: coordinate del CoR in terna {0}
% contacts[]: vettore di struct contenente le info dei vari contatti
%   fn: forza normale del contatti i-esimo
%   CoP: posizione centro di pressione 2D rispetto a terna {0}
%   contact_params: parametri fisici del contatti
%       mu: coefficiente di attrito
%       delta: coefficiente della legge del raggio R=delta*fn^gamma
%       gamma: esponente della legge del raggio R=delta*fn^gamma
%       k: coefficiente che discrimina la distribuzione di pressione
%   LS_local: Superficie Limite del contatto i nella terna locale {i}
%             orientata come {0}
%       ftx:
%       fty:
%       taun:
%   LS_global: LS del contatto i nella terna {0}
%       ftx:
%       fty:
%       taun:
% int_points: punti da usare per l'integrale
% time_disp_status: tempo da usare nel display

%% Parse inputs

assert(all(size(CoRx) == size(CoRy)), 'CoRx and CoRy must be same size')

if( nargin < 3 )
    int_points = 6000;
end
if( nargin < 4 )
    time_disp_status = inf;
end

%% Calc for all contacts

ftx = zeros(size(CoRx));
fty = zeros(size(CoRx));
taun = zeros(size(CoRx));

initial_time = tic;

if ~isinf(time_disp_status)
	disp(['Start compute LS MultiContact (numContacts=' num2str(numel(contacts)) ' numCoRs=' num2str(numel(CoRx)) ')...'])
end

for i=1:numel(contacts) %for all contacts
    
    if ~isinf(time_disp_status)
        disp('')
    	disp(['Start compute LS of contact ' num2str(i) '/' num2str(numel(contacts)) '...']);
     	disp('')
  	end
    
    % Build c_tilde vec of contact i and R_i for all CoRs
    c_tilde_vec_i = zeros(size(CoRx));
    R_i = cell(size(CoRx));
    for j=1:numel(CoRx) %for all CoRs
        c_ij = [CoRx(j);CoRy(j)] - contacts{i}.CoP;
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
            tic...
            );
        
    % Initialize output structure
    contacts{i}.LS_local.ftx = zeros(size(CoRx));
    contacts{i}.LS_local.fty = zeros(size(CoRx));
    contacts{i}.LS_local.taun = zeros(size(CoRx));
    contacts{i}.LS_global.ftx = zeros(size(CoRx));
    contacts{i}.LS_global.fty = zeros(size(CoRx));
    contacts{i}.LS_global.taun = zeros(size(CoRx));
    
    % Denormalize and sum up all contacts
    ft_max = getFtMax(contacts{i}.fn,contacts{i}.contact_params.mu);
    taun_max = getTaunMax( ...
                contacts{i}.fn, ...
                'mu', contacts{i}.contact_params.mu, ...
                'k', contacts{i}.contact_params.k, ...
                'delta', contacts{i}.contact_params.delta, ...
                'gamma', contacts{i}.contact_params.gamma ...
                );
    for j=1:numel(CoRx) %for all CoRs
        
        ft_rotated_ij = R_i{j} * [0; ft_max*ft_tilde_iy(j)];
        corss_ft_ij = cross( [contacts{i}.CoP; 0], [ ft_rotated_ij ; 0] );
        
        contacts{i}.LS_local.ftx(j) = ft_rotated_ij(1);
        contacts{i}.LS_local.fty(j) = ft_rotated_ij(2);
        contacts{i}.LS_local.taun(j) = taun_max*taun_tilde_i(j);
        
        contacts{i}.LS_global.ftx(j) = ft_rotated_ij(1);
        contacts{i}.LS_global.fty(j) = ft_rotated_ij(2);
        contacts{i}.LS_global.taun(j) = contacts{i}.LS_local.taun(j) + corss_ft_ij(3);
        
        ftx(j) = ftx(j) + ft_rotated_ij(1);
        fty(j) = fty(j) + ft_rotated_ij(2); 
        taun(j) = taun(j) + contacts{i}.LS_global.taun(j);
        
    end
    
    if ~isinf(time_disp_status)
        ETA = (numel(contacts)/i - 1)*(toc(initial_time)/60);
        disp('')
    	disp(['END compute LS of contact ' num2str(i) '/' num2str(numel(contacts)) '...']);
        disp(['ETA MultiLS ' num2str(ETA) ' m']);
     	disp('')
    end
        
end

