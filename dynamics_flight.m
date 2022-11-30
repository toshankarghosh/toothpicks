function [dZ,Zp,Zs, C] = dynamics_flight(t,Z,setup)
%   State vector z = [x,y,theta,xdot,ydot,thetadot]'


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

xc      = Z(1,:);
yc      = Z(2,:);
th      = Z(3,:);
dxc     = Z(4,:);
dyc     = Z(5,:);
dth     = Z(6,:);%-K*(th-theta_0)/gamma;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Table (s)                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% motion of the table
[ys, dys , ~] = Table(t,setup);
     Zs       = [ys ; dys ];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Tip (P)                                        %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

xp      =  xc+L*sin(th);
yp      =  yc+L*cos(th);
ddyp    = -g;
dxp     = dxc + L*dth.*cos(th);
%disp(['dxc =  ' num2str(dxc) '   dth = ' num2str(dth) '   th =  ' num2str(th)])
dyp     = dyc - L*dth.*sin(th);
Zp     = [xp ; yp ;th ;  dxp; dyp; dth];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Base (C)                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

ddxc =  0; 
ddyc = -g;
ddth =  -K*(dth)/gamma;
dZ   = [ dxc dyc dth ddxc ddyc ddth]';

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Contact Forces                                %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

C(1,:)= zeros(1,length(t));                                                % No contact force
C(2,:)= zeros(1,length(t));                                                % No contact force

end
