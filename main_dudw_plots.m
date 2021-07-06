close all;
clear all;
clc;

figure_name = 'triangle';
figure_name = 'heart';
figure_name = 'circleShifted';
figure_name = 'square';
figure_name = 'Ideal_pully';
figure_name = 'line';


[set_x, set_y, len, I] = convex_hull_set(['pics/',figure_name,'.bmp']);

Nw      = 1000; % Please be sure floor(Nw/200) = 0.
box_dim = 10; % mm
normf   = floor(len/2);
set_x   = set_x / normf;
set_y   = set_y / normf;

set_x_t1_ini = set_x(1:2) * box_dim;
set_y_t1_ini = set_y(1:2) * box_dim;

dudw_norm = 6; % mm
% The previous value corresponds to dudw for the standard circular pulley.

%% Figure 1 to help visualization:

h = figure(1);
plot(set_x,set_y,'LineWidth',3);
hold on;
grid minor;
xlim([-1 1]);
ylim([-1 1]);
box on;
pbaspect([1 1 1]);
for i = 1:length(set_x)
    plot([0 set_x(i)], [0 set_y(i)], 'b', 'LineWidth', 2);
end
plot([0;set_x(1:2);0],[0;set_y(1:2);0],'LineWidth',3);
plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','red');
circle(0,0,dudw_norm/box_dim,2);
for i = 1:length(set_x)-1
    plot(set_x(i),set_y(i),'o','MarkerSize',i+3,'MarkerFaceColor','red');
end
supersizeme(h, 1.5);

% Structure dimensions:

r     = 480; % mm
d     = 16; % mm
fix_p = [-r,d/2];
r3    = sqrt(r^2+(d/2)^2); % mm
alpha = atan((d/2)/r); % rad
beta  = pi/2 - alpha; % rad

%% Gear dimensions:

set_x = box_dim * set_x;
set_y = box_dim * set_y;

for i = 1:length(set_x)-1
    
    point1  = [set_x(i),set_y(i)]; % Position (x,y) of P1.
    point2  = [set_x(i+1),set_y(i+1)]; % Position (x,y) of P2.
    r1      = norm(point1);
    [ang,~] = cart2pol(set_x(i), set_y(i)); % Angle of r1.
    r2      = norm(point2);
    a       = norm(point1-point2); % Value of "a" normalized.
    gamma   = acos((r1^2+r2^2-a^2)/(2*r1*r2)); % rad
    psi     = acos((r1^2+a^2-r2^2)/(2*r1*a)); % rad
    omega   = pi - psi - gamma;
    
    if i == 1
        [angle_ini_t1_r2,~] = cart2pol(set_x(i+1),set_y(i+1));
    end
    
    gear.tri(i).point1 = point1;
    gear.tri(i).r1     = r1;
    gear.tri(i).point2 = point2;
    gear.tri(i).r2     = r2;
    gear.tri(i).a      = a;
    gear.tri(i).gamma  = gamma;
    gear.tri(i).psi    = psi;
    gear.tri(i).omega  = omega;
    gear.tri(i).ang    = ang;
    
end

%% Gear - System initial interaction:

% figure;
% hold on;

for i = 1:length(set_x)-1
    
    r1  = gear.tri(i).r1;
    psi = gear.tri(i).psi;

    n = asin((r1/r3)*sin(pi-psi)); % Sin Theorem.
    m = pi - (pi-psi) - n;
    b = r1 * sin(m) / sin(n);
    
    gear.tri(i).n = n;
    gear.tri(i).m = m;
    gear.tri(i).b = b;
    
    if i == 2
        angle_start_t2_r1 = pi - alpha - m;
    end
    
% Testing:
%     r2                = gear.tri(i).r2;
%     gamma             = gear.tri(i).gamma;
%     [x_try_1,y_try_1] = pol2cart(pi-alpha-m,r1);
%     [x_try_2,y_try_2] = pol2cart(pi-alpha-m-gamma,r2);
%     set_x_t           = [0; x_try_1; x_try_2; 0];
%     set_y_t           = [0; y_try_1; y_try_2; 0];
%     plot(set_x_t,set_y_t);
    
end

if angle_start_t2_r1 >= angle_ini_t1_r2
    initial_w = 2*pi - (angle_start_t2_r1 - angle_ini_t1_r2);
else
    initial_w = - (angle_start_t2_r1 - angle_ini_t1_r2);
end

%% Gear - System dynamics:

dudw = @(r1,r3,m) (1/2) * (2*r1*r3*sin(m)) ./ sqrt(r1^2+r3^2-r1*r3*cos(m));

% Now, we save all "displacements" of the kind Dw = gamma_1 + m_1 - m_2.
% Remmeber the order is 2 > 1 > end > end-1 > end-2 > ...

for i = 1:length(set_x)-1
    
    m1      = gear.tri(i).m;
    gamma_1 = gear.tri(i).gamma;
    
    if i == length(set_x)-1
        m2 = gear.tri(1).m;
    else
        m2 = gear.tri(i+1).m;
    end
    
    D_w(i) = m1 + gamma_1 - m2;
    
    % When i = 1, we have triangles 1 and 2, and we move from triangle 2 to
    % triangle 1. Then, we will start the du/dw plot from triangle 2.
    
