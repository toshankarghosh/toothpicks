function data = simulate_flight(setup)

%This function simulates the flight phase of the dynamics


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Initial Conditions                            %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Set up the integration algorithm

Tspan = setup.Tspan;
t_check=Tspan(1);
time2debug=16.52884456410964;

if(t_check>time2debug)
    disp('hello')
end

setup.IC.dth = -(setup.p.k/setup.p.gamma)*(setup.IC.th -setup.p.theta_0);
%is this always true or only if it is coming from contact phases?
IC = [ setup.IC.xp;  setup.IC.yp;  setup.IC.th;...
       setup.IC.dxp; setup.IC.dyp; setup.IC.dth ];

%IC;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           ODE45                                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
 
eventFunc       = @(t,z)Event_Flight2(t,z,setup);
options         = odeset(...
                        'RelTol',setup.tol,...
                        'AbsTol',setup.tol,...
                        'Vectorized','on',...
                        'Events',eventFunc,'refine',setup.refine);
userfun         = @(t,z)dynamics_flight2(t,z,setup);
sol             = ode45(userfun,Tspan,IC,options);                         %Run ode45 until termination


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Evaluating the solutions                         %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Format for post processing
tspan           = [sol.x(1),sol.x(end)];
%nTime           = ceil(setup.dataFreq*diff(tspan));
nTime            =   setup.dataFreq;
t               = linspace(tspan(1),tspan(2),nTime);                       % create a time array 
Zp               = deval(sol,t);                                            % dval evaluates the solution sol of a differential equation problem at the points contained in t.
[dZ,Zc, Zs, C]  = dynamics_flight2(t,Zp,setup);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Formatting                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Store in a nice format for plotting

data.time       = t;

% Values  for the lower base C

data.state.xc   = Zc(1,:);
data.state.yc   = Zc(2,:);
data.state.th   = Zc(3,:);
data.state.dxc  = Zc(4,:);
data.state.dyc  = Zc(5,:);
data.state.dth  = Zc(6,:);

% Values  for the tip P

data.state.xp   = Zp(1,:);
data.state.yp   = Zp(2,:);
data.state.th  = Zp(3,:);
data.state.dxp  = Zp(4,:);
data.state.dyp  = Zp(5,:);
data.state.dth = Zp(6,:);

% Values  for the table  S

data.state.ys   = Zs(1,:);
data.state.dys  = Zs(2,:);

% Contact forces 

data.contact.Fx = C(1,:);
data.contact.Fy = C(2,:);

% parameters

data.p          = setup.p;

%disp(['The exit condition for Flight is ', num2str(sol.ie)])

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

