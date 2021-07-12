function [diff] = diff_image(img1,img2)

    diff = abs(img1-img2);
    diff = sum(sum(diff));
    diff = diff/sum(sum(img1));
    
end