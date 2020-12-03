function plotTracksRG(trackR, trackG, para)
if nargin<3
    para=[0,0,0,0,0,0];
end
[xr,yr,ar,tr]=extractCoordinateAmpFromTrack(trackR);
[xg,yg,ag,tg]=extractCoordinateAmpFromTrack(trackG);
posG=[xg', yg'];
posGTrans=transformXY(para, posG);
plot(xr,yr,'-ro'); hold on; plot(posGTrans(:,1),posGTrans(:,2),'-gs'); hold off;
end