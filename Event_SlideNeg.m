function [value,isterminal,direction] = Event_SlideNeg(t,Z,setup)
L       = setup.p.l;
K       = setup.p.k;
mu      = setup.p.mu;
gamma   = setup.p.gamma;
theta_0 = setup.p.theta_0;

[dZ, Zp, Zs contacts] = dynamics_slideNeg(t,Z,setup);
th   = Z(3,:);
dxc  = Z(4,:);
dth   = Z(6,:);

ys   = Zs(1,:); 
Fx   = contacts(1,:);
Fy   = contacts(2,:);


yc = Z(2,:); % position of the bottom end of the stick
yp = yc + L*cos(th); % position of the top end of the stick
hc=yc-ys; % distance of the bottom end of the stick from the table
delta_th= abs(th)-1e-9;


fy_num =(K * (th-theta_0)+gamma*dth);
fy_den=(L*(sin(th) - mu * cos(th)));
 
 

%%%% CONSTRAINTS %%%%
% 1) -pi/2 < th
% 2) th < pi/2
% 3) dx <= 0
% 4) Fy >= 0
% 5) Fx >= 0
% 6) hc >0


% As a rule, each constraint will be satisfied if it's event function value
% is positive. This makes things easier at the FSM level.
n           = length(th);
value       = zeros(5,n);
isterminal  = true(size(value));
direction   = -ones(size(value));

value(1,:)  = th + pi/2; %'FALL_NEG';
value(2,:)  = pi/2 - th; %'FALL_POS';
value(3,:)  = -dxc;       %'STUCK'
value(4,:)  = fy_num;%Fy;         % FLIGHT 
value(5,:)  = delta_th;         % FLIGHT  this handle the theta =0 sigularity
end