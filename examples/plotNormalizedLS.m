clear all
clc

addpath('../LS_lib/')

%% Params
c_tilde = [linspace(0, 4, 100) 1e10 ];
c_tilde = [ -fliplr(c_tilde) c_tilde];
k_vec = [2 4 1e10];
colors_cell = {'b', 'r', 'k'};

gamma = 0.2569;
int_points = 6000;
print_delay = 10;

%% Calc
[ ft_norm , tau_norm ] = calculateLimitSurfaceNorm( c_tilde,...
                                                  k_vec,...
                                                  int_points,...
                                                  print_delay ...
                                                 );
%Sigma value for each point of LS
sigma = getSigma(ft_norm, tau_norm, 'gamma', gamma);

%% Plot
figure(1)
cla
hold on
title('Normalized Limit Surface')
leg = legend('show');
set(leg, 'Interpreter' ,'latex','Location','southwest');
grid on

figure(2)
cla
hold on
title('$\tilde c$ model', 'Interpreter', 'latex')
xlabel('$\sigma$', 'Interpreter', 'latex')
ylabel('$\tilde c$', 'Interpreter', 'latex')
leg = legend('show');
set(leg, 'Interpreter' ,'latex','Location','northeast');
grid on

for i=1:length(k_vec)
    
    legend_str = ['$k = ' num2str(k_vec(i),3) '$'];
              
    figure(1)
    LS(i) = plot([ft_norm(:,i); -ft_norm(:,i)] , [tau_norm(:,i); -tau_norm(:,i)], '-*', 'Color', colors_cell{i} , 'DisplayName', legend_str);
    
    figure(2)
    c_tilde_midel(i) = plot(sigma(:,i), c_tilde, '-*', 'Color', LS(i).Color, 'DisplayName', legend_str);
    
end

figure(1)
hold off

figure(2)
xaxis([-10,10])
hold off