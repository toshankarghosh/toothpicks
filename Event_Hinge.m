%% Determines the exit condition for the hinge phase
function [value,isterminal,direction] = Event_Hinge(t,Z,setup)

[dZ, Zp, Zs, contacts] = dynamics_hinge(t,Z,setup);

omega   = setup.p.omega;
A       = setup.p.A;
ys      =  A*cos(omega*t); % motion of the table

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack Z                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

xc      = Z(1,:);
yc      = Z(2,:);
th      = Z(3,:);
dxc     = Z(4,:);
dyc     = Z(5,:);
dth     = Z(6,:);


Fx   = contacts(1,:);
Fy   = contacts(2,:);



mu = setup.p.mu;
L  = setup.p.l;


yc = Z(2,:);                                                                % position of the bottom end of the stick
yp = yc + L*cos(th);                                                        % position of the top end of the stick
hc=yc-ys;                                                                   % distance of the bottom end of the stick from the table



%%%% CONSTRAINTS %%%%
% 1) -pi/2 < th
% 2) th < pi/2
% 3) V > 0
% 4) H > -u*H
% 5) H < u*H
% 6) hc >0

% As a rule, each constraint will be satisfied if it's event function value
% is positive. This makes things easier at the FSM level.


n           = length(th);
value       = zeros(5,n);
isterminal  = true(size(value));
direction   = -ones(size(value));

value(1,:)  = th + pi/2;    %'FALL_NEG';
value(2,:)  = pi/2 - th;    %'FALL_POS';
value(3,:)  = Fy;           % LIFT OFF will not happen
value(4,:)  = mu*Fy - Fx;   % slip negative
value(5,:)  = mu*Fy + Fx;   % slip positive


%disp(['Fy=' num2str(Fy)])


end
