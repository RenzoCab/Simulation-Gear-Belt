% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% August 2021; Last revision: 23/08/2021

function [set_x, set_y, len, I] = convex_hull_set(picname)

    I = imread(picname);
    I = (I == false);
    I = int8(I);
    
    if length(I(:,1)) ~= length(I(1,:))
        error(['Image ',picname,' is not square!']);
    end

    boundaries = bwboundaries(I);
    x          = boundaries{1}(:,2);
    y          = boundaries{1}(:,1);
    indexes    = convhull(x, y, 'Simplify', true);

    set_x = x(indexes)-floor(length(I(:,1))/2);
    set_y = floor(length(I(:,1))/2)-y(indexes);
    len   = length(I(:,1));
    
end