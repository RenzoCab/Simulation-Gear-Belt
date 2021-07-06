function [diff] = diff_image(img1,img2)

    diff = abs(img1-img2);
    diff = sum(sum(diff));
%     diff = diff/(length(img1(1,:))^2);
    diff = diff/sum(sum(img1));
    
end