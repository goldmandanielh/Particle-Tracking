function [resMsd, stdMsd, amps, stdPos, nValid]=tracksExtractMSD(tracks, nT, showResult)
%   Use the tracks variable obtained from utrack to 
%calculate the mean square displacement
%   tracks: the tracks variable obtained from utrack
%   nT: the length of the movie
%   minTrackLen: minimum track length to consider
%   nValid: the number of valid segment to calculate the msd.

nTracks=length(tracks);
resMsd=nan(nT,nTracks);
stdMsd=nan(nT,nTracks);
amps=zeros(nTracks,1);
stdPos=zeros(nTracks,1);
nValid=zeros(nT, nTracks);
if nargin<3
    showResult=0;
end
for n=1:nTracks
    [x,y,a,t]=extractCoordinateAmpFromTrack(tracks(n));
    nd=length(x);
    msd=zeros(nd,1);
    stdTemp=zeros(nd,1);
    for i=0:(nd-1)
        nValid(i+1, n)=min([length(find(~isnan(x((i+1):nd)))) length(find(~isnan(x(1:(nd-i)))))])-1;
        dummy=(x((i+1):nd)-x(1:(nd-i))).^2+(y((i+1):nd)-y(1:(nd-i))).^2;
        msd(i+1)=nanmean(dummy);
        stdTemp(i+1)=nanstd(dummy,0);
    end
    amps(n)=nanmean(a);
    stdPos(n)=sqrt(nanstd(x)^2+nanstd(y)^2);
%     amps(n)=nanmax(a);
    ntmp=min([nd nT]);    
    resMsd(1:ntmp,n)=msd(1:ntmp);
    stdMsd(1:ntmp,n)=stdTemp(1:ntmp);
end
if showResult==1
    plot(nanmean(resMsd,2));
    % plot(nansum(resMSD.*nValid,2)/nansum(nValid,2))
end
end