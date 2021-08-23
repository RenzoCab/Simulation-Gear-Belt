% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% August 2021; Last revision: 23/08/2021

function [diff] = diff_image(img1,img2)

    diff = abs(img1-img2);
    diff = sum(sum(diff));
    diff = diff/sum(sum(img1));
    
end