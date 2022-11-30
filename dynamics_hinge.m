function [dZ, Zp, Zs, C] = dynamics_hinge(t,Z,setup)
%
%  mL^2\ddot{\theta}=(g+\ddot{y}_s)mL\sin\theta - K(\theta-\theta_0)
%   x_p        = L\sin \theta+x_c ; 
%   \ddot{x}_p =L(- \dot{\theta}^2 \sin\theta + \ddot{\theta} \cos \theta)
%   y_p        = L\cos \theta+y_s
%   \ddot{y}_p= \ddot{y}_s + L( -\dot{\theta}^2 \cos\theta   - \ddot{\theta} \sin \theta ).
%   note that in the pivot phase the bottom end is fixed 
%   \dot{x_c}   = 0         ;  \dot{y_c}   = \dot{y}_s 
%   \ddot{x_c}  = 0         ;  \ddot{y_c}  = \ddot{y}_s
%   Here, the contact forces $F_x , F_y$ are given by the following equations 
%   F_x =m\ddot{x}_p 
%   F_y =m(\ddot{y}_p-\ddot{y}_s +g)
 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack Z                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

xc      = Z(1,:);
yc      = Z(2,:);
th      = Z(3,:);
dxc     = Z(4,:);
dyc     = Z(5,:);
dth     = Z(6,:);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Parameters                                    %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

m       = setup.p.m;
g       = setup.p.g;
L       = setup.p.l;
I       = setup.p.I;
K       = setup.p.k;
theta_0 = setup.p.theta_0;
gamma   = setup.p.gamma;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Table (s)                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% motion of the table
[ys dys ddys] = Table(t,setup);
     Zs       = [ys;    dys ];


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        \ddot{\theta}                                    %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
     
ddth    = ((L*m*(g+ ddys).*sin(th) ) - (K*(th-theta_0) + gamma* dth))./(I + L^2*m);        % angular accelaration

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Tip (P)                                        %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%C      = zeros(2,length(th));                                             % [horizontal; vertical]
xp      =  xc+L*sin(th);
yp      =  yc+L*cos(th);
dxp     = dxc + L*dth.*cos(th);
dyp     = dyc - L*dth.*sin(th);
ddxp    = -L*(dth.^2).*sin(th) + L*ddth.*cos(th);
ddyp    = -L*(dth.^2).*cos(th) - L*ddth.*sin(th) + ddys;
theta_f =  atan2(-dyp,dxp) ;
Zp      = [xp ; yp; th;  dxp; dyp; dth];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Base (C)                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% for hinge mode the bottom end is fixed 
ddxc = 0;
ddyc = ddys;
dZ   = [ dxc dyc dth ddxc ddyc ddth]';

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Contact Forces                                %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
 
C(1,:) = m.*ddxp;                                                           % F_x= m \ddotx
C(2,:) = m.*(ddyp + g);                                                     %N=m(\ddot y +g)



end
