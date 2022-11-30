function plotData(D, D1, setup)



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack D
% D.phase D.code D.data D.Jumps  D.Jumps D.JumpIdx  D.p
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% 



data                = D.data;
Jumps               = D.Jumps;

 P       = D.p;
 L       = P.l;

% Assign plot colors to each phase

[COLR]              = plot_color_phase(D);



time                = data.time;

% Values  for the lower base C

th                  = data.state.th;
dth                 = data.state.dth;
xc                  = data.state.xc;
dxc                 = data.state.dxc;
yc                  = data.state.yc;
dyc                 = data.state.dyc;

% Values  for the tip P

xp                  = data.state.xp;
dxp                 = data.state.dxp;
yp                  = data.state.yp;
dyp                 = data.state.dyp;

% Values  for the tip P

ys                  = data.state.ys;
dys                 = data.state.dys;

% Contact forces 


Fx                  = data.contact.Fx;
Fy                  = data.contact.Fy;

% Parameters

P                   = D.p;
rows                = 3; 
columns             = 2;
LW                  =2;
sz                  =4;


% Length Check
    Lcheck         =  sqrt((xp -xc).^2+ ...
                      (yp -yc).^2)-L;

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

 fig_Foot_Locomotion = figure(4);
        set(fig_Foot_Locomotion , 'Name', 'Foot Locomotion ', 'NumberTitle', 'off');     
        clf ;
 
 fig_yp = figure(5); hold on
    set(fig_yp , 'Name', 'Yp ', 'NumberTitle', 'off');       
        clf;
        %


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           States                                        %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
fig_states                = figure(1);
clf;
set(fig_states, 'Name', 'States', 'NumberTitle', 'off');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 1 :(t,\theta )                           %

         ax1         =   subplot(rows, columns, 1); hold on;
         
            
         h1      =    plot(time, th,...
                              'color', 'red','LineWidth', LW);
            ylabel('Angle (rad)','interpreter', 'latex')
            xlabel('Time (s)','interpreter', 'latex')
            box on
            grid on

            dottedLine(Jumps, axis);
            legend(h1, 'Angle')

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 2 :(t,\dot{\theta} )                     %

        ax2 =   subplot(rows, columns, 2); hold on;
            
          h1      =    plot(time, dth,...
                              'color', 'red','LineWidth', LW);
            
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
            
            h1      =    plot(time, xc,'-o',...
                              'color', 'r','LineWidth', LW);
            h1.MarkerSize = sz;

%             h2      =    plot(time, xp,'-s',...
%                               'color', 'b','LineWidth', LW);
%             h2.MarkerSize = sz;

            ylabel('x-position (m)')
            xlabel('Time (s)')
            box on
            grid on

            dottedLine(Jumps, axis);
 
%             legend([h1 h2], '$x_c$' ,'$x_p$');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 4 :(t,yc )                               %  
%                           plot 4 :(t,ys )                               %  


        ax4 =   subplot(rows, columns, 4); hold on
        
            h1      =   plot(time, yc,'-o',...
                            'color', 'r','LineWidth', LW);
            h1.MarkerSize = sz;
            
  %          h2      =   plot(time, yp,'-s',...
  %                          'color', 'b','LineWidth', LW);
  %          h2.MarkerSize = sz;

            h3      =   plot(time, ys,':',...
                            'color', 'g','LineWidth', LW);
                  
            ylabel('y-position (m)')
            xlabel('Time (s)')
            box on
            grid on

            dottedLine(Jumps, axis);
%            legend([h1 h2 h3], '$y_c$', '$y_p$', '$y_s$');
            legend([h1 h3], '$y_c$',  '$y_s$');


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           plot 5 :(t,dxc )                              %

        ax5 =   subplot(rows, columns, 5); hold on
            
            h1      =   plot(time, dxc,'-o',...
                            'color', 'r','LineWidth', LW);
            h1.MarkerSize = sz;
            
            h2      =   plot(time, dxp, '-s',...
                            'color', 'b','LineWidth', LW);
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
            
            h1      =   plot(time, dyc,'-o',...
                        'color', 'r','LineWidth', LW);
            h1.MarkerSize = sz;    

            
            h2      =   plot(time,dyp,'-s',...
                        'color', 'b','LineWidth', LW);
            h2.MarkerSize = sz;
            
            
            h3      =   plot(time,dys,':',...
                            'color', 'g','LineWidth', LW);

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
           h1      =   plot(time, Lcheck,...
                            'color', 'r','LineWidth', LW);
            
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
                plt1=plot(time, Fx, '-o','color', 'r','LineWidth', LW);
                plt1.MarkerSize =sz;
                ylabel('$F_x$ (N)')
                xlabel('Time (s)')
                box on
                dottedLine(Jumps, axis);
                %legend(plt1, 'Horizontal')
                grid on
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        
            bx2=subplot(3, 1, 2); hold on;
                plt2=plot(time, Fy, '-o','color', 'b','LineWidth', LW);
                plt2.MarkerSize =sz;
                ylabel('$F_y$ (N)') 
                xlabel('Time (s)')
                box on
                dottedLine(Jumps, axis);
               % legend(plt2, 'Vertical')
                grid on
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        
            bx3 = subplot(3, 1, 3); hold on;
                plt3=plot(time, Fx./Fy,'-o', 'color', 'g','LineWidth', LW);
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
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    
   fig_Foot_Locomotion = figure(4); hold on
        set(fig_Foot_Locomotion , 'Name', 'Foot Locomotion ', 'NumberTitle', 'off');
   
   h1=plot(xc, ys,'-o', 'color', 'g','LineWidth', LW);
   h2=plot(xc, yc,'-o', 'color', 'b','LineWidth', LW);
   box on
   ylabel('$y_s$, $y_c$')
   xlabel('$x_c$')
   axis equal
   %%legend([h1,h2,h3], '$v_c(y)$', '$v_p(y)$', '$v_s(y)$');
   legend([h1, h2], '$y_s$', '$y_c$');


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    fig_yp = figure(5); hold on
    set(fig_yp , 'Name', 'Yp ', 'NumberTitle', 'off');
   
   h1=plot(time, yp,'-o', 'color', 'g','LineWidth', LW);
   
   box on
   ylabel('$y_p$')
   xlabel('$t$')
   %%legend([h1,h2,h3], '$v_c(y)$', '$v_p(y)$', '$v_s(y)$');
   legend([h1], '$y_p$');
   grid on
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