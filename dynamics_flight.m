function [dZ,Zc,Zs, C] = dynamics_flight(t,Zp,setup)

%% sets up the equations of motion for the flight phase for the ODE45 solver called from the <simulate_flight.m> function
%% State vector z = [x,y,theta,xdot,ydot,thetadot]'
%% In this phase the stick is not making a contact with the platform, % i.e., $h_c >0$ and hence both the contact forces 
%% F_x = 0 
%% F_y = 0  
%% \ddot{x}_p=0 
%% \ddot{z}_p=-g 
%% \dot{\theta}=-K(\theta-\theta_0)/\gamma;




%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Parameters                                    %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
 
m       = setup.p.m;
g       = setup.p.g;
L       = setup.p.l;
I       = setup.p.I;
K       = setup.p.k;
omega   = setup.p.omega;
A       = setup.p.A;
gamma   = setup.p.gamma;
theta_0 = setup.p.theta_0;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack Z                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%xc      = Z(1,:);
%yc      = Z(2,:);

xp      = Zp(1,:);
yp      = Zp(2,:);

th      = Zp(3,:);
%dxc     = Z(4,:);
%dyc     = Z(5,:);
dxp     = Zp(4,:);
dyp     = Zp(5,:);

dth     = Zp(6,:);%-K*(th-theta_0)/gamma;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Table (s)                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% motion of the table
[ys, dys , ~] = Table(t,setup);
     Zs       = [ys ; dys ];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Tip (P)                                        %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

ddxp   =   0;
ddyp   = - g;
ddth   =  -K*(dth)/gamma;


%dxp     = dxc + L*dth.*cos(th);
%disp(['dxc =  ' num2str(dxc) '   dth = ' num2str(dth) '   th =  ' num2str(th)])
%dyp     = dyc - L*dth.*sin(th);
%Zp     = [xp ; yp ;th ;  dxp; dyp; dth];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Base (C)                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
xc=xp-L*sin(th);
dxc=dxp-L.*dth.*cos(th);
yc=yp-L*cos(th);
dyc=dyp+L.*dth.*sin(th);
Zc     =[xc;yc;th;dxc;dyc;dth];
ddxc =  0; 
ddyc = -g;
dZ   = [ dxp dyp dth ddxp ddyp ddth]';

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Contact Forces                                %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

C(1,:)= zeros(1,length(t));                                                % No contact force
C(2,:)= zeros(1,length(t));                                                % No contact force

end
