% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% August 2021; Last revision: 23/08/2021

function [deriv_norm] = create_dudw(figure_name, Nw, dudw_norm)

    [set_x, set_y, len, ~] = convex_hull_set(figure_name);

    box_dim = 10; % mm
    normf   = floor(len/2);
    set_x   = set_x / normf;
    set_y   = set_y / normf;

    % Structure dimensions:

    r     = 480; % mm
    d     = 16; % mm
    r3    = sqrt(r^2+(d/2)^2); % mm
    alpha = atan((d/2)/r); % rad

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

    for i = 1:length(w)

        stage = 0;
        for j = 1:length(acum_D_w)
            if w(i) <= acum_D_w(j)
                stage = stage + 1;
            end
        end
        stage = length(acum_D_w) + 1 - stage;

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

        triangle = gear.tri(tr_use);
        m        = triangle.m + dm;
        r1       = triangle.r1;

        deriv(i)         = dudw(r1,r3,m);
        deriv_norm(i)    = deriv(i)/dudw_norm;

    end
    
end