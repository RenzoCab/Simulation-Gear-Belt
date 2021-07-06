close all;
clear all;
clc;

var = 1;
disc = 1000;

btf_r = 6.0; % Original pulley radius.
l     = 8*2; 
r     = 480;
r1    = 6.6;
r2    = 6.6;
gamma = deg2rad(30);

gamma_comp = deg2rad(180-rad2deg(gamma));
r3         = sqrt((l/2)^2+r^2);
n          = asin(r1*sin(gamma_comp)/r3);
m          = pi - n - gamma_comp;
b          = sin(pi-n-gamma_comp) * r3 / sin(gamma_comp);
delta_b    = @(dw) -b + sqrt(r3^2+r1^2-2*r3*r1*cos(m+dw));
dbdw       = @(m) (1/2) * (2*r1*r3*sin(m)) ./ sqrt(r1^2+r3^2-r1*r3*cos(m));

dw     = linspace(0,2*pi/3,disc); % Notice the 2*pi/3.
dw_com = linspace(0,2*pi,disc);
dw_x   = dw;

if 1 == var
    
    dw = [dw dw dw];
    dw_x = linspace(0,2*pi,disc*3);
    
end

tri          = delta_b(dw);
cir          = btf_r * dw;
der_tri      = dbdw(dw_com);
der_tri_norm = der_tri/btf_r; % We normalize tri_dbdw w.r.t. cir_dbdw.

if 1 == var
    
    tri(disc+1:disc*2) = tri(disc+1:disc*2) + tri (disc) + tri(2);
    tri(disc*2+1:disc*3) = tri(disc*2+1:disc*3) + tri (disc*2) + tri(2);
    cir(disc+1:disc*2) = cir(disc+1:disc*2) + cir (disc) + cir(2);
    cir(disc*2+1:disc*3) = cir(disc*2+1:disc*3) + cir (disc*2) + cir(2);
    
end

% This plot is the position of the belt for the circle and triangle.
figure(1);
plot(dw_x,tri);
hold on;
plot(dw_x,cir);
grid minor;
xlabel('Pulley position (rad)');
ylabel('Belt position (mm)');
xlim([min(dw_x) max(dw_x)]);

% Variation in the belt w.r.t. the angle of rotation:
var_tri = diff(tri)./diff(dw_x);
var_cir = diff(cir)./diff(dw_x);
figure(5);
plot(dw_x(1:end-1),var_tri);
hold on;
plot(dw_x(1:end-1),var_cir);
grid minor;
xlabel('Pulley position (rad)');
% ylabel('Belt position (mm)');
xlim([min(dw_x) max(dw_x(end-1))]);

figure(2);
plot(dw_x,cir-tri);
grid minor;
xlabel('Pulley position (rad)');
ylabel('Belt position (mm)');
xlim([min(dw_x) max(dw_x)]);

% Steps:
cir_step = cir(2:end) - cir(1:end-1);
tri_step = tri(2:end) - tri(1:end-1);
rel_step = tri_step./cir_step;

figure(3);
plot(dw_x(1:end-1),rel_step,'LineWidth',2);
hold on;
plot(dw_x(1:end-1),(rel_step+circshift(rel_step,floor(length(rel_step)/6)))/2,...
    'LineWidth',2);
grid minor;
xlabel('Pulley position (rad)');
xlim([min(dw_x) max(dw_x)]);

%% Real Data:

data = [0.843572186
0.920523935
0.976906214
0.997305884
0.959941421
0.921083963
0.890932743
0.89190186
0.867806285
0.857422021
0.838110706
0.87314973
0.884845991
0.912284606
0.905811135
0.928235013
0.943029974
0.970943331
0.977757972
0.972733774
0.954302541
0.945698365
0.941596246
0.937905395
0.921374052
0.908975989
0.892675976
0.878997327
0.858951582
0.847739992
0.854516258
0.870882871
0.897066524
0.895263723
0.897451315
0.882096701
0.898905238
0.904143211
0.921216049
0.918377326
0.923369801
0.935563074
0.95751891
0.980297337
0.988001042
0.989431411
0.9763438
0.960935648
0.937124053
0.915150661
0.886553748
0.860052661
0.84855805
0.86052758
0.88158085
0.900276932
0.907093157
0.921235566
0.925239764
0.930859897
0.935120976
0.957471453
0.994647118
1.007897991
0.991915639
0.943883805
0.928166717
0.955135109
1.013964261
1.055193604
1.069023492
1.064215585];

