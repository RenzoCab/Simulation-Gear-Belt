close all;
clear all;
clc;

% Run first close_loop.m with the same pulley and model_3D.

num_iter = 10;
pulley   = 'triangle';
model_3D = 'circle';
% dir_L    = [pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs/iterations/From_',pulley,'_to_',model_3D];
dir_L    = [pwd '/runs/figs/iterations/From_',pulley,'_to_',model_3D];

[~, ~, ~, model_3d] = convex_hull_set([dir_L,'/initial_model_3D.bmp']);
iterations = {};

for i = 1:num_iter
    
    [~, ~, ~, iterations{end+1}] = convex_hull_set([dir_L,'/iteration_',num2str(i),'.bmp']);
    
end

if sum(sum(iterations{end}-model_3d)) == 0
    disp('We converged to the 3D model!');
else
    disp('We did NOT converge to the 3D model!');
end

%% Convergence w.r.t. 3D model:

final_val_1 = model_3d;

for i = 1:num_iter
    conv_1(i) = diff_image(final_val_1,iterations{i});
end
    
%% Convergence w.r.t. final iteration:

final_val_2 = iterations{end};

for i = 1:num_iter
    conv_2(i) = diff_image(final_val_2,iterations{i});
end

%% Plotting 1:

h = figure('Position', [1000 1000 800 400]);
plot(conv_1,'LineWidth',3);
grid minor;
xlabel('Iterations');
ylabel('Relative difference');
title('Convergence w.r.t. reference');
xlim([1 num_iter]);
saveas(gcf,[dir_L,'/convergence_3d_model'],'epsc');

h = figure('Position', [1000 1000 800 400]);
plot(conv_2,'LineWidth',3);
grid minor;
xlabel('Iterations');
ylabel('Relative difference');
title('Convergence w.r.t. final output');
xlim([1 num_iter]);
saveas(gcf,[dir_L,'/convergence_final_model'],'epsc');

%% Plotting 2:

h = figure;
plot(conv_1,'LineWidth',3);
hold on;
plot(conv_2,'LineWidth',3);
grid minor;
xlabel('Iterations');
ylabel('Relative difference');
title('Output $C$ convergence','interpreter','Latex');
xlim([1 num_iter]);
legend('With respect to reference $B$','With respect to final output $C_{10}$','interpreter','Latex','location','best');
saveas(gcf,[dir_L,'/convergence_3d_model_2'],'epsc');