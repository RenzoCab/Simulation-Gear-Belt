% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% August 2021; Last revision: 23/08/2021

function output = printer(input,w0,dudw,ratio_pd)
    
    length_step = 200;

    % ratio_pd tells you how many pixels from the matrix the printer
    % believes it covers per step. E.g., if in 200 steps the belt moves 1
    % cm, and the matrix has 2 cm and 2000 pixels, then ratio_pd = 5.
        
    for i = 0:length_step-1 % Recall: Stepper motor with 200 DW.
        divs           = length(dudw)/length_step;
        step_mean(i+1) = mean(dudw(1+divs*i:divs+divs*i));
    end
    step_mean = circshift(step_mean,w0);

    side        = length(input(1,:));
    num_squares = side / ratio_pd;
    output      = [];
    
    % Each subsquare has dimension ratio_pd * ratio_pd.
    center = floor(num_squares/2);
    
    for i = 0:num_squares-1
        
        sub_rectangle = input(:,1+i*ratio_pd:(1+i)*ratio_pd);
        output_aux    = [];
        
        for j = 1:side
            
            row          = double(sub_rectangle(j,:));
            row_dom      = linspace(0,1,ratio_pd);
            tran_row_dom = linspace(0,1,round(ratio_pd*step_mean(1)));
            tran_row     = interp1(row_dom,row,tran_row_dom,'nearest');

            output_aux(j,:) = tran_row;
            
        end
        
        output = [output,output_aux];
        
        if i == center
            center_pixel = length(output(1,:)) - floor(length(output_aux(1,:))/2);
        end
        
        step_mean = circshift(step_mean,1);
        
    end
    
    if center_pixel < 1000
        output = [zeros(side,1000-center_pixel),output];
    elseif center_pixel > 1000
        output = output(:,center_pixel-1000:end);
    end
    
    if length(output(1,:)) < 2000
        output = [output,zeros(side,2000-length(output(1,:)))];
    elseif length(output(1,:)) > 2000
        output = output(:,1:2000);
    end
    
    output = int8(output);
    
return