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
b_negative = true;

%% Contacts 

contacts{1}.fn = 10;
contacts{1}.CoP = [-0.03; 0.0];
contacts{1}.contact_params.mu = 0.8;
contacts{1}.contact_params.delta = 0.00349;
contacts{1}.contact_params.gamma = 1/3;
contacts{1}.contact_params.k = 4;

contacts{2} = contacts{1};
contacts{2}.CoP = [0.03; 0.0];
contacts{2}.fn = 10;

%% Build CoR
% mu = [1/2 1/2];
% sigma = [1/5 0; 0 1/5];
% R = mvnrnd(mu,sigma,30000)';
b_gauss = true;

if b_gauss
    [CoRx,CoRy] = meshgrid([-10, -0.1:0.01:0.1, 10],[-10, -0.1:0.01:0.1, 10]);
    CoRx = CoRx(:);
    CoRy = CoRy(:);
    for i=1:numel(contacts)
        sigma_gauss = 1/50 * 1/3 * getRadius( contacts{i}.fn, contacts{i}.contact_params.delta, contacts{i}.contact_params.gamma);
        if sigma_gauss == 0
            sigma_gauss = 1/50 * 1/3 * 0.005;
        end
        TMP = mvnrnd(contacts{i}.CoP,sigma_gauss*eye(2),700);
        CoRx = [CoRx; TMP(:,1)];
        CoRy = [CoRy; TMP(:,2)];
    end
else
    [CoRx,CoRy] = meshgrid([-10, -0.1:0.005:0.1, 10],[-10, -0.1:0.005:0.1, 10]);
end

%% Compute
[ ftx, fty, taun, contacts ] = LSMultiContact(CoRx, CoRy, contacts, int_points, time_disp_status, b_negative);

%% Plot

if b_gauss == true
	surf_fcn = @nonuniform_surf;
else
	surf_fcn = @uniform_surf;
end

figure
ind = 0;
axvec = [];
for i=1:numel(contacts)
	ind = ind+1;
    ax1 = subplot(numel(contacts),2,ind);
    surf_fcn( contacts{i}.LS_local.ftx, contacts{i}.LS_local.fty, contacts{i}.LS_local.taun,b_negative )
    title(['Contact ' num2str(i) ' LS Local'])

    ind = ind+1;
    ax2 = subplot(numel(contacts),2,ind);
    surf_fcn( contacts{i}.LS_global.ftx, contacts{i}.LS_global.fty, contacts{i}.LS_global.taun,b_negative )
    title(['Contact ' num2str(i) ' LS Global'])
    
    if i==1
        axvec = [ax1 ax2];
    else
        axvec = [axvec ax1 ax2];
    end
end

figure
surf_fcn( ftx, fty, taun, b_negative )
axvec = [axvec gca];
title(['Total Global LS'])

figure
hold on
for i=1:numel(contacts)
	surf_fcn( contacts{i}.LS_global.ftx, contacts{i}.LS_global.fty, contacts{i}.LS_global.taun,b_negative )
end
surf_fcn( ftx, fty, taun, b_negative, 0.5 )
axvec = [axvec gca];
title(['Global LS Combination'])

Link = linkprop(axvec,{'CameraUpVector', 'CameraPosition', 'CameraTarget'});%, 'XLim', 'YLim', 'ZLim'});
setappdata(gcf, 'StoreTheLink', Link);

function nonuniform_surf(X,Y,Z, b_negative, alpha,  b_plot_points)

    if nargin < 5
        alpha = 1;
    end
    if nargin < 6
        b_plot_points = true;
    end
    
    if b_negative
        num_row = size(X,1)/2;
        hs = ishold;
        hold on
        nonuniform_surf(X(1:num_row,:),Y(1:num_row,:),Z(1:num_row,:),false, alpha, b_plot_points);
        nonuniform_surf(X(num_row+1:end,:),Y(num_row+1:end,:),Z(num_row+1:end,:),false, alpha, b_plot_points);
        if ~hs
            hold off
        end
        return
    end

    x_tmp = linspace( min(X(:)), max(X(:)), numel(X)/10);
    y_tmp = linspace( min(Y(:)), max(Y(:)), numel(Y)/10);
    [x_interp, y_interp] = meshgrid(x_tmp,y_tmp);
    z_interp = griddata(X,Y,Z, x_interp, y_interp, 'linear');
    
    surf( x_interp, y_interp, z_interp, 'LineStyle', 'none', 'FaceAlpha', alpha )
    
    if b_plot_points
        hs = ishold;
        hold on
        plot3(X,Y,Z,'r.')
        if ~hs
            hold off
        end
    end
    
end

function uniform_surf(X,Y,Z, b_negative, alpha, b_plot_points)

    if nargin < 5
        alpha = 1;
    end
    if nargin < 6
        b_plot_points = true;
    end
    
    if b_negative
        num_row = size(X,1)/2;
        hs = ishold;
        hold on
        uniform_surf(X(1:num_row,:),Y(1:num_row,:),Z(1:num_row,:),false, alpha, b_plot_points);
        uniform_surf(X(num_row+1:end,:),Y(num_row+1:end,:),Z(num_row+1:end,:),false, alpha, b_plot_points);
        if ~hs
            hold off
        end
        return
    end
    
    surf( X, Y, Z , 'LineStyle', 'none', 'FaceAlpha', alpha )
    
    if b_plot_points
        hs = ishold;
        hold on
        plot3(X,Y,Z,'r.')
        if ~hs
            hold off
        end
    end
    
end