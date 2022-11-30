close all

subplot(1,3,1)
%table
ground()
 hold on
 th =  20 %  tilt of the rod
 C=[1 1];
 rod(C, th)
 box on
 xlim([-5 5]);
 ylim([-0 15]);
 
 axis off
 axis equal

 subplot(1,3,2)
 %table
 ground()
 hold on
 th =  20 %  tilt of the rod
 C=[0 0];
 rod(C, th);
 
 box on
 xlim([-5 5]);
 ylim([-0 15]);
 
 axis off
 axis equal
 
 
 subplot(1,3,3)
 %table
 ground()
 hold on
 th =  20 %  tilt of the rod
 C=[0 0];
 rod(C, th)
 box on
 xlim([-5 5]);
 ylim([-0 15]);
 
 axis off
 axis equal
 
 

function [shape] = circle(center)
t = 0.05:0.5:2*pi;
rad=.5;

x1 = rad*cos(t);
y1 = rad*sin(t);
x2 = 0.05*cos(t);
y2 = 0.05*sin(t);
pgon = polyshape({x1,x2},{y1,y2});
shape = translate(pgon, center);

end

function spiral(center,th)
n=16;
t=0:pi/20:n*pi;
r=t.^2;
x=r.*cos(t)/(10*n^2);
y=r.*sin(t)/(10*n^2);
pg=plot(x+center(1),y+center(2),'color','k','linewidth',.5);
end



function table
h=0.5;
W=5;
pos = [ -W 0;
        -W -h;
        -h -h;
        -h -(W/2);
         h -(W/2);
         h -h;
         W  -h;
         W  0;];
    x=pos(:,1);    y=pos(:,2);

pgon = polyshape(x,y);
pg=plot(pgon);
pg.FaceColor = [0.5 0.5 0.5];
pg.LineWidth=.1;

end

function rod(C, th)
L=5 ;% length of the rod;

 P=[L *sind(th)+C(1)  L*cosd(th)+C(2)];
L1= line([C(1) P(1)],[C(2) P(2)],'color','k','linewidth',2.5) ;
shape =circle(P);
pg=plot (shape);
pg.FaceColor = [0.5 0.5 0.5];
pg.LineWidth=.1;


spiral((P+C)/2,th);

end


function ground()

W=5;
L1= line([-W W],[0 0],'color','k','linewidth',2.5) ;

end