end

D_w = [D_w(1) flip(D_w(2:end))];

% Note: There is a very complex notation problem. When I enumerate the 
% triangles, I did it clockwise. However, when they rotate (assuming 6
% triangles), we move like this: 1 -> 6, 6 -> 5, etc.

% Since we always start from triangle 2, we move: 2, 1, end, end-1, ...

acum_D_w = cumsum(D_w) + initial_w;
w        = linspace(initial_w,2*pi+initial_w,Nw);
deriv    = zeros(1,length(w));

figure(2);
hold on;
xlim([-10 10]);
ylim([-10 10]);
pbaspect([1 1 1]);
box on;
grid minor;

for i = 1:length(w)
    
    stage = 0;
    for j = 1:length(acum_D_w)
        if w(i) <= acum_D_w(j)
            stage = stage + 1;
        end
    end
    stage = length(acum_D_w) + 1 - stage;
    disp(stage);
    
    % Remmeber j = 1 means triangle 2, j = 2 means triangle 1.
    % The next coding represents this transformation:
    if stage == 1
        tr_use = 2;
        dm     = w(i)-initial_w;
    elseif stage == 2
        tr_use = 1;
        dm     = w(i) - acum_D_w(stage-1);
    else
        tr_use = length(acum_D_w) - stage + 3;
        dm     = w(i) - acum_D_w(stage-1);
    end
    disp(tr_use);
    
    triangle = gear.tri(tr_use);
    m        = triangle.m + dm;
    r1       = triangle.r1;
    rotation = [cos(w(i)) -sin(w(i)); sin(w(i)) cos(w(i))];
    xy_rot   = [set_x, set_y] * rotation;
    set_t1   = [set_x_t1_ini, set_y_t1_ini] * rotation;
    set_x_t1 = [0; set_t1(:,1); 0];
    set_y_t1 = [0; set_t1(:,2); 0];
    pause(0.01);
    
    try
        delete(plot_pulley);
        delete(plot_line);
        delete(plot_t1);
    end
    
    [r1_x,r1_y] = pol2cart(pi-alpha-m,r1);
    plot(r1_x,r1_y,'o','MarkerSize',2,'MarkerFaceColor','red');
    plot_pulley = plot(xy_rot(:,1),xy_rot(:,2),'LineWidth',3);
    plot_line   = plot([fix_p(1) r1_x],[fix_p(2) r1_y],'LineWidth',2);
    plot_t1     = plot(set_x_t1,set_y_t1,'LineWidth',3);
    
    deriv_fd(i)      = norm(fix_p-[r1_x,r1_y]) / (w(2)-w(1));
    deriv(i)         = dudw(r1,r3,m);
    deriv_fd_norm(i) = deriv_fd(i)/dudw_norm;
    deriv_norm(i)    = deriv(i)/dudw_norm;
    
    % For debugging:
    save_m(i)     = m;
    save_stage(i) = stage;
    save_tri(i) = tr_use;
    
end

deriv_fd_norm = deriv_fd_norm(2:end) - deriv_fd_norm(1:end-1);

for i = 0:199
    
    divs           = Nw/200;
    step_mean(i+1) = mean(deriv(1+divs*i:divs+divs*i))/dudw_norm;
    
end

% h = figure;
% plot(deriv, 'LineWidth', 2); grid minor;
% title('deriv');
% supersizeme(h, 1.5);

h1 = figure(3);
plot(linspace(0,2*pi,200), step_mean, 'LineWidth', 2); grid minor;
hold on;
plot(linspace(0,2*pi,200),mean(step_mean)*ones(1,length(step_mean)), 'LineWidth', 2);
title('Finite-Differences norm. derivative du/dw');
xlabel('Radians');
xlim([0 2*pi]);
supersizeme(h1, 1.5);

h2 = figure(4);
plot(w-initial_w,deriv_norm, 'LineWidth', 2);
hold on;
% plot(w(1:end-1),deriv_fd_norm, 'LineWidth', 2);
plot(w-initial_w,mean(deriv/dudw_norm)*ones(1,length(deriv)), 'LineWidth', 2);
grid minor;
xlim([min(w-initial_w) max(w-initial_w)]);
xlabel('Radians');
title('Normalized analytic derivative du/dw');
supersizeme(h2, 1.5);

% figure;
% plot(save_m, 'LineWidth', 2); grid minor;
% title('save m');
% figure;
% plot(save_stage, 'LineWidth', 2); grid minor;
% title('save stage');
% figure;
% plot(save_tri, 'LineWidth', 2); grid minor;
% title('save tri');

% save('dudw.mat','deriv_norm');
% 
% if 0 == exist([pwd '/Plots/',figure_name],'dir')
% 	mkdir([pwd '/Plots/',figure_name]);
% end
% 
% for i = 1:4
%     set(0,'CurrentFigure',i);
%     saveas(gcf,[pwd '/Plots/',figure_name,'/',num2str(i)],'epsc');
% end

if 0 == exist([pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs/dudw/',figure_name],'dir')
	mkdir([pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs/dudw/',figure_name]);
end

for i = 1:4
    set(0,'CurrentFigure',i);
    saveas(gcf,[pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs/dudw/',figure_name,'/',num2str(i)],'epsc');
end