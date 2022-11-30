function [value,isterminal,direction] = Event_Flight(t,Z,setup)

[dZ, Zp, Zs, contacts] = dynamics_flight(t,Z,setup);

omega = setup.p.omega;
A     = setup.p.A;
L     = setup.p.l;

ys=A*cos(omega*t); % position of the table 

th  = Z(3,:);
y1  = Z(2,:);                                                                % position of the bottom end of the stick
y2  = y1 + L*cos(th);                                                        % position of the top end of the stick

% note here in the flight mode theta = theta_0
hc  = y1-ys;                                                                % distance of the bottom end of the stick from the table




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