function taStr=taGetCoTracksAmp(tGCo, tRCo, imageGap, trackingGAP, transformPara, stackG, localizeParaG)
%obj: set up the analysis structures and calculate the amplitude for each
%   colocalized track
%Input Para:
%   tGCo, tRCo: the green and red colocalized tracks, must be ordered
%   imageGap: the different image interval between green and red
%   trackingGAP: the tracking GAP paramter used in the u-track
%   transformPara: the transformation parameter 
%   stackG: the green images
%   localizeParaG: the localization paramters used in the airLocalize
%Output Para:
%   taStr: A structure to store the analysis result for each track,
%               containing {amp, avg, ac, acw} fields
%               only the amplitude is filled in this function. 
%Version
%   Bin Wu, 08/20/2018
%           08/22/2018: set the mean intensity of each trace as the global mean

nCo=length(tGCo);
taStr=repmat(struct('amp', [], ...       %amplitude, varialbe size
                           'avg',0, ...         %global mean amplitude from all tracks, scalar
                           'ac', [],...         %autocorrelation, 1:nT
                           'acw', []), ...      %weight, 1:nT
                           nCo, 1);  
for i=1:nCo
    ampG=trackColocAmp(tRCo(i), tGCo(i), imageGap, transformPara, true, trackingGAP, stackG, localizeParaG);
    taStr(i).amp=ampG';   %set to 1xn array;
end
taStr=taSetMeanAmp(taStr);  %set the mean intensity of each trace as the global mean

end