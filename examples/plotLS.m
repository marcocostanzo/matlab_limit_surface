clear all
clc

addpath('../LS_lib/')

%% Params
c_tilde = [linspace(0, 4, 100) 1e10 ];
c_tilde = [ -fliplr(c_tilde) c_tilde];
k_vec = [2 4 1e10];
colors_cell = {'b', 'r', 'k'};

gamma = 0.2569;
delta = 0.00349;
mu = 0.6;
Fn = 10;

int_points = 6000;
print_delay = 10;

%% Calc
[ ft_norm , taun_norm ] = calculateLimitSurfaceNorm( c_tilde,...
                                                  k_vec,...
                                                  int_points,...
                                                  print_delay ...
                                                 );

ft_max = zeros(size(k_vec));
taun_max = zeros(size(k_vec));
sigma = zeros(length(c_tilde),length(k_vec));
ft = zeros(size(ft_norm));
taun = zeros(size(taun_norm));
for i=1:length(k_vec)                             
    ft_max(i) = getFtMax(Fn,mu);
    taun_max(i) = getTaunMax(Fn, 'mu', mu, 'k', k_vec(i), 'delta', delta, 'gamma', gamma);
    sigma(:,i) = getSigma(ft_norm(:,i), taun_norm(:,i), 'gamma', gamma, 'k', k_vec(i), 'delta', delta, 'mu', mu);
    ft(:,i) = ft_norm(:,i)*ft_max(i);
    taun(:,i) = taun_norm(:,i)*taun_max(i);
end

%% Plot
figure(1)
cla
hold on
title(['Limit Surface Fn = ' num2str(Fn)])
leg = legend('show');
set(leg, 'Interpreter' ,'latex','Location','southwest');
grid on

for i=1:length(k_vec)
    
    legend_str = ['$k = ' num2str(k_vec(i),3) '$'];
              
    figure(1)
    LS(i) = plot([ft(:,i); -ft(:,i)] , [taun(:,i); -taun(:,i)], '-*', 'Color', colors_cell{i} , 'DisplayName', legend_str);
    
end

figure(1)
hold off