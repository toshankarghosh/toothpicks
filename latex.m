%%  makes latex the default interpreter 
%% This part of the code is sourced from  the response of Max Bartholdt
%% https://in.mathworks.com/matlabcentral/answers/183311-setting-default-interpreter-to-latex



function latex()

list_factory = fieldnames(get(groot,'factory'));
     index_interpreter = find(contains(list_factory,'Interpreter'));

     for i = 1:length(index_interpreter)
     
         default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
         set(groot, default_name,'latex');
     
     end
     
end
