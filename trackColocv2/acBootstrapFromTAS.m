function [gstd, g, t]=acBootstrapFromTAS(taStr, nChannel, nRepeat, nBootstrap, nSample)
nTracks=length(taStr);
if nargin < 2
    nChannel=16;
end
if nargin<3
    nRepeat=6;
end
if nargin<4
    nBootstrap=1000;
end
if nargin<5
    nSample=floor(nTracks/2);
end
if nBootstrap<=2
    disp('acBootstrapFromTracks: insufficient data');
    gstd=[];
    return;
end
[g, t]=acFromTAS(taStr, nChannel, nRepeat, false);  %No plotting
gTot=repmat(g*0, nBootstrap, 1);
% gTot2=g*0;

for i=1:nBootstrap
    ind=randperm(nTracks, nSample);
    gTot(i,:)=acFromTAS(taStr(ind), nChannel, nRepeat, false);    %Note: the mean intensity has been assigned and used in each single trace
end
g=nanmean(gTot,1);
gstd=nanstd(gTot,0,1);
% g=gTot/nBootstrap;
% gstd=sqrt((gTot2-gTot.^2/nBootstrap)/(nBootstrap-1));
end