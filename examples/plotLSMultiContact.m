clearvars
close all

%Add path to lib
addpath('../LS_lib/')

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

int_points = 6000;
time_disp_status = 10;

%% Contacts 

contacts{1}.fn = 10;
contacts{1}.CoP = [0.03; 0.03];
contacts{1}.contact_params.mu = 0.8;
contacts{1}.contact_params.delta = 0.00349;
contacts{1}.contact_params.gamma = 1/3;
contacts{1}.contact_params.k = 4;

contacts{2} = contacts{1};
contacts{1}.CoP = -[0.03; 0.03];

%% Build CoR
% mu = [1/2 1/2];
% sigma = [1/5 0; 0 1/5];
% R = mvnrnd(mu,sigma,30000)';
[CoRx,CoRy] = meshgrid(-0.1:0.005:0.1,-0.1:0.005:0.1);

%% Compute
[ ftx, fty, taun, contacts ] = LSMultiContact(CoRx, CoRy, contacts, int_points, time_disp_status);

%% Plot

figure
ind = 0;
for i=1:numel(contacts)
    ind = ind+1;
    subplot(numel(contacts),2,ind)
    surf( contacts{i}.LS_local.ftx, contacts{i}.LS_local.fty, contacts{i}.LS_local.taun )
    title(['Contact ' num2str(i) ' LS Local'])
    
    ind = ind+1;
    subplot(numel(contacts),2,ind)
    surf( contacts{i}.LS_global.ftx, contacts{i}.LS_global.fty, contacts{i}.LS_global.taun )
    title(['Contact ' num2str(i) ' LS Global'])
end

figure
surf( ftx, fty, taun )
title(['Total Global LS'])