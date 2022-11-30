function plotData_phase_paper(D, D1, setup)


 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
 %                           Unpack D
 % D.phase D.code D.data D.Jumps  D.Jumps D.JumpIdx  D.p
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
 
 data    = D.data;
 Jumps   = D.Jumps;

 % Parameters

 P       = D.p;
 L       = P.l;

 % Assign plot colors to each phase

 [COLR]  = plot_color_phase(D);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% The data structure D1.raw (i) contains the information about the system 
% between the ith and the (i+1)th  phase change  
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

nPhase              = length(D1.raw);                                      % Total  number of phase changes in the system 

% The  plots are arranged in a  [rows , columns] tabular form
rows                = 2; 
columns             = 2;
FS  = 24;


 fig_states = figure(1);
      set(fig_states, 'NumberTitle', 'off');
      clf;


for i=1:nPhase
    
    data            = D1.raw(i);

    D.plot(i).time  = D1.raw(i).time;
    D.plot(i).phase = D.phase{i};
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    D.plot(i).xc    = data.state.xc; % bottom end point on the stick
    D.plot(i).yc    = data.state.yc; % bottom end point on the stick
    D.plot(i).th    = data.state.th; % bottom end point on the stick
    D.plot(i).dxc    = data.state.dxc; % bottom end point on the stick
    D.plot(i).dyc    = data.state.dyc; % bottom end point on the stick
    D.plot(i).dth    = data.state.dth; % bottom end point on the stick
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    
    D.plot(i).xp    = data.state.xp; % top end point on the stick
    D.plot(i).yp    = data.state.yp; % top end point on the stick
    D.plot(i).dxp    = data.state.dxp; % top end point on the stick
    D.plot(i).dyp    = data.state.dyp; % top end point on the stick
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
   
    D.plot(i).ys     =  data.state.ys; % table
    D.plot(i).dys    =  data.state.dys; % table

    
    D.plot(i).Fx_phase       = data.contact.Fx;
    D.plot(i).Fy_phase       = data.contact.Fy;
    

end




for i = 1:nPhase

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack D1.raw                                 %
% D1.raw.time   D1.raw.state   D1.raw.contact    D1.raw.p    D1.raw.phase %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

 %   data_phase      = D1.raw(i);

    
    t_phase         = D.plot(i).time;%data_phase.time;

    % Values  for the lower base C

    th_phase        =  D.plot(i).th;     %data_phase.state.th;
    dth_phase       =  D.plot(i).dth;    %data_phase.state.dth;
    xc_phase        =  D.plot(i).xc;     %data_phase.state.xc;
    dxc_phase       =  D.plot(i).dxc;    %data_phase.state.dxc;
    yc_phase        =  D.plot(i).yc ;    %data_phase.state.yc;
    dyc_phase       =  D.plot(i).dyc;    %data_phase.state.dyc;
    

    % Values  for the tip P

    xp_phase        =  D.plot(i).xp;     %;data_phase.state.xp;
    dxp_phase       =  D.plot(i).dxp;    %;data_phase.state.dxp;
    yp_phase        =  D.plot(i).yp;     %;data_phase.state.yp;
    dyp_phase       =  D.plot(i).dyp;    %;data_phase.state.dyp;

    % Values  for the table  S

    ys_phase        =  D.plot(i).ys;     %data_phase.state.ys;
    dys_phase       =  D.plot(i).dys;    %data_phase.state.dys;

    % Contact forces 

    Fx_phase        =  D.plot(i).Fx_phase;%data_phase.contact.Fx;
    Fy_phase        =  D.plot(i).Fy_phase;%data_phase.contact.Fy;
    

   % Length Check
    Lcheck         =  sqrt((xp_phase -xc_phase).^2+ ...
                      (yp_phase -yc_phase).^2)-L;
    LW  = 2;
    sz  = 4;
%    cl  = [0.4940 0.1840 0.5560];
    cl  = [0.2 0.2 0.2];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    if max(abs(Lcheck)) > 1e-6
    
        disp ('Length Check error')
    
    end
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    % phase sensetive colors for line plots  

    colr            = COLR(i, :); % ADDS COLORS TO REPRESENT THE PHASE

    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           States                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    
    
    fig_states = figure(1);
    set(fig_states, 'NumberTitle', 'off');
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 1 :(t,\theta )                           %
     
        ax1         =   subplot(rows, columns, 1); hold on;
        
        h1      =    plot(t_phase, th_phase,...
                              'color', colr,'LineWidth', LW);
       ylabel('$\theta$ (rad)','interpreter', 'latex')
       xlabel('Time (s)','interpreter', 'latex')
      %  set(ax1,'xticklabel',[])

        box on
        grid on

            dottedLine(Jumps, axis);
            set(gca,"FontSize",FS)
           

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 2 :(t,xc ) 

