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

contacts{1}.fn = 10;
contacts{1}.CoP = [0.03; 0.03];
contacts{1}.contact_params.mu = 0.8;
contacts{1}.contact_params.delta = 0.00349;
contacts{1}.contact_params.gamma = 1/3;
contacts{1}.contact_params.k = 4;

contacts{2} = contacts{1};
contacts{1}.CoP = -[0.03; 0.03];

% Build CoR
[CoR_x,CoR_y] = meshgrid(-0.1:0.01:0.1,-0.1:0.01:0.1);
CoR = cell(size(CoR_x));
for i=1:numel(CoR_x); CoR{i} = [CoR_x(i); CoR_y(i)]; end

[ ft, taun ] = LSMultiContact(CoR, contacts, int_points, time_disp_status);

% Extract ft_x ft_y
ft_x = zeros(size(ft));
ft_y = zeros(size(ft));
for i=1:numel(ft); tmp = ft{i}; ft_x(i) = tmp(1); ft_y(i) = tmp(2); end

figure,surf( ft_x, ft_y, taun )