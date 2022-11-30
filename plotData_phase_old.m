function plotData_phase(D, D1, setup)


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
rows                = 3; 
columns             = 2;

 fig_states = figure(1);
      set(fig_states, 'Name', 'States', 'NumberTitle', 'off');
      clf;
% 
 fig_Contact = figure(2);
      set(fig_Contact, 'Name', 'Length Check ', 'NumberTitle', 'off');
      clf   ;

 fig_Contact = figure(3);
      set(fig_Contact, 'Name', 'Contact Forces ', 'NumberTitle', 'off');
      clf   ;
%  

for i = 1:nPhase

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack D1.raw                                 %
% D1.raw.time   D1.raw.state   D1.raw.contact    D1.raw.p    D1.raw.phase %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    data_phase      = D1.raw(i);

    
    t_phase         = data_phase.time;

    % Values  for the lower base C

    th_phase        = data_phase.state.th;
    dth_phase       = data_phase.state.dth;
    xc_phase        = data_phase.state.xc;
    dxc_phase       = data_phase.state.dxc;
    yc_phase        = data_phase.state.yc;
    dyc_phase       = data_phase.state.dyc;
    

    % Values  for the tip P

    xp_phase        = data_phase.state.xp;
    dxp_phase       = data_phase.state.dxp;
    yp_phase        = data_phase.state.yp;
    dyp_phase       = data_phase.state.dyp;

    % Values  for the table  S

    ys_phase        = data_phase.state.ys;
    dys_phase       = data_phase.state.dys;

    % Contact forces 

    Fx_phase        = data_phase.contact.Fx;
    Fy_phase        = data_phase.contact.Fy;
    

   % Length Check
    Lcheck         =  sqrt((xp_phase -xc_phase).^2+ ...
                      (yp_phase -yc_phase).^2)-L;
    LW=1;
    sz=2;
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
    set(fig_states, 'Name', 'States', 'NumberTitle', 'off');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 1 :(t,\theta )                           %
     
        ax1         =   subplot(rows, columns, 1); hold on;
            
            h1      =    plot(t_phase, th_phase,...
                              'color', colr,'LineWidth', LW);
            ylabel('Angle (rad)','interpreter', 'latex')
            xlabel('Time (s)','interpreter', 'latex')
            box on
            grid on

            dottedLine(Jumps, axis);
            legend(h1, 'Angle')

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 2 :(t,\dot{\theta} )                     %

        ax2 =   subplot(rows, columns, 2); hold on;
            
            h1      =    plot(t_phase, dth_phase,...
                              'color', colr,'LineWidth', LW);
            
            ylabel('Rate (rad)')
            xlabel('Time (s)')
            box on
            grid on

            dottedLine(Jumps, axis);
            legend(h1, 'Rate Angle')

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 3 :(t,xc ) 
%                           plot 3: (t, xp)
%

        ax3 =   subplot(rows, columns, 3); hold on;
            
            h1      =    plot(t_phase, xc_phase,'-o',...
                              'color', colr,'LineWidth', LW);
            h1.MarkerSize = sz;

            h2      =    plot(t_phase, xp_phase,'-s',...
                              'color', colr,'LineWidth', LW);
            h2.MarkerSize = sz;

            ylabel('x-position (m)')
            xlabel('Time (s)')
            box on
            grid on

            dottedLine(Jumps, axis);
 
            legend([h1 h2], '$x_c$' ,'$x_p$');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 4 :(t,yc )                               %  
