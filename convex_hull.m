close all;
clear all;
clc;

dim_fig  = 600;
size_fig = 3;
save_var = true;
name_fig = 'circle';
% name_fig = 'square';
% name_fig = 'triangle';
% name_fig = 'heart';
fig      = ['pics/',name_fig,'.bmp'];
I = imread(fig);
I = (I == false);
I = int8(I);

I_len  = length(I(:,1));
I_half = floor(I_len/2);

if length(I(:,1)) ~= length(I(1,:))
	error(['Image ',picname,' is not square!']);
end

xp = [];
yp = [];

boundaries = bwboundaries(I);
x          = boundaries{1}(:,2);
y          = boundaries{1}(:,1);
indexes    = convhull(x, y, 'Simplify', true);

h = figure('Position', [1000 1000 dim_fig dim_fig]);
xlim([-I_half I_half]);
ylim([-I_half I_half]);
pbaspect([1 1 1]);
supersizeme(h, size_fig);
hold on;

for i = 1:I_len
    for j = 1:I_len
        if I(i,j) == 1
            xp(end+1) = j-I_half;
            yp(end+1) = I_half-i;
        end
    end
end

plot(xp,yp,'.'); grid minor;
title(['Figure: ',name_fig]);
box on;
if save_var
    saveas(gcf,[pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs/matrix_',name_fig],'epsc');
    % exportgraphics(gcf,[pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs/matrix_',name_fig,'.eps']); 
end

plot(x(indexes)-I_half, I_half-y(indexes), '*-', 'LineWidth', 2);
if save_var
    saveas(gcf,[pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs/ch_',name_fig],'epsc');
end

plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','blue');

for i = 1:length(indexes)
    
    plot([0 x(indexes(i))-I_half], [0 I_half-y(indexes(i))], 'LineWidth', 1, 'Color', 'r');
    
end
plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','blue');
plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','red');

if save_var
    saveas(gcf,[pwd '/../../../Aplicaciones/Overleaf/2021_Self_Replicating_Pulley_Report/figs/all_',name_fig],'epsc');
end