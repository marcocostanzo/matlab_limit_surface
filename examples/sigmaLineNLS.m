% Compute and plot the normalized Limit Surface (LS)
% plot also the constant sigma lines and the relation sigma->c_tilde

clear all
clc

%Add path to lib
addpath('../LS_lib/')

%% Params

% build the vector c_tilde
c_tilde = [linspace(0, 4, 100) 1e10 ];
c_tilde = [ -fliplr(c_tilde) c_tilde];

% k to plot
k = 4;
% color
color = 'k';

gamma = 0.2569;

%integration points to use
int_points = 6000;

%print status on the command window
print_delay = 10;

%% Calc

%Compute the Normalized LS for each k
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
% Plot the NLS, plot also the negative definition to build the full curve 
LS = plot([ft_norm; -ft_norm] , [tau_norm; -tau_norm], '-*', 'Color', color);

%for each point of the LS plot the const sigma line
for i=1:length(c_tilde)
   %Build the x-axis of the curve
   xx = -abs(ft_norm(i)):0.001:abs(ft_norm(i));
   if ~isempty(xx)
    %plot the curve
    sigma_line(i) = plot( xx, constSigmaLine(xx, 'sigma', sigma(i), 'gamma', gamma)  ); 
   end
end
    
figure(2)
% Plot the relation sigma->c_tilde
c_tilde_midel = plot(sigma, c_tilde, '-*', 'Color', color);
    

figure(1)
legend off
hold off

figure(2)
legend off
xaxis([-10,10])
hold off