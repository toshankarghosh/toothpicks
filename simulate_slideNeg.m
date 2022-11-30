function data = simulate_slideNeg(setup)

%This function simulates the stick sliding to the left 

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Initial Conditions                            %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Set up the integration algorithm
Tspan               = setup.Tspan;
IC                  = [ setup.IC.xc;  setup.IC.yc;  setup.IC.th;...
                        setup.IC.dxc; setup.IC.dyc; setup.IC.dth ];
   
eventFunc           = @(t,z) Event_SlideNeg(t,z,setup);
options             = odeset(...
                            'RelTol',setup.tol,...
                            'AbsTol',setup.tol,...
                            'Vectorized','on',...
                            'Events',eventFunc);
userfun             = @(t,z) dynamics_slideNeg(t,z,setup);
sol                 = ode45(userfun,Tspan,IC,options);                     %Run ode45 until termination

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Evaluating the solutions                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Format for post processing
tspan = [sol.x(1),sol.x(end)];
%nTime = ceil(setup.dataFreq*diff(tspan));
nTime            =   setup.dataFreq;

t = linspace(tspan(1),tspan(2),nTime);
Z = deval(sol,t);
[dZ,Zp, Zs, C]  = dynamics_slideNeg(t,Z,setup);

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

data.state.ys        = Zs(1,:);
data.state.dys       = Zs(2,:);

% Contact forces 

data.contact.Fx      = C(1,:);
data.contact.Fy      = C(2,:);

% Parameters

data.p              = setup.p;
disp(['The exit condition for Slide Negative is ', num2str(sol.ie)])

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        State machine                                    %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Get transitions for finite state machine
data.phase = 'SLIDE_NEG';
if isempty(sol.ie)
    data.exit = 'TIMEOUT';
    disp('isempty(sol.ie)')
elseif sol.xe(end) ~= sol.x(end);
    %An event was triggered, but it was non-terminal
    data.exit = 'TIMEOUT';
    
else
    switch sol.ie(end)
        case 1
            data.exit = 'FALL_NEG';
        case 2
            data.exit = 'FALL_POS';
        case 3
            data.exit = 'STUCK';
        case 4
            data.exit = 'FLIGHT';
        case 5
            data.exit = 'FLIGHT';    

        otherwise
            error('Invalid exit condition in simulate flight')
    end
end

end