%                           plot 4 :(t,ys )                               %  


        ax4 =   subplot(rows, columns, 4); hold on
        
            h1      =   plot(t_phase, yc_phase,'-o',...
                            'color', colr,'LineWidth', LW);
            h1.MarkerSize = sz;
            
            h2      =   plot(t_phase, yp_phase,'-s',...
                            'color', colr,'LineWidth', LW);
            h2.MarkerSize = sz;

            h3      =   plot(t_phase, ys_phase,':',...
                            'color', colr,'LineWidth', LW);
                  
            ylabel('y-position (m)')
            xlabel('Time (s)')
            box on
            grid on

            dottedLine(Jumps, axis);
            legend([h1 h2 h3], '$y_c$', '$y_p$', '$y_s$');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 5 :(t,dxc )                              %

        ax5 =   subplot(rows, columns, 5); hold on
            
            h1      =   plot(t_phase, dxc_phase,'-o',...
                            'color', colr,'LineWidth', LW);
            h1.MarkerSize = sz;
            
            h2      =   plot(t_phase, dyc_phase, '-s',...
                            'color', colr,'LineWidth', LW);
             h2.MarkerSize = sz;


            
            ylabel('x-velocity (m/s)')
            xlabel('Time (s)')
            box on
            grid on

            dottedLine(Jumps, axis);
            legend([h1 h2], '$v_{c,x}$', '$v_{p,x}$');


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 6 :(t,dyc )                              %  
%                           plot 6 :(t,dyp )                              %  
%                           plot 6 :(t,dys )                              %  

        ax6 =   subplot(rows, columns, 6); hold on
            
            h1      =   plot(t_phase, dyc_phase,'-o',...
                        'color', colr,'LineWidth', LW);
            h1.MarkerSize = sz;    

            
            h2      =   plot(t_phase,dyp_phase,'-s',...
                        'color', colr,'LineWidth', LW);
            h2.MarkerSize = sz;
            
            
            h3      =   plot(t_phase,dys_phase,':',...
                            'color', colr,'LineWidth', LW);

            ylabel('y-velocity (m/s)')
            xlabel('Time (s)')
            box on
            dottedLine(Jumps, axis);
            legend([h1,h2,h3], '$v_c(y)$', '$v_p(y)$', '$v_s(y)$');
            grid on

            linkaxes([ax1,ax2, ax3, ax4 , ax5, ax6],'x');
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Length Check                                  %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
fig_Contact = figure(2);  hold on
      set(fig_Contact, 'Name', 'Length Check ', 'NumberTitle', 'off');
           h1      =   plot(t_phase, Lcheck,...
                            'color', colr,'LineWidth', LW);
            
            ylabel('Length-L (m)')
            xlabel('Time (s)')
            box on
            dottedLine(Jumps, axis);
            

                

    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Forces                                        %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
flag_force = 1;
    if flag_force == 1
        
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        fig_Contact = figure(3);
        set(fig_Contact, 'Name', 'Contact Forces ', 'NumberTitle', 'off');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        
            bx1=subplot(3, 1, 1); hold on;
                plt1=plot(t_phase, Fx_phase, '-o','color', colr,'LineWidth', LW);
                plt1.MarkerSize =sz;
                ylabel('$F_x$ (N)')
                xlabel('Time (s)')
                box on
                dottedLine(Jumps, axis);
                %legend(plt1, 'Horizontal')
                grid on
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        
            bx2=subplot(3, 1, 2); hold on;
                plt2=plot(t_phase, Fy_phase, '-o','color', colr,'LineWidth', LW);
                plt2.MarkerSize =sz;
                ylabel('$F_y$ (N)') 
                xlabel('Time (s)')
                box on
                dottedLine(Jumps, axis);
               % legend(plt2, 'Vertical')
                grid on
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        
            bx3 = subplot(3, 1, 3); hold on;
                plt3=plot(t_phase, Fx_phase./Fy_phase,'-o', 'color', colr,'LineWidth', LW);
                     %plot(t_phase, Fx_phase./Fy_phase,'o' );
                %plt2.LineStyle='-o';
                plt3.MarkerSize =sz;
                ylabel('$F_x/F_y$')
                xlabel('Time (s)')
                box on
                dottedLine(Jumps, axis);
               % legend(plt2, 'Vertical')
               ylim([-1 ,1]);
               grid on

            linkaxes([bx1,bx2, bx3],'x');
    
    end
end

%%%% SUB FUNCTIONS %%%%



function dottedLine(time, AXIS)

for i = 1:length(time)
    %Plots a dotted line between phases
    p1=plot(time(i)*[1; 1], [AXIS(3); AXIS(4)], '--k', 'LineWidth', 1);
    p1.Color(4) = 0.1; % transparency
%    scatter([time(i), AXIS(4)], 3,'filled'); 



    
end

end
end