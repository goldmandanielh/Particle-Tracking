function [g, t, taStr]=acFromTAS(taStr, nChannel, nRepeat, verbose)
%Obj: given the amplitude in a taStr, calculate the autocorrelation
%functions for each track and the weighted average
%Input Para
%   taStr: track analysis structure arrays
%   nChannel: # of channel used in multi tau correlator
%   nRepeat: # of repeats to do multi tau correlation, together with
%            nChannel, determine the total # of time points for correlation
%   verbose: to plot or not
%Output Para
%   g: the correlation function, weighted averaged
%   t: the time to calculate the correlation function
%   taStr: the track analysis structure with ac, acw filled. 
%Version & History
%   Bin Wu: 08/20/2018
%           08/22/2018: change the name from acFromTracks to acFromTAS. Do
%               not calculate the mean here, instead use the one stored in
%               each trace. So we can average ac from different cells, even
%               the mean intensity could be different between different
%               cells. 
%               

if nargin < 2
    nChannel=16;
end
if nargin < 3
    nRepeat=6;
end
if nargin <4
    verbose=1;
end

nTracks=length(taStr);  
if nTracks==0
    g=[];
    t=[];
    taStr=[];
    return
end
%avg=mean(horzcat(taStr.amp)); %global mean intensity
for i=1:nTracks
    amp=taStr(i).amp;
    avg=taStr(i).avg;   %Note the default value was set to global mean
    %[gt,t,w]=linCorrGM(amp,amp,nT,avg,avg);
    [gt,t, w]=multiTauCorrGM(amp,amp, nChannel, nRepeat, avg, avg);
    taStr(i).ac=gt;
    taStr(i).acw=w; %(lenT-1):(-1):(lenT-nT);
end
acw=vertcat(taStr.acw); 
ac=vertcat(taStr.ac); 
g=nansum(ac.*acw,1)./nansum(acw,1);
if verbose
    plot(t, g, '-go');
end
end