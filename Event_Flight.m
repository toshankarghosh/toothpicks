%% Determines the exit condition for the flight phase
%% Checked by ODE45 to see if an event has occurred and what to do.

function [value,isterminal,direction] = Event_Flight(t,Zp,setup)

[dZ,Zc, Zs, C]  = dynamics_flight(t,Zp,setup);

omega = setup.p.omega;
A     = setup.p.A;
L     = setup.p.l;

ys=A*cos(omega*t); % position of the table 

th  = Zp(3,:);
y2  = Zp(2,:);
y1=y2-L*cos(th);
% note here in the flight mode theta = theta_0
hc  = y1-ys+1e-9   ;                                                           % distance of the bottom end of the stick from the table
%disp([y1 y2])



%%%% CONSTRAINTS %%%%
% 1) y2 > 0
% 2) hc > 0

n           = length(th);
value       = zeros(2,n);
value(1,:)  = y2-ys;
value(2,:)  = hc;


isterminal  = true(size(value));
direction   = -ones(size(value));

end
