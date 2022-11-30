function [COLR] = plot_color_phase(D)
clear COLR
Data    = D.data;
time    = D.data.time;
JumpIdx = D.JumpIdx;

for i = 1:length(D.JumpIdx) -1
    phase = D.phase{i};
    switch phase
        case 'HINGE'
            color = [255    0  0 ]/255	;
        case 'SLIDE_POS'
            color = [64   255  0 ]/255	;
        case 'SLIDE_NEG'
            color = [0     0  255]/255	;
        case 'FLIGHT'
            color = [255  190  0 ]/255	;
        otherwise
            color = [0, 0, 0];
    end
        COLR(i, :) = color;
end

end
