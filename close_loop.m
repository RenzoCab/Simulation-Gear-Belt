% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% August 2021; Last revision: 23/08/2021

function [] = close_loop(pulley, model_3D, num_iter, substitution)

    dir_L = ['/figs/iterations/From_',pulley,'_to_',model_3D];

    if 0 == exist([pwd dir_L],'dir')
        mkdir([pwd dir_L]);
    end

    [~, ~, ~, input] = convex_hull_set(['pulleys/',model_3D,'.bmp']);
    % Initial 3D model.

    [~, ~, ~, initial_pully] = convex_hull_set(['pulleys/',pulley,'.bmp']);
    % Initial 3D model.

    deriv_norm = create_dudw(['pulleys/',pulley,'.bmp'], 1000, 6);
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

    iteration_figure = ['pulleys/From_',pulley,'_to_',model_3D,'.bmp'];
    imwrite(not(logical(output)),iteration_figure);

    for i = 2:num_iter

        if substitution == false
            [~, ~, ~, input] = convex_hull_set(['pulleys/',model_3D,'.bmp']);
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

    convergence(pulley, model_3D, num_iter);

end