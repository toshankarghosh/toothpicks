function plot_traj_color( D,D1,start_phase )

[COLR]              = plot_color_phase(D);
nPhase              = length(D1.raw);                                      % Total  number of phase changes in the system 



for i = start_phase:nPhase


    data_phase      = D1.raw(i);
    t_phase         = data_phase.time;
    
    % Values  for the lower base C
    xc_phase        = data_phase.state.xc;
    yc_phase        = data_phase.state.yc;
    

    % Values  for the tip P
    xp_phase        = data_phase.state.xp;
    yp_phase        = data_phase.state.yp;

    % Values  for the table  S

    ys_phase        = data_phase.state.ys;

   % phase sensetive colors for line plots  
    colr            = COLR(i, :); % ADDS COLORS TO REPRESENT THE PHASE

    
    
    
   plot(xp_phase, yp_phase,...
       'color', colr,'LineWidth', 3);

   plot(xc_phase, yc_phase,...
       'color', colr,'LineWidth', 3);
   
   hold on
 
end

end