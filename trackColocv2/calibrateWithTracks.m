function [transformPara]=calibrateWithTracks(tracksR, tracksG, co, imageGap, thresh)
nc=size(co,1);
posRef=zeros(2*nc,2);   %use the beginning and the end of the track to calibrate
posTrans=zeros(2*nc,2);
for i=1:nc
    [overlapIndx, posR, posG]=trackOverlapTimePos(tracksR(co(i,1)), tracksG(co(i,2)), imageGap);
    posRef(2*i-1, :)=posR(overlapIndx(1),:);
    posTrans(2*i-1, :)= posG(overlapIndx(1),:);
    posRef(2*i, :)=posR(overlapIndx(end),:);
    posTrans(2*i, :)= posG(overlapIndx(end),:);
end
[transformPara]=calibrateChannel(posTrans, posRef, thresh,1);
end