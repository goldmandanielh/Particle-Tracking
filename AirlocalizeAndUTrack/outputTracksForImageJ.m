function outputTracksForImageJ(tracks, savePath)
fid=fopen(savePath, 'w');
nTracks=length(tracks);
fprintf(fid,'%u\r\n', nTracks);     %# of tracks
for i=1:nTracks
    [x,y,a,t]=extractCoordinateAmpFromTrack(tracks(i));
    obsAvail=find(~isnan(x));
    x=x(obsAvail);
    y=y(obsAvail);
    fprintf(fid,'%u,  ', length(x));    %How many time points in the track
    fprintf(fid,'%u, %f, %f,  ', [t(:) x(:) y(:)]');    %Frame#, x, y
    fprintf(fid,'\r\n');
end
fclose(fid);
end