data_2 = [0.777777778
0.563380282
0.862068966
0.928571429
0.636363636
1.229166667
1.130434783
0.912280702
0.786885246
0.967213115
0.803030303
1.054545455
0.714285714
0.913793103
0.515151515
1.418604651
0.633333333
0.877192982
0.98245614
1.016949153
0.8
1.101694915
1.078431373
0.84375
0.852459016
1.06779661
0.966101695
0.862068966
0.841269841
1.056603774
0.772727273
0.857142857
0.898305085
0.76056338
0.872727273
0.901639344
1.072727273
0.661290323
1.072727273
0.68852459
1.086206897
0.830188679
0.95
0.966666667
0.805970149
1
1.051724138
0.983050847
0.907692308
1.1
0.93220339
0.910714286
0.888888889
0.982758621
0.844827586
0.694915254
0.90625
0.945454545
0.866666667
0.931034483
0.824324324
1.095238095
0.8
1
0.909090909
0.830508475
1.392156863
0.833333333
0.93442623
0.954545455
0.724637681
1.035714286
1.425
0.863013699
0.842105263
1.468085106
0.983870968
0.590163934];

data_3 = [0.91
0.94
0.88
0.95
0.97
1.03
0.99
0.98
0.94
0.94
0.96
0.93
0.93
0.88
0.90
0.93
0.95
0.97
0.94
0.96
0.89
0.88
0.92
0.93];

data_cleaned = data(3:64);
data_cleaned = circshift(data_cleaned,-9);
data_2_cleaned = data_2(6:72);
% data_2_cleaned = circshift(data_2_cleaned,-15);

%% Plotting:

close all;

data_cleaned = interp1(linspace(0,2*pi,length(data_cleaned)),data_cleaned,dw_x);
data_2_cleaned = interp1(linspace(0,2*pi,length(data_2_cleaned)),data_2_cleaned,dw_x);
data_3_cleaned = interp1(linspace(0,2*pi*(2/3),length(data_3)),data_3,dw_x(1:2000));

h = figure(4);
plot(dw_x(1:end-1),rel_step,'LineWidth',2);
hold on;
plot(dw_x(1:end-1),data_cleaned(1:end-1),'LineWidth',2);
plot(dw_x(1:2000),data_3_cleaned,'LineWidth',2);

for i = 0:67
    
    rel_step_mean(1+i*44:68+i*44) = mean(rel_step(1+i*44:44+i*44));
    aux(i+1) = mean(rel_step(1+i*44:44+i*44));
    
end

for i = 3:length(aux)-2
    
    rel_step_mean_5(1+i*44:68+i*44) = mean(aux(i-2:i+2));
    
end

grid minor;
xlabel('Pulley position (rad)');
ylabel('Relative Derivative');
xlim([min(dw_x) max(dw_x)]);
legend({'Theoretical Value', 'Experiment 1 Measurements','Experiment 2 Measurements'},...
    'Location','southeast');
title('Relative Belt Displacement w.r.t. Motor Step');
supersizeme(h, 1.5);

return;

figure(6);
plot(dw_com,der_tri);
xline(30*2*pi/360);
xline(150*2*pi/360);
grid minor;
xlabel('Pulley position (rad)');

figure(7);
plot(dw_com,der_tri_norm);
xline(30*2*pi/360);
xline(150*2*pi/360);
grid minor;
xlabel('Pulley position (rad)');