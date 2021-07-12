close all;
clear all;
clc;

pulley   = 'triangle';
model_3D = 'circle';

dir_L = ['/runs/figs/iterations/From_',pulley,'_to_',model_3D];

substitution = false;

if 0 == exist([pwd dir_L],'dir')
	mkdir([pwd dir_L]);
end

[~, ~, ~, input] = convex_hull_set(['pics/',model_3D,'.bmp']);
% Initial 3D model.

[~, ~, ~, initial_pully] = convex_hull_set(['pics/',pulley,'.bmp']);
% Initial 3D model.

deriv_norm = create_dudw(['pics/',pulley,'.bmp'], 1000, 6);
% Initial pulley du/dw.

% We simulate the printer and create the output:
output = printer(input,0,deriv_norm,10);

spy(initial_pully);
grid minor;
saveas(gcf,[pwd dir_L,'/initial_pully'],'epsc');
saveas(gcf,[pwd dir_L,'/initial_pully'],'png');
iteration_figure_url = [pwd dir_L,'/initial_pully.bmp'];
imwrite(not(logical(initial_pully)),iteration_figure_url);

close all; pause(0.1);

spy(input);
grid minor;
saveas(gcf,[pwd dir_L,'/initial_model_3D'],'epsc');
saveas(gcf,[pwd dir_L,'/initial_model_3D'],'png');
input_figure_url = [pwd dir_L,'/initial_model_3D.bmp'];
imwrite(not(logical(input)),input_figure_url);

close all; pause(0.1);

spy(output);
grid minor;
saveas(gcf,[pwd dir_L,'/iteration_1'],'epsc');
saveas(gcf,[pwd dir_L,'/iteration_1'],'png');
output_figure_url = [pwd dir_L,'/iteration_1.bmp'];
imwrite(not(logical(output)),output_figure_url);

iteration_figure = ['pics/From_',pulley,'_to_',model_3D,'.bmp'];
imwrite(not(logical(output)),iteration_figure);

for i = 2:10
    
    if substitution == false
        [~, ~, ~, input] = convex_hull_set(['pics/',model_3D,'.bmp']);
    elseif substitution == true
        [~, ~, ~, input] = convex_hull_set(iteration_figure);
    end
    deriv_norm       = create_dudw(iteration_figure, 1000, 6);
    output           = printer(input,0,deriv_norm,10);
    
    close all; pause(0.1);
    spy(output);
    grid minor;
    saveas(gcf,[pwd dir_L,'/iteration_',num2str(i)],'epsc');
    saveas(gcf,[pwd dir_L,'/iteration_',num2str(i)],'png');
    iteration_figure_url = [pwd dir_L,'/iteration_',num2str(i),'.bmp'];
    imwrite(not(logical(output)),iteration_figure_url);
    
    imwrite(not(logical(output)),iteration_figure);
    
end