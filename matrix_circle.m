function [matrix] = matrix_circle(radius, matrix_dim)

    matrix = zeros(matrix_dim);
    
    for i = 1:matrix_dim
        for j = 1:matrix_dim
            
            valx = i/matrix_dim;
            valy = j/matrix_dim;
            
            if norm([valx-1/2 valy-1/2]) < radius/2
                matrix(i,j) = 1;
            end
            
        end
    end
    
end