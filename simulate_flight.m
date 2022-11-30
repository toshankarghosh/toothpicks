function data = simulate_flight(setup)

%This function simulates the flight phase of the dynamics


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Initial Conditions                            %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Set up the integration algorithm

Tspan = setup.Tspan;

setup.IC.dth = -(setup.p.k/setup.p.gamma)*(setup.IC.th -setup.p.theta_0);

IC = [ setup.IC.xc;  setup.IC.yc;  setup.IC.th;...
       setup.IC.dxc; setup.IC.dyc; setup.IC.dth ];


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           ODE45                                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
 
eventFunc       = @(t,z)Event_Flight(t,z,setup);
options         = odeset(...
                        'RelTol',setup.tol,...
                        'AbsTol',setup.tol,...
                        'Vectorized','on',...
                        'Events',eventFunc,'refine',setup.refine);
userfun         = @(t,z)dynamics_flight(t,z,setup);
sol             = ode45(userfun,Tspan,IC,options);                         %Run ode45 until termination


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Evaluating the solutions                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Format for post processing
tspan           = [sol.x(1),sol.x(end)];
%nTime           = ceil(setup.dataFreq*diff(tspan));
nTime            =   setup.dataFreq;
t               = linspace(tspan(1),tspan(2),nTime);                       % create a time array 
Z               = deval(sol,t);                                            % dval evaluates the solution sol of a differential equation problem at the points contained in t.
[dZ,Zp, Zs, C]  = dynamics_flight(t,Z,setup);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Formatting                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Store in a nice format for plotting

data.time       = t;

% Values  for the lower base C

data.state.xc   = Z(1,:);
data.state.yc   = Z(2,:);
data.state.th   = Z(3,:);
data.state.dxc  = Z(4,:);
data.state.dyc  = Z(5,:);
data.state.dth  = Z(6,:);

% Values  for the tip P

data.state.xp   = Zp(1,:);
data.state.yp   = Zp(2,:);
data.state.pth  = Zp(3,:);
data.state.dxp  = Zp(4,:);
data.state.dyp  = Zp(5,:);
data.state.pdth = Zp(6,:);

% Values  for the table  S

data.state.ys   = Zs(1,:);
data.state.dys  = Zs(2,:);

% Contact forces 

data.contact.Fx = C(1,:);
data.contact.Fy = C(2,:);

% parameters

data.p          = setup.p;

disp(['The exit condition for Flight is ', num2str(sol.ie)])

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        State machine                                    %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Get transitions for finite state machine
data.phase = 'FLIGHT';
if isempty(sol.ie)
    data.exit = 'TIMEOUT';
else
    switch sol.ie(end)
        case 1   % far end of the stick hit the ground
            data.exit = 'STRIKE_2';
        case 2   %close end of the stick hit the ground
            data.exit = 'STRIKE_0';
        
        otherwise
            error('Invalid exit condition in simulate flight')
    end
end

end

