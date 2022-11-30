function[ys dys ddys]= Table(t,setup)

omega = setup.p.omega;
A     = setup.p.A;

ys      =  A*cos(omega*t); % motion of the table
dys     = -A*omega*sin(omega*t); % motion of the table
ddys    = -A*omega^2*cos(omega*t); % angular accelaration of the table
end