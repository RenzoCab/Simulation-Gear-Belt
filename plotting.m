%% Delta H for tri-tri:

close all
clear all
clc

% dir_L = [pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs'];
dir_L    = [pwd '/runs/figs'];

r0 = 11.4;
r  = 6;
ri = linspace(0,20,1000);

difference = @(ri) r0*ri - 2*r*ri*pi + r0*sqrt(3*r0^2+ri.^2);

plot(ri,difference(ri),'LineWidth',3);
hold on;
plot(ri,zeros(1,length(ri)),'LineWidth',3);

fix_point = r0^2*sqrt(3)/(2*sqrt(r*pi*(r*pi-r0)));
disp(fix_point);

plot(fix_point,0,'o','LineWidth',10);
grid minor;

saveas(gcf,[dir_L,'/tri_tri'],'epsc');

%% Fixed point:

close all
clear all
clc

% dir_L = [pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs'];
dir_L    = [pwd '/runs/figs'];

r = 6;

alpha = linspace(0,20,1000);

roots = @(a) a.^2*(-2) + a*(-32*r) + 36*r^2 - 12*r;

evaluation = roots(alpha);

index = abs(evaluation)==min(abs(evaluation));
disp(alpha(abs(evaluation)==min(abs(evaluation))));

plot(alpha,evaluation,'LineWidth',3);
hold on;
text(alpha(index),evaluation(index),...
    ['(' num2str(alpha(index)) ',' num2str(evaluation(index)) ')'])
grid minor;

saveas(gcf,[dir_L,'/ell_cir_FP'],'epsc');

%% Delta H for whatever-cir:

close all
clear all
clc

% dir_L = [pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs'];
dir_L    = [pwd '/runs/figs'];

r = 6;

Hi = linspace(0,20,1000);

delta = @(Hi) (1/2)*(3*(Hi+2*r)-sqrt((3*Hi+2*r).*(Hi+6*r))) - Hi;

plot(Hi,delta(Hi),'LineWidth',3);
hold on;
plot(Hi,zeros(1,length(Hi)),'LineWidth',3);
grid minor;

saveas(gcf,[dir_L,'/ell_cir_AP'],'epsc');

%% Tri-tri base plots:

close all
clear all
clc

% dir_L = [pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs'];
dir_L    = [pwd '/runs/figs'];

b     = 11.45;
r     = 6;

bip1 = @(p_i) b*p_i/(2*r*pi);
p_i  = @(b_i) b_i + 2*sqrt((b_i/2)^2+(sqrt(3)*b/2)^2);

base = b;

for i = 1:5
    
    perimeter   = p_i(base(end));
    base(end+1) = bip1(perimeter);
    
end

real = [11.45 10.64 10.22 9.94 9.79 9.74] / 11.45;
simu = [1138 999 934 909 896 890] / 1138;
math = base / b;

h2 = figure;
plot(real,'*-','LineWidth',2);
hold on;
plot(simu,'*-','LineWidth',2);
plot(math,'*-','LineWidth',2);
xlabel('Iterations');
ylabel('Normalized base');
title('Triangle''s base over iterations');
legend('Experimental','Simulation','Mathematical')
grid minor;
% supersizeme(h2, 2);
saveas(gcf,[dir_L,'/convergences'],'epsc');

%% Nice dudw plots:

close all;
clear all;
clc;

dim_fig = 800;

name_fig = 'circle';
deriv_norm_cir = create_dudw(['pics/',name_fig,'.bmp'], 1000, 6);
name_fig = 'square';
deriv_norm_squ = create_dudw(['pics/',name_fig,'.bmp'], 1000, 6);
name_fig = 'triangle';
deriv_norm_tri = create_dudw(['pics/',name_fig,'.bmp'], 1000, 6);
name_fig = 'heart';
deriv_norm_hea = create_dudw(['pics/',name_fig,'.bmp'], 1000, 6);


% dir_L = [pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs'];
dir_L    = [pwd '/runs/figs'];

h2 = figure('Position', [1000 1000 dim_fig dim_fig]);
plot(linspace(0,2*pi,1000),deriv_norm_tri, 'LineWidth', 2);
hold on;
plot(linspace(0,2*pi,1000),deriv_norm_cir, 'LineWidth', 2);
plot(linspace(0,2*pi,1000),deriv_norm_squ, 'LineWidth', 2);
plot(linspace(0,2*pi,1000),deriv_norm_hea, 'LineWidth', 2);
grid minor;
xlim([0 2*pi]);
xlabel('Radians');
title('Normalized analytic derivative du/dw');
legend('Triangle','Circle','Square','Heart');
% supersizeme(h2, 2.5);
saveas(gcf,[dir_L,'/derivatives'],'epsc');

%% Iteration test:

close all
clear all
clc

hc = 12;
wc = 12;
r = 6;

w = 15;

for i = 1:100
    
    w(end+1) = wc / (2*r) * (3*(w(end)/2+hc/2) - sqrt((3*w(end)/2+hc/2)*(w(end)/2+3*hc/2)));
    
end