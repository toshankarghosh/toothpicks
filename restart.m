function [] = restart(D)

% disp('Click on a plot with that has time on the x axis to get the ')
% disp('values of the state variable')
% 
% dcmObject       = datacursormode;
%
% msgbox('Click on the plot')
% [x y] = ginput(1);
% disp([x y])
% idx = knnsearch([t] ,[x]);

 disp('Zoom the  plot that has time on the x axis to get the ')
 disp('values of the state variable')

 

 
 
 t      = D.data.time;

T_range =   get(gca,'Xlim');


% T_range(1) = 0.4869910508;
% T_range(2) = 0.4869910516;

idx     =   knnsearch([t] , [T_range(1)]);



 tstart  =  D.data.time(idx);
 tfinal  =  T_range(2);

% tstart=T_range(1);
% tfinal=T_range(1)+1e-3;


%  if (abs(tstart-tfinal) < 1e-9)
%      disp ('zoom out')
%      error('Zoom  made t_start == t_final')
%  end

xc      =  D. data.state.xc(idx);  
yc      =  D. data.state.yc(idx);  
th      =  D. data.state.th(idx);  

dxc    =  D. data.state.dxc(idx);  
dyc    =  D. data.state.dyc(idx);  
dth    =  D. data.state.dth(idx);  


fid = fopen('initial_restart.m','w');
fprintf(fid,'function  [setup, tstart, tfinal] = initial_restart(D)\n');
fprintf(fid,'%% GENERATED INITIAL CONDITIONS FROM A PREVIOUS RUN \n');
fprintf(fid,'%% This function was generated from the mouse click\n');
tstart
fprintf(fid,['tstart        = ' num2str(tstart) ';\n'])
fprintf(fid,['tfinal        = ' num2str(tfinal) ';\n']);
fprintf(fid,['setup.IC.xc   = ' num2str(xc) ';\n']);
fprintf(fid,['setup.IC.yc   = ' num2str(yc) ';\n']);
fprintf(fid,['setup.IC.th   = ' num2str(th) ';\n']);
fprintf(fid,['setup.IC.dxc  = ' num2str(dxc) ';\n']);
fprintf(fid,['setup.IC.dyc  = ' num2str(dyc) ';\n']);
fprintf(fid,['setup.IC.dth  = ' num2str(dth) ';\n']);
fprintf(fid,'\nend\n');
fclose(fid);


end
