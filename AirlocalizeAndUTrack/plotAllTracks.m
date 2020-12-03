function plotAllTracks(tracks,opt, atmat)
if nargin<2
    opt='r';
end
if nargin<3
    atmat=[1,0,0 0];    %affine transformation matrix
end
nTr=length(tracks);
i=1;
while i<=nTr
    [x,y,a,t]=extractCoordinateAmpFromTrack(tracks(i));
    xy1=affineTransformXY(atmat, [x(:) y(:)],1);
    x=xy1(:,1);
    y=xy1(:,2);
    %draw gaps
    obsAvail=find(~isnan(x));
    plot(x(obsAvail),y(obsAvail),'w:');
    hold on
    plot(x, y,opt);
    i=i+1;
end
end