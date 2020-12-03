function selTracks=selTracksInROI(tracks, bwMask)
nTr=length(tracks);
indSel=zeros(nTr,1);
[sy,sx]=size(bwMask);
for i=1:nTr
    [x,y,a,t]=extractCoordinateAmpFromTrack(tracks(i));
    ind=sy*(ceil(x)-1)+round(y);   %The position in the array
    indSel(i)=sum(bwMask(ind(~isnan(ind))));
end
selTracks=tracks(indSel > 0);
end