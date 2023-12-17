function setup = selectPhase(setup,ys)

%Initialize conditions
valid.hinge = false;
valid.slidePos = false;
valid.slideNeg = false;
valid.flight = false;
setup.phase = 'STOP';

%Check hinge
% IC = [setup.IC.th;
%     setup.IC.dth];
IC = [setup.IC.xc; setup.IC.yc; setup.IC.th; ...
    setup.IC.dxc; setup.IC.dyc; setup.IC.dth];

eventFunc = @(t, z)Event_Hinge(t, z, setup);
val = feval(eventFunc, setup.Tspan(1), IC);
if sum(val < 0) == 0 && sum(isnan(val)) == 0
    if (abs(setup.IC.yc -ys)) <1e-9 && ...
            abs(setup.IC.dxc) <1e-9 && ...
            abs(setup.IC.dyc) < 1e-9
        valid.hinge = true;
    end
end

%Check flight
IC = [setup.IC.xp; setup.IC.yp; setup.IC.th; ...
    setup.IC.dxp; setup.IC.dyp; setup.IC.dth];


eventFunc = @(t, z)Event_Flight(t, z, setup);
val = feval(eventFunc, setup.Tspan(1), IC);

if sum(val < 0) == 0 && sum(isnan(val)) == 0
    valid.flight = true;
end


%Check sliding positive
IC = [setup.IC.xc; setup.IC.yc; setup.IC.th; ...
    setup.IC.dxc; setup.IC.dyc; setup.IC.dth];

eventFunc = @(t, z)Event_SlidePos(t, z, setup);
val = feval(eventFunc, setup.Tspan(1), IC);
if sum(val < 0) == 0 && sum(isnan(val)) == 0
    if abs(setup.IC.yc)<1e-9 && ...
           abs(setup.IC.dyc)<1e-9
        valid.slidePos = true;
    end
end


%Check sliding negative
IC = [setup.IC.xc; setup.IC.yc; setup.IC.th; ...
    setup.IC.dxc; setup.IC.dyc; setup.IC.dth];

eventFunc = @(t, z)Event_SlideNeg(t, z, setup);
val = feval(eventFunc, setup.Tspan(1), IC);
if sum(val < 0) == 0 && sum(isnan(val)) == 0
    if abs(setup.IC.yc)<1e-9 && ...
          abs(setup.IC.dyc)<1e-9
        valid.slideNeg = true;
    end
end

%Now pick the right case:
if valid.hinge
    setup.phase = 'HINGE';
elseif valid.slidePos
    setup.phase = 'SLIDE_POS';
elseif valid.slideNeg
    setup.phase = 'SLIDE_NEG';
elseif valid.flight
    setup.phase = 'FLIGHT';
else
    setup.phase = 'STOP';
    disp('No valid phase found');
end


end
