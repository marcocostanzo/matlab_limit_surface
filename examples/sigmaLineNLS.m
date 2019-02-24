clear all
clc

addpath('../LS_lib/')

%% Params
c_tilde = [linspace(0, 4, 100) 1e10 ];
c_tilde = [ -fliplr(c_tilde) c_tilde];
k = 4;
color = 'k';

gamma = 0.2569;
int_points = 6000;
print_delay = 10;

%% Calc
[ ft_norm , tau_norm ] = calculateLimitSurfaceNorm( c_tilde,...
                                                  k,...
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
grid on

figure(2)
cla
hold on
title('$\tilde c$ model', 'Interpreter', 'latex')
xlabel('$\sigma$', 'Interpreter', 'latex')
ylabel('$\tilde c$', 'Interpreter', 'latex')
grid on
              
figure(1)
LS = plot([ft_norm; -ft_norm] , [tau_norm; -tau_norm], '-*', 'Color', color);

for i=1:length(c_tilde)
   xx = -abs(ft_norm(i)):0.001:abs(ft_norm(i));
   if ~isempty(xx)
    sigma_line(i) = plot( xx, constSigmaLine(xx, 'sigma', sigma(i), 'gamma', gamma)  ); 
   end
end
    
figure(2)
c_tilde_midel = plot(sigma, c_tilde, '-*', 'Color', color);
    

figure(1)
hold off

figure(2)
xaxis([-10,10])
hold off