function data = simulate_hinge(setup)

%This function simulates the hinge phase of the dynamics

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Initial Conditions                            %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Set up the integration algorithm

Tspan   = setup.Tspan;

 IC     = [ setup.IC.xc;  setup.IC.yc;  setup.IC.th;...
            setup.IC.dxc; setup.IC.dyc; setup.IC.dth ];
   
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           ODE45                                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

eventFunc   = @(t,z)Event_Hinge(t,z,setup);
options     = odeset(...
                     'RelTol',setup.tol,...
                     'AbsTol',setup.tol,...
                     'Vectorized','on',...
                     'Events',eventFunc,'refine',setup.refine);
userfun     = @(t,z)dynamics_hinge(t,z,setup);
sol         = ode45(userfun,Tspan,IC,options);                             %Run ode45 until termination

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Evaluating the solutions                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Format for post processing
tspan           = [sol.x(1),sol.x(end)];
%nTime           = ceil(setup.dataFreq*diff(tspan));
nTime            =   setup.dataFreq;
t               = linspace(tspan(1),tspan(2),nTime);
Z               = deval(sol,t);
[dZ,Zp,Zs, C]   = dynamics_hinge(t,Z,setup);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Formatting                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Store in a nice format for plotting

data.time           = t;

% Values  for the lower base C

data.state.xc       = Z(1,:);
data.state.yc       = Z(2,:);
data.state.th       = Z(3,:);
data.state.dxc      = Z(4,:);
data.state.dyc      = Z(5,:);
data.state.dth      = Z(6,:);

% Values  for the tip P

data.state.xp       = Zp(1,:);
data.state.yp       = Zp(2,:);
data.state.pth      = Zp(3,:);
data.state.dxp      = Zp(4,:);
data.state.dyp      = Zp(5,:);
data.state.pdth     = Zp(6,:);

% Values  for the table  S

data.state.ys       = Zs(1,:);
data.state.dys      = Zs(2,:);

% Contact forces 

data.contact.Fx     = C(1,:);
data.contact.Fy     = C(2,:);

% Parameters

data.p = setup.p;

disp(['The exit condition for Hinge is ', num2str(sol.ie)])

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        State machine                                    %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Get transitions for finite state machine
data.phase = 'HINGE';
if isempty(sol.ie)
    data.exit = 'TIMEOUT';
else
        switch sol.ie(end)
            case 1
                data.exit = 'FALL_NEG';
            case 2
                data.exit = 'FALL_POS';
            case 3
                data.exit = 'LIFT';
            case 4
                data.exit = 'SLIP_NEG';
            case 5
                data.exit = 'SLIP_POS';
            case 6
                data.exit = 'LIFT';      
            otherwise
                error('Invalid exit condition in simulate hinge')
        end
end

end

