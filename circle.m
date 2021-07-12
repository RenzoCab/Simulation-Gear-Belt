function h = circle(x,y,rmatlab update project filesmatlab update project files,len)
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit, 'LineWidth', len);
return