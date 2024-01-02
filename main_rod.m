
clearvars -except D
%close all
% latex     % run every time once after openning matlab : This script changes all interpreters from tex to latex. 



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                      Input     Parameters                               %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

p.l             = 0.15;                     % Rod length
p.m             = 1;                        % Rod mass
p.I             = 0 * (p.m * p.l^2);        % Rod inertia ; I have set it to be zero for a mass less rod
p.g             = 10;                       % Gravitational acceleration
%p.R            = 0;                        % Restitution coefficient is set to zero % not used
p.G             = 10;                       % Damping coefficient     



p.acc_support   = p.G*p.g;                 % accelaration  of the  base plate 

p.omega         = 30*2*pi; %  frequency of the motion of the table
p.A             = p.acc_support / (p.omega)^2;  % amplitude of the motion of the table

%f                = 1.5;  % f=2
%f                 =2;  
%f                 =15% 
p.k             = 10;%p.omega^2 *p.m *p.l^2/f^2; %;15; %180 Stiffness of the torsion spring
%p.gamma_factor  = .25; % comparison factor to critical damping
p.gamma         = 0.01;%2*p.l*sqrt(p.k*p.m)*p.gamma_factor;% damping

p.mu            = .4; % Friction coefficient
p.theta_0       = 25 *(pi/180);
p.theta_ic      = p.theta_0;

disp([' Damping time in flight                      = ' num2str(p.gamma / p.k) ]);
disp([' Inverse of  forcing                         = ' num2str(1/p.omega) ]);
disp([' Charecteristic time of the spring and mass  = ' num2str(sqrt(p.m*p.l^2/p.k)) ]);




disp([' For Zooming select the State plot']);
prompt          = "Do you want to zoom into a  region (1(yes) or 0(no)) ";
restart_flag    =   input(prompt);

if isempty(restart_flag)
    restart_flag = 0;
end




if restart_flag == 1; 
    if exist('D','var')
        restart_flag =1;
    else
       restart_flag = 0 ;
    end
end
restart_flag
if restart_flag == 1
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%         Initial Coditions for Restart                  %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    restart(D)
    [setup tstart, tfinal] = initial_restart(D);
    close all
    clear D
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%         Initial Coditions for Bottom of the Stick -- C                  %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
else

tstart          = 0.0;
    tfinal          = 15;
    
    setup.IC.xc     = 0.0;
    setup.IC.yc     = 0.000 + p.A * cos(p.omega*tstart); 
    setup.IC.th     = p.theta_ic;
    
    setup.IC.dxc    = 0;
    setup.IC.dyc    = 0;
    setup.IC.dth    = 0;

    setup.IC.xp      =  setup.IC.xc+p.l*sin(setup.IC.th);
    setup.IC.yp      =  setup.IC.yc+p.l*cos(setup.IC.th);
   

    setup.IC.yc     = 0.000 + p.A * cos(p.omega*tstart); 
    setup.IC.th     = p.theta_0;

    setup.IC.dxp    = 0;
    setup.IC.dyp    = setup.IC.yc;
    setup.IC.dth    = 0;
    end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Parameters for ODE                            %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

ys=p.A*cos(p.omega*tstart);

% pack  parameters into setup 

setup.Tspan     = [tstart, tfinal]; %only used for timeout of the simulation
setup.tol       = 1e-12; %Accuracy of the integration method
setup.dataFreq  = 100; %How much data to return?
setup.refine    = 4;
setup.p = p;


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
D.p = p;

for i = 1:length(D.phase)
    disp([D.phase{i}, '  ->  ', D.code{i}])
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Plot Data                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

flag_line_color     = 2; % phases are color coded (slow)

if flag_line_color == 1

     plotData_phase(D, D1, setup) % phases are color coded (slow)


elseif flag_line_color == 2    % for paper
    
    plotData_phase_paper(D, D1, setup)

else
    
     plotData(D, D1, setup) % no color for the phase

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Save data
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%f_name= strcat('D:\For_andy\codes\Gamma_d_',num2str(p.G));
f_name= strcat('D:\For_andy\codes\Gamma_d_',num2str(p.G),'_low_k_low_mu');
f_name = strrep(f_name,'.','p')
flag_save =0


if flag_save ==1
    
    
    f_name1 = strcat(f_name,'.mat')
    
    save(f_name1,'D','D1')
    
    f_name1 = strcat(f_name,'.svg')
    saveas(gcf,f_name1)
    
    f_name1 = strcat(f_name,'.fig')
    saveas(gcf,f_name1)
end



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                          Animate Data                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

flag_animate = 0; % Animate data (Off : 0 On : 1)

if flag_animate == 1
    
    timeRate    = 0.01; % slow motion < 1 < fast forward
    F=animation(D, D1, timeRate,setup);

flag_animate_save=1

if flag_animate_save==1
  f_name1 = strcat(f_name,'.avi')
  writerObj = VideoWriter(f_name1);
  writerObj.FrameRate = 10;
  open(writerObj);

for i=1:length(F)
    i
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end

close(writerObj);

end



end
