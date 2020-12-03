function res=trackMSD(track)
[x,y,a,t]=extractCoordinateAmpFromTrack(track);
nd=length(x);
res=zeros(nd,1);
for i=0:(nd-1)
    res(i+1)=nanmean((x((i+1):nd)-x(1:(nd-i))).^2+(y((i+1):nd)-y(1:(nd-i))).^2);
end
end
