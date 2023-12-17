function [nextPhase, setup] = fsm(phase, setup, data)

%This function handles switching between the various continuous dynamics
%phases.

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Parameters                                    %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

m       = setup.p.m;
g       = setup.p.g;
mu      = setup.p.mu;
L       = setup.p.l;
I       = setup.p.I;
K       = setup.p.k;
theta_0 = setup.p.theta_0;
delta_h  = 1e-9;  % to ensure that the event function for flight does not start with a negative value

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack Z                                      %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

code    = data.exit;
xc      = data.state.xc(end);
yc      = data.state.yc(end);
th      = data.state.th(end);
dxc     = data.state.dxc(end);
dyc     = data.state.dyc(end);
dth     = data.state.dth(end);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack Zs                                     %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

ys      = data.state.ys(end);
dys     = data.state.dys(end);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Unpack Zp                                     %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

xp  = data.state.xp(end);
yp  = data.state.yp(end);
dxp = data.state.dxp(end);
dyp = data.state.dyp(end);

%disp([yc, dyc, yp, dyp, ys, dys])

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Time                                          %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

setup.Tspan(1) = data.time(end);
t              = setup.Tspan(1);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Define Vecs                                   %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

vec_rcp   = [sin(th), cos(th), 0]' * L;                                     %POSITION VECTOR OF THE STICK CP
vec_vp    = [dxp, dyp, 0]';                                                 %VELOCITY VECTOR OF P
vec_vs    = [0, dys, 0]';                                                   %VELOCITY VECTOR OF TABLE
vp_rel    = [dxp, dyp - dys];
er        = [sin(th), cos(th)];                                             % UNIT VECTOR  ALONG THE LENGTH OF THE STICK
dxc_prov  = dxp + (dyp - dys) * cot(th);



if strcmp(code, 'TIMEOUT')

    nextPhase = 'ABORT';
    %setup = [];
    return;
end


