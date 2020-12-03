function taStr=taGetTracksAmp(tracks)
%obj: set up the analysis structures and calculate the amplitude for each
%track
%Input Para:
%   tracks: the tracks array
%Output Para:
%   taStr: A structure to store the analysis result for each track,
%               containing {amp, avg, ac, acw} fields
%               only the amplitude is filled in this function. 
%Version
%   Bin Wu, 08/20/2018
%           08/22/2018: set the mean intensity of each trace as the global mean

nTr=length(tracks);
taStr=repmat(struct('amp', [], ...       %amplitude, varialbe size, 1xn
                           'avg',0, ...         %global mean amplitude, scalar
                           'ac', [],...         %autocorrelation, 1:nT
                           'acw', []), ...      %weight, 1:nT
                           nTr, 1);  
for i=1:nTr
    ampG=getTrackAmpInterpGap(tracks(i));
    taStr(i).amp=ampG;   %set to 1xn array;
end
taStr=taSetMeanAmp(taStr);  %set the mean intensity of each trace as the global mean
end