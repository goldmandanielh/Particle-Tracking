function [x,y,amp,t]=extractCoordinateAmpFromTrack(track)
startTime=track.seqOfEvents(1,1);
endTime=track.seqOfEvents(end,1);

indx=1:8:8*(endTime-startTime)+1;
x=track.tracksCoordAmpCG(1,indx);
y=track.tracksCoordAmpCG(1,indx+1);
amp=track.tracksCoordAmpCG(1,indx+3);
obsAvailable=find(~isnan(x));
tt=startTime:endTime;
t=tt(obsAvailable);

end