switch phase

    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    %                           case 'HINGE'                                  %
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    case 'HINGE'

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                           NEXT PHASE                                    %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

        switch code

            case 'SLIP_POS'                                                %\mu F_y + F_x >0

                if abs(th)< 1e-9   % to take care of the 1/sin(th)  sigularituy

                    nextPhase = 'FLIGHT';

                else

                    nextPhase = 'SLIDE_POS';

                end


            case 'SLIP_NEG'                                                %\mu F_y - F_x >0

                nextPhase = 'SLIDE_NEG';                                   %F_y >0

            case 'LIFT'

                nextPhase = 'FLIGHT';
                yc        = ys + delta_h;  
                yp = yc + L*cos(th); %new added
                % INITIAL CONDITION
                % th        = theta_0;   % INITIAL CONDITION
                % dth       = 0;         % INITIAL CONDITION
                % dyc       = dyp;       % ANDY THINKS (?)                                          % INITIAL CONDITION


            case {'FALL_POS', 'FALL_NEG'}

                nextPhase = 'ABORT';

            otherwise

                error('Invalid code in FSM')
        end

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                           case 'FLIGHT'                                 %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    case 'FLIGHT'

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                           NEXT PHASE                                    %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

        switch code

            case 'STRIKE_0'                                                % h_c =0

          

                if (tan(th) <= mu)                                    %  CHECK FOR HIGH FRICTION

                    if (dot(vp_rel, er) < 0)                               %  CHECK FOR ROD ROD SHORTENING

                        dxc        = 0;                                    % INITIAL CONDITION
                        dyc        = dys;                                  % INITIAL CONDITION
                        vec_dtheta = cross(vec_rcp, ( vec_vs-vec_vp )) / L^2;
                        dth        = vec_dtheta(3);
                        dxp        =  L * (cos(th) .* dth);
                        dyp        = dys - L * (sin(th) .* dth);

                        % provisional calculate reaction force for hinge.

                        zeta            = [xc; yc; th; dxc; dyc; dth];
                        [~, ~, ~, C]    = dynamics_hinge(t,zeta,setup);
                        Fy              =  C(2,:);
                        Fx              =  C(1,:);
                        if  Fy > 0
                            if  abs(Fx)<mu*Fy  % positive ground reaction
                                nextPhase  = 'HINGE';
                            elseif Fx >0
                                nextPhase  = 'SLIDE_NEG';
                                
                            else
                                nextPhase  = 'SLIDE_POS';
                            end
                        else         % tensional ground reaction implies flight
                            nextPhase  = 'FLIGHT';
                            yc        =  ys + delta_h;
                            yp        =  yc + L*cos(th); %new added
                            
                            %disp(strcat('Entering Flight Phase  ',num2str(dth),'  ', num2str(dxp),'  ',num2str(dyp)))
                        end


                    else           % rod not shortening

                        if (dxc_prov > 0) % check sliding right

                            nextPhase = 'SLIDE_POS';
                            dxc       = dxc_prov; % INITIAL CONDITION
                            dyc       = dys;      % INITIAL CONDITION
                            dth       = -(dyp - dys) / (L * sin(th)); % INITIAL CONDITION

                        else %  slides left

                            dxc       = dxc_prov; % INITIAL CONDITION
                            dyc       = dys;      % INITIAL CONDITION
                            dth       = -(dyp - dys) / (L * sin(th)); % INITIAL CONDITION

                            disp('Slide neg')

                        end %  END CHECKING FOR SLIDING RIGHT
                    end     %  END  CHECKING FOR ROD SHORTENING

                else        %   END  CHECKING FOR FRICTION STATE


                    if (dxc_prov > 0)         %  check for slide right

                        nextPhase = 'SLIDE_POS';
                        dxc       = dxc_prov;
                        dyc       = dys;
                        dth       = -(dyp - dys) / (L * sin(th));

                    else                        % slide left

                        nextPhase = 'SLIDE_NEG';
                        dxc       = dxc_prov;
                        dyc       = dys;
                        dth       = -(dyp - dys) / (L * sin(th));


                    end % check for sliding direction
                end % end of high friction check


            case 'STRIKE_2'
                nextPhase = 'ABORT';

            otherwise
                error('Invalid code in FSM')
        end                 % end switch code

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                           case 'SLIDE_POS'                              %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    case 'SLIDE_POS'

        switch code

            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

            case 'STUCK'


                Flag = 0;
                zeta            = [xc; ys; th; 0; dys; dth];
                [~, ~, ~, C]    = dynamics_hinge(t,zeta,setup);
                Fx              =  C(1,:);
                Fy              =  C(2,:);
                if  mu*Fy >= abs(Fx)   % positive ground reaction
                    nextPhase  = 'HINGE';
                    dxc       = 0;
                    yc        = ys;
                    Flag = 1;
                end

                if Flag==0
                    zeta            = [xc; ys; th; dxc; dys; dth];
                    [~, ~, ~, C]    = dynamics_slideNeg(t,zeta,setup);
                    Fx              =  C(1,:);
                    Fy              =  C(2,:);

                    if Fy > 0
                        nextPhase  = 'SLIDE_NEG';
                        yc         = ys;
                        dyc        = dys;
                    else
                        nextPhase  = 'ABORT';
                    end
                end



                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

            case 'FLIGHT'

                nextPhase = 'FLIGHT';
                yc        = ys + delta_h; % INITIAL CONDITION
                yp = yc + L*cos(th); %new added
                %   th        = theta_0;   % INITIAL CONDITION
                %   dth       = 0;         % INITIAL CONDITION
                %   dyc       = dyp;       % ANDY THINKS (?)


                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%


            case {'FALL_POS', 'FALL_NEG'}

                nextPhase = 'ABORT';

            otherwise

                error('Invalid code in FSM')
        end

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                           case 'SLIDE_Neg'                              %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    case 'SLIDE_NEG'

        switch code

            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

            case 'STUCK'
                zeta            =  [xc; ys; th; 0; dys; dth];
                [~, ~, ~, C]    =  dynamics_hinge(t,zeta,setup);
                Fx              =  C(1,:);
                Fy              =  C(2,:);
                Flag            =  0;

                if  mu*Fy >= abs(Fx)   % positive ground reaction
                    nextPhase  = 'HINGE';
                    dxc       = 0;
                    yc        = ys;
                    Flag      = 1;
                end

                if Flag == 0
                    zeta            = [xc; yc; th; dxc; dyc; dth];
                    [~, ~, ~, C]    = dynamics_slidePos(t,zeta,setup);
                    Fx              =  C(1,:);
                    Fy              =  C(2,:);
                    %disp([ Fx      Fy])


                    if Fy > 0
                        nextPhase  = 'SLIDE_POS';
                        yc         = ys;
                        dyc        = dys;
                    else
                        nextPhase  = 'ABORT';

                    end
                end



                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            case 'FLIGHT'

                nextPhase = 'FLIGHT';
                yc        = ys + delta_h; % INITIAL CONDITION
               yp = yc + L*cos(th); %new added
               %  th        = theta_0;   % INITIAL CONDITION
                %  dth       = 0;         % INITIAL CONDITION
                %  dyc       = dyp;       % ANDY THINKS (?)

            case {'FALL_POS', 'FALL_NEG'}

                nextPhase = 'ABORT';

            otherwise

                error('Invalid code in FSM')
        end


end



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                           Assign Initial Conditions                              %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

setup.IC.xc  = xc;
setup.IC.yc  = yc;
setup.IC.th  = th;
setup.IC.dxc = dxc;
setup.IC.dyc = dyc;
setup.IC.dth = dth;
setup.IC.xp  = xp;
setup.IC.yp  = yp;
setup.IC.dxp = dxp;
setup.IC.dyp = dyp;
setup.IC.ys  = ys;
setup.IC.dys = dys;

end
