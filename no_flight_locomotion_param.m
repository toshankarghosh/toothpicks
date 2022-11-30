p.l             = .15; % Rod length
p.m             = 1; % Rod mass
p.I             = 0 * (p.m * p.l^2); % Rod inertia % I have set it to be zero for a mass less rod
p.g             = 10; % Gravitational acceleration
%p.R            = 0; % Restitution coefficient is set to zero % not used
p.G             = .8;    
p.acc_support   = p.G*p.g;     
p.omega         = 30*2*pi; %  frequency of the motion of the table
p.A             = p.acc_support / (p.omega)^2; %0.013; % amplitude of the motion of the table

f                = 2;  
p.k             = p.omega^2 *p.m *p.l^2/f^2; %;15; %180 Stiffness of the torsion spring
p.gamma_factor  = .25; % comparison factor to critical damping
p.gamma         = 2*p.l*sqrt(p.k*p.m)*p.gamma_factor;% damping
p.mu            = .4; % Friction coefficient
p.theta_0       = 35 *(pi/180);
