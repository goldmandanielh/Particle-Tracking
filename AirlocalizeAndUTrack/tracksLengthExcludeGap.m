function len=tracksLengthExcludeGap(tracks)
nTr=length(tracks);
len=zeros(nTr,1);
for i=1:nTr
    [x,y,a,t]=extractCoordinateAmpFromTrack(tracks(i));
    len(i)=length(find(~isnan(x)));
end

end