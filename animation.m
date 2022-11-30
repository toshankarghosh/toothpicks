function [F]= animation(D,D1, timeRate,setup)

%This function runs an animation for the finite state machine

figH = figure(10); clf; hold on;
set(figH,'Name','Animation','NumberTitle','off')

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack D
% D.phase D.code D.data D.Jumps  D.Jumps D.JumpIdx  D.p
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%


% Parameters
P                   = D.p;
L                   = P.l;
[COLR]              = plot_color_phase(D);



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack D1
% 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Total  number of phase changes in the system 

nPhase              = length(D1.raw);


for i=1:nPhase
    
    data            = D1.raw(i);

    D.plot(i).time  = D1.raw(i).time;
    D.plot(i).phase = D.phase{i};
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    D.plot(i).xc    = data.state.xc; % bottom end point on the stick
    D.plot(i).yc    = data.state.yc; % bottom end point on the stick
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    
    D.plot(i).xp    = data.state.xp; % top end point on the stick
    D.plot(i).yp    = data.state.yp; % top end point on the stick
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
   
    D.plot(i).ys    = data.state.ys; % table
    

end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%           Figure out how big to make the viewing window:
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
start_phase=length(D.plot)-20

rawExtents          = getExtents(D,start_phase);
zoomScale           = 1.1;  %How much to pad the viewing window (>=1);
xMean               = mean(rawExtents(1:2));
yMean               = mean(rawExtents(3:4));
shiftExtents        = [xMean, xMean, yMean, yMean];
P.extents           = (rawExtents - shiftExtents)*zoomScale + shiftExtents;
P.timeRate          = timeRate;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                       Animation (Real Time)                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
iphase = start_phase;

tb= D.data.time(D.JumpIdx(start_phase));

  tic
%  timeNow = (toc)*timeRate
timeNow = (toc)*timeRate+tb

cnt=1;
while iphase <= length(D.plot)
     if timeNow > D.plot(iphase).time(end)
         iphase = iphase + 1;
         iphase
     else
        plotFrame(D,D1,D.plot(iphase),timeNow,P,setup,start_phase);
        timeNow = toc*timeRate+tb;
        F(cnt) = getframe(gcf) ;
        cnt=cnt+1;
        %drawnow
    end
end

%plotFrame(D,D1,D.plot(end),D.plot(end).time(end),P);





end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%~~~~~~~~~~~~~~~~~~~~~~~~  SUB FUNCTIONS  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function plotFrame(D,D1,Data,t,P,setup,start_phase)

%This function is designed to be used inside of an animation function.
%
% Data is the simulation data for a single phase of the motion
% t = the desired time for plotting
% axisData is a struct of things for formatting the axis
%


Time = Data.time;
PointC = [Data.xc', Data.yc'];
PointP = [Data.xp', Data.yp'];

%Intepolate to get the right position
try
    PC = interp1(Time,PointC,t,'cubic');
    PP = interp1(Time,PointP,t,'cubic');

catch ME

    %Assume that there is only one grid point in Time, causing an error
    PC = PointC;
    PP = PointP;
 
end

%Actual plotting happens here
 
 clf; hold on; box on
 xGnd = P.extents(1:2);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                       Position of the table
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
 
 ys= P.A*cos(P.omega*t);
 yGnd = ys*ones(size(xGnd)); %  position of the table top
 plot(xGnd,yGnd,'k:','LineWidth',2);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                       Plot tragectory(xp(t),yp(t)) colored
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
plot_traj_color( D,D1,start_phase )

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                       Plot stick 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

plot(PC(1),PC(2),'r.','MarkerSize',10);
plot(PP(1),PP(2),'m.','MarkerSize',10);
plot([PC(1), PP(1)],[PC(2), PP(2)],'k-','LineWidth',1);


%Make a pretty title and annotation for pinned constraint

switch Data.phase
    case 'HINGE'
        phaseName = 'Pinned Rotation';
        plot(PC(1),PC(2),'ko','MarkerSize',25,'LineWidth',1);
    case 'SLIDE_POS'
        phaseName = 'Sliding to the right';
    case 'SLIDE_NEG'
        phaseName = 'Sliding to the left';
    case 'FLIGHT'
        phaseName = 'Flight phase';
         
    otherwise
        error('Invalid phase!')
end

s1= strcat('$\gamma/k = $', num2str(setup.p.gamma /setup.p.k,'%.3f') );
s2= strcat('$1/\omega = $', num2str(1/setup.p.omega,'%.3f'));
s3= strcat('$\sqrt{m\ell^2/k}= $', num2str(sqrt(setup.p.m*setup.p.l^2/setup.p.k),'%.3f'));
s4 = strcat('$\Gamma=',num2str(setup.p.G),'g$');
s=strcat(s1,', \, \,  ',s2,', \, \, ',s3,', \, \,',s4);


ch_title=strcat(s);
% sgt=sgtitle(ch_title,'interpreter','latex')
% sgt.FontSize = 35;
title(ch_title) ;
subtitle(['Simulation Time: ' sprintf('%4.2f',t) ', --  Phase: ' phaseName]);
axis equal; axis(P.extents);  axis manual;
xlabel('Horizontal Position (m)')
ylabel('Vertical Position (m)')

drawnow;

end


function extents = getExtents(D,start_phase)

%This function is just gets the extents of all of the data in the animation
%by keeping track of min and max values in all phases.

Data = D.plot;

xMin = inf;
xMax = -inf;
yMin = inf;
yMax = -inf;
for iphase = start_phase:length(Data)
    
%     xDat = [Data(iphase).x0,...
%         Data(iphase).x2];
%     
%     yDat = [Data(iphase).y0,...
%         Data(iphase).y2];
%     

   xDat = [Data(iphase).xc,...
        Data(iphase).xp];
    
    yDat = [Data(iphase).yc,...
        Data(iphase).yp];
   

xMinTest = min(xDat);
    if xMinTest < xMin
        xMin = xMinTest;
    end
    
    xMaxTest = max(xDat);
    if xMaxTest > xMax
        xMax = xMaxTest;
    end
    
    yMinTest = min(yDat);
    if yMinTest < yMin
        yMin = yMinTest;
    end
    
    yMaxTest = max(yDat);
    if yMaxTest > yMax
        yMax = yMaxTest;
    end
    
end

extents = [xMin-.005, xMax+0.005, yMin, yMax];

end

