%close all
clear all

addpath('LS_lib/')

Fn = 100;

c_tilde = [0:.1:1.4, 1.5:.5:5 1e10 ];

k = 1e10;
mu = 1.0;
gamma_ = 1/3;
beta_ = 0.00349;

int_points = 6000;

[ ft , m, ft_max, m_max ] = calculateLimitSurface(  Fn,...
                                                    'c_tilde',...
                                                    c_tilde ,...
                                                    k,...
                                                    mu,...
                                                    gamma_,...
                                                    'beta',...
                                                    beta_,...
                                                    int_points,...
                                                    10 ...
                                                  );
ft = abs(ft);
m = abs(m);
                                              
figure(1)
hold on
title('Limit Surface')
plot(ft,m,'-*', 'DisplayName', ['$\gamma = ' num2str(gamma_,3) '\, k = ' num2str(k,3) '$'])
leg = legend('show');
set(leg, 'Interpreter' ,'latex');
grid on
hold off

figure(2)
hold on
title('Norm LS')
plot(ft/ft_max , m/m_max, '-*', 'DisplayName', ['$\gamma = ' num2str(gamma_,3) '\, k = ' num2str(k,3) '$'])
leg = legend('show');
set(leg, 'Interpreter' ,'latex');   
grid on
hold off
