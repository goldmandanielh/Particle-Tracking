function [ampG, ampR, indxGAll, indxRAll]=trackColocAmp(trackR, trackG, imageGap, transformPara, doInterp, trackingGAP, stackG, localizeParaG, stackR, localizeParaR)
%Obj:
%   Extract amplitude of colocalized tracks, 
%   Due to difference interval, we only need to calculate ampG(1:nT),

%Input
%   trackR, trackG: the red (RNA) and green (protein) track
%   imageGap: the difference between image interval
%   transformPara: the color registration transformaiton parameters
%   doInterp: logical variable for whether to do interpolation for missing data
%   trackingGAP: the Gap paramter in utrack to for linking

if nargin < 3
    imageGap=1;
end
if nargin<4
    transformPara=zeros(6,1);
end

if nargin<5
    doInterp=true;
end

if nargin<6
    trackingGAP=4;
end

%overlapIndx containing overlaping indx between R and G, indxR and indxG
%contain the nonNan time point in the time frame of the track. Pos contain
%the positions, sel(start,end,length). The real time of the image is
%indx+start-1;
[overlapIndx, posR, posG, sel, indxR, indxG, ampR, ampG]=trackOverlapTimePos(trackR, trackG,  imageGap);
nT=sel(3);
indxGAll=1:nT;
% ampG=NaN(nT,1);
% ampG(indxG)=trackG.tracksCoordAmpCG(1,4:8:end);     %put in the available amplitude data directly in
if ~doInterp
    return
end
indxGNan=setdiff(indxGAll, indxG);  %index of green channel that is empty
numGNan=length(indxGNan);
for i=1:numGNan
    ind=indxGNan(i);
    %Find in the indxG that bracket the ind
    indGL=max(indxG(indxG<ind));
    indGU=min(indxG(indxG>ind));
    if ~isempty(indGL) && ~isempty(indGU) && indGU-indGL <= trackingGAP+1  %The ind is between two points
        %if the missing green data points is in a tracking GAP, do interpolation
        ampG(ind)=interp1([indGL, indGU],ampG([indGL, indGU]), ind);
    else %use the red channel to fill the gap
        %find the red channel position that is right before this time point
        indRL=max(indxR(indxR<=ind));   %Note it shouble be impossible that indRL does not exist
        posRL=posR(indRL,:);
        posGL=inverseTransformXY(transformPara, posRL);
        %Use Gaussian mask algorithm to find the background intensity of that spot %(should be close to background)
        ampG(ind)=spotIntensityNoIteration(stackG(:,:,sel(1)+ind-1),posGL(1), posGL(2), localizeParaG.cutsize, localizeParaG.thickness, localizeParaG.sigma_xy); 
    end    
end
%calculate the red channel amplitude only when needed
if nargout > 1
    % ampR=NaN(nT,1);
    % ampR(indxR)=trackR.tracksCoordAmpCG(1,4:8:end);     %put in the available amplitude data directly in
    indxRAll=(1:imageGap:nT)+mod(imageGap+1-mod(sel(1),imageGap), imageGap);    %index of the red channel in the overall track time frame
    indxRAll=indxRAll(indxRAll <= nT);
    indxRNan=setdiff(indxRAll, indxR);  %index of red channel that is empty 
    numRNan=length(indxRNan);
    for i=1:numRNan
        ind=indxRNan(i);
        %Find in the indxR that bracket the ind
        indRL=max(indxR(indxR<ind));
        indRU=min(indxR(indxR>ind));
        if ~isempty(indRL) && ~isempty(indRU) && (indRU-indRL)/imageGap <= trackingGAP+1  %The ind is between two points
            %if the missing red data points is in a tracking GAP, do interpolation
            ampR(ind)=interp1([indRL, indRU],ampR([indRL, indRU]), ind);
        else %use the green channel to fill the gap
            %find the green channel position that is right before this time point
            indGL=max(indxG(indxG<=ind));   %Note it shouble be impossible that indRL does not exist
            posGL=posG(indGL,:);
            posRL=transformXY(transformPara, posGL);
            %Use Gaussian mask algorithm to find the background intensity of that spot %(should be close to background)
            %ampR(ind)=spotIntensityNoIteration(stackR(:,:,(sel(1)+ind+1)/imageGap),posRL(1), posRL(2), localizeParaR.cutsize, localizeParaR.thickness, localizeParaR.sigma_xy); 
            ampR(ind)=spotIntensityNoIteration(stackR(:,:,ceil((sel(1)+ind-1)/imageGap)),posRL(1), posRL(2), localizeParaR.cutsize, localizeParaR.thickness, localizeParaR.sigma_xy); 
        end    
    end
    ampR=ampR(indxRAll);
end
end