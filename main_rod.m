% data structure
% setup.p  : Stores the  physical parameters  of the rod (m, l, ..),  the vibratiing plate (A, omega,), torsional spring (k, gamma, )
%  are stored in the structure  
% 
% setup.IC : Stores the initial Coditions for Bottom and top  of the Stick 
% 
% 
% setup.Tspan   : stores the  initial and the final time 

    





clearvars 



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                      Input     Parameters                               %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

setup.p.l             = 0.15;                     % Rod length
setup.p.m             = 1;                        % Rod mass
setup.p.I             = 0 * (setup.p.m) * (setup.p.l)^2;        % Rod inertia ; I have set it to be zero for a mass less rod
setup.p.g             = 10;                       % Gravitational acceleration
%setup.p.R            = 0;                        % Restitution coefficient is set to zero % not used
setup.p.G             = 10;                       % Accelaration of the plate in units of g      


setup.p.acc_support   = (setup.p.G)*(setup.p.g);                 % accelaration  of the  base plate 

setup.p.omega         = 30*2*pi; %  frequency of the motion of the table
setup.p.A             = (setup.p.acc_support) / (setup.p.omega)^2; %0.013; % amplitude of the motion of the table


setup.p.k             = 10  ; %Stiffness of the torsion spring
setup.p.gamma         = 0.01; % damping associated with the   rotational motion of the rod
setup.p.mu            = 0.4 ; % Friction coefficient


% at equilibrium, we expect that k(theta_f_exp-theta_0)=mgl sin(theta_f_exp)
setup.p.theta_f_exp    = 0.5; %expected equilibrium angle
setup.p.theta_0              = (setup.p.theta_f_exp)-...
                         (setup.p.m)*(setup.p.g)*(setup.p.l)*...
                          sin(setup.p.theta_f_exp)/(setup.p.k);%angle of the rod when no force is applied



disp([' Damping time in flight                      = ' num2str(setup.p.gamma / setup.p.k) ]);
disp([' Inverse of  forcing                         = ' num2str(1/setup.p.omega) ]);
disp([' Charecteristic time of the spring and mass  = ' num2str(sqrt((setup.p.m)*(setup.p.l)^2/(setup.p.k))) ]);








% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% %         Initial Coditions for Bottom of the Stick -- C                  %
% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
 
    tstart          = 0.0;
    tfinal          = 1;
    

    setup.IC.xc     = 0.0;
    setup.IC.yc     = 0.000 + (setup.p.A) * cos((setup.p.omega)*tstart); 
    setup.IC.th     = setup.p.theta_0;
    
    setup.IC.dxc    = 0;
    setup.IC.dyc    = 0;
    setup.IC.dth    = 0;


    setup.IC.yc     = 0.000 + (setup.p.A) * cos(setup.p.omega*tstart); 
    setup.IC.th     = setup.p.theta_0;

    setup.IC.dxp    = 0;
    setup.IC.dyp    = setup.IC.yc;
    setup.IC.dth    = 0;

% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% %         Initial Coditions for Top of the Stick -- P                     %
% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    setup.IC.xp      =  (setup.IC.xc) + (setup.p.l)*sin(setup.IC.th);
    setup.IC.yp      =  (setup.IC.yc) + (setup.p.l)*cos(setup.IC.th);
   



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Parameters for ODE                            %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

      ys      =     (setup.p.A)*cos((setup.p.omega)*tstart);

% pack  parameters into setup 

setup.Tspan     = [tstart, tfinal]; % Initial and final time 
setup.tol       = 1e-12; %Accuracy of the integration method
setup.dataFreq  = 100; %How much data to return?
setup.refine    = 4;



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Select Phase                                   %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Figure out which phase the simulation starts in

setup           = selectPhase(setup,ys); %{'SLIDE','HINGE','FLIGHT'}
phase           = setup.phase;


% Maximum number of phase changes
N_max           = 1500;

%% 


for i = 1:N_max
%     disp(['State change Number : ', num2str(i)])
    switch phase
        case 'HINGE'
            data = simulate_hinge(setup);
        case 'FLIGHT'
            data = simulate_flight(setup);
        case 'SLIDE_POS'
            data = simulate_slidePos(setup);
        case 'SLIDE_NEG'
            data = simulate_slideNeg(setup);
        otherwise

            error('Invalid phase')
    end
    
%  Pack data between consecutive phase changes into D1

    D1.raw(i)       = data;
    D.phase{i}      = phase;
    D.code{i}       = data.exit;

    [phase, setup]  = fsm(phase, setup, data);

    if strcmp(phase, 'ABORT')
        break;
    end
end

%%%% Post processing and analysis %%%%

[D.data, D.Jumps, D.JumpIdx] = stitchData(D1.raw);

for i = 1:length(D.phase)
    disp([D.phase{i}, '  ->  ', D.code{i}])
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Plot Data                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%


    
 plotData_phase_paper(D, D1, setup)
 
     


