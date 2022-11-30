function [dZ,Zp,Zs, C] = dynamics_slideNeg(t,Z,setup)
%   State vector z = [xc,yc,theta,xcdot,ycdot,thetadot]'
%   	F_y= \frac{K(\theta-\theta_0)}{L(-\mu \cos\theta  +   \sin\theta)}  \\
%   	\ddot{x}_p=\mu F_y/m 
%       \ddot{y}_p=  F_y/m-g
%       \ddot{y}_c &= \ddot{y}_s
%       \ddot{\theta} &=\frac{1}{\sin \theta}\left( \frac{\ddot{y}_c-\ddot{y}_p}{L} -\dot{\theta}^2\cos\theta \right)
%       \ddot{x}_{c}& = \mu F_y/m -L(- \dot{\theta}^2 \sin\theta + \ddot{\theta} \cos \theta)

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
mu      = setup.p.mu;
theta_0 = setup.p.theta_0;
gamma   = setup.p.gamma;

omega   = setup.p.omega;
A       = setup.p.A;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Table (s)                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% motion of the table
[ys dys ddys] = Table(t,setup);
     Zs       = [ys;    dys ];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Tip (P)                                        %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

xp      =  xc  + L * sin(th);
yp      =  yc  + L * cos(th);
dxp     =  dxc + L * (dth.*cos(th));
dyp     =  dyc - L * (dth.*sin(th));
Fy      =  (K * (th-theta_0)+gamma*dth)./(L*(sin(th) - mu * cos(th))) ;
ddxp    =  mu * Fy/m ;
ddyp    =  Fy/m - g;
ddth    = ((1./sin(th)).*((ddys-ddyp)./L - (dth.^2).*cos(th)));
Zp      = [xp;    yp;    th;    dxp;    dyp;    dth];


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Base (C)                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

ddxc    = ddxp - L*(-(dth.^2).*sin(th) + ddth.*cos(th));
ddyc    = ddys;
dZ      = [dxc;    dyc;    dth;    ddxc;    ddyc;    ddth];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Contact Forces                                %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
C(1,:)  = mu * Fy; % F_xp= m \ddotxp
C(2,:)  = Fy; %


end