%

        ax3 =   subplot(rows, columns, 2); hold on;

        
        


            
            h1      =    plot(t_phase, xc_phase,'-o',...
                              'color', colr,'LineWidth', LW);
            h1.MarkerSize = sz/2;


            ylabel('$x_c$ (m)')
            xlabel('Time (s)')
            %set(ax3,'xticklabel',[])

            box on
            grid on

            dottedLine(Jumps, axis);
            set(gca,"FontSize",FS)

            

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 3 :(t,yc )                               %  
%                           plot 3 :(t,ys )                               %  


        ax4 =   subplot(rows, columns, 3); hold on
        
       
            

%         h3      =   plot(t_phase, ys_phase,':',...
%                             'color', colr,'LineWidth', LW);

        h2  = patch([t_phase nan],[ys_phase nan],'w');
        h2.LineWidth =2;
        h2.LineStyle =':';
        h2.EdgeColor = cl;
        h2.EdgeAlpha = 0.5;
        h2.FaceColor = cl;
        h2.FaceAlpha = 0.5

          h1      =   plot(t_phase, yc_phase,...
                            'color', colr,'LineWidth', LW);         
       ylabel('$y_s$, $y_c$ (m)')
       xlabel('Time (s)')
       box on
       grid on

       dottedLine(Jumps, axis);
       set(gca,"FontSize",FS)


linkaxes([ax1, ax3, ax4],'x');

            
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 4 :(t,dxc )                              %

   ax5 =   subplot(rows, columns, 4); hold on

  
%   h2=plot(xc_phase, ys_phase,'-', 'color', [0 0 0],'LineWidth', LW);

   h2  = patch([xc_phase nan],[ys_phase nan],'w');
   h2.LineWidth =2;
   h2.LineStyle =':';
   h2.EdgeColor = cl;
   h2.EdgeAlpha = 0.5;
   h2.FaceColor = cl;
   h2.FaceAlpha = 0.5

   
    h1=plot(xc_phase, yc_phase, 'color', colr,'LineWidth', LW);


   box on
%  axis equal 

   ylabel('$y_s$, $y_c$ (m)')
   xlabel('$x_c$ (m)')
   

   set(gca,"FontSize",FS)

end

for i=1:4
    subplot(rows, columns,i)
%     pbaspect([2 1 1])
end

% subplot(rows, columns,4)
%     pbaspect([1 1 1])


for i = 1: 3
subplot(rows, columns,i)
set(gca,"FontSize",FS)
%xlim([0.25 .5])
xlim([1.5 2])
grid off
end



subplot(rows, columns,1)
ylim([setup.p.theta_0 1])

%ylim([0.436 0.442])
%ylim([0.436 0.46])
%ylim([0.436 0.46])
%ylim([0.436 0.438])

subplot(rows, columns,2)
ylim([0.0 1])
%ylim([0.01 .02])


subplot(rows, columns,3)
ylim([-5e-3 15e-3])
%ylim([-5e-3 5e-3])
%ylim([-0.3e-3 0.3e-3])


subplot(rows, columns,4)
% xlim([5 15])
% ylim([-5e-3 15e-3])
xlim([0 .075])
ylim([-5e-3 5e-3])
%xlim([0.012 .015])
%ylim([-0.0005 0.0005])

% xlim([1.75 2.25])
% ylim([-0.001 0.001])

% xlim([1.75 2.25])
% ylim([-0.001 0.001])

% xlim([0.004 0.006])
% ylim([0.0 0.0003])

%xlim([0 0.004])
%axis equal
set(gca,"FontSize",FS)


s0= strcat('$\mu = $', num2str(setup.p.mu,'%.3f') );
s1= strcat('$\gamma/k = $', num2str(setup.p.gamma /setup.p.k,'%.3f') );
s2= strcat('$1/\omega = $', num2str(1/setup.p.omega,'%.3f'))
s3= strcat('$\sqrt{m\ell^2/k}= $', num2str(sqrt(setup.p.m*setup.p.l^2/setup.p.k),'%.3f'))
s4 = strcat('$\Gamma=',num2str(setup.p.G),'g$');
s=strcat(s0,', \, \,',s1,', \, \,  ',s2,', \, \, ',s3,', \, \,',s4)


ch_title=strcat(s)
sgt=sgtitle(ch_title,'interpreter','latex')
sgt.FontSize = 35;


%%%% SUB FUNCTIONS %%%%



function dottedLine(time, AXIS)
%cl1= [0.7 0.7 0.7];
cl1  = [0.4940 0.1840 0.5560];
for i = 1:length(time)
    %Plots a dotted line between phases
    %p1=plot(time(i)*[1; 1], [AXIS(3); AXIS(4)], '--k', 'LineWidth', .2);
    p1 =patch(time(i)*[1; 1], [AXIS(3); AXIS(4)], 'w');

    p1.EdgeColor = cl1;
    p1.EdgeAlpha = 0.01;
    p1.FaceColor = cl1;
    p1.FaceAlpha = 0.01;

    p1.LineWidth = .1;
    p1.LineStyle ='-';
    
    
    %    scatter([time(i), AXIS(4)], 3,'filled'); 



    
end

end
end

