phase{1}='FLIGHT';
phase{2}='HINGE';
phase{3}='SLIDE_POS';
phase{4}='SLIDE_NEG';


for i = 1:4
    phase{i}
Index = find(contains(D.phase,phase{i}));
time(i)=0;


if ~isempty(Index)
for ii = 1:  length(Index)
    time(i) = time(i)+(D.Jumps(Index(ii)+1)-D.Jumps(Index(ii)));
end
end

end
delta_t= D.data.time(end)-D.data.time(1);
X = categorical({'FLIGHT','HINGE','SLIDE POS','SLIDE NEG'});
X = reordercats(X,{'FLIGHT','HINGE','SLIDE POS','SLIDE NEG'});



bar(X,time/delta_t);
