function [tracksNew, tracksNewSEL]=tracksSortByLength(tracksOld)
%Obj: sort the tracks according to the its lifetime
nT=length(tracksOld);
tracksSELOld=getTrackSEL(tracksOld); %[start, end, length]
[~, ind]=sort(tracksSELOld(:,3),'descend');
tracksNew=tracksOld(ind);
tracksNewSEL=tracksSELOld(ind,:);
end