close all;
clear all;
clc;

A = [1.173
    1.070
    1.069
    1.008
    0.997
    0.992
    1.088
    1.091
    1.152
    1.134
    1.093
    1.076
    1.096
    1.055
    1.040
    1.057
    1.080
    1.007
    0.992
    0.998
    1.073
    1.058
    1.055
    1.118
    1.075
    1.100
    0.970
    1.013
    1.041
    0.984
    1.025
    1.002
    1.022
    1.025
    1.043
    1.052
    1.095
    1.047
    1.032
    1.007
    1.043];

deriv_norm = create_dudw('pics/triangle.bmp', 1000, 6);
A = A(end-35:end-1);
w1 = linspace(0,2*pi,length(deriv_norm));
w2 = linspace(0,2*pi,length(A));
plot(w2,A);
hold on;
plot(w1,deriv_norm);