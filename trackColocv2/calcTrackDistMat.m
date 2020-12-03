function [ distMat ] = calcTrackDistMat(tracksR, tracksG, imageGap, minTimeOverlap, maxDistance, transformPara)
%objective:
%   Give two sets of tracks, typically from red and green channels,
%   calculate the distance between red and green tracks
%Input Para:
%   tracksR: tracks 1, typically Red
%   tracksG: tracks 2, typically Green
%   imageGap: green imaged more frequently than red. 
%   minTimeOverlap: minimum overlap in time between two track to consider
%   maxDistance: the maximum distance assigned to
%   transformPara: The transformation matrix obtained from the calibration
%History: 
%   BW: July 14, 2018   
%   BW: Aug 14, 2018, Parallize the code using linear indexing


if nargin < 3 
    imageGap=1;
end
if nargin < 4 
    minTimeOverlap=5;
end
if nargin < 5 
    maxDistance=100;    %in pixels
end
if nargin < 6 
    transformPara = [0 0 0 0 0 0];
end

numTracksG=length(tracksG);
numTracksR=length(tracksR);
distMat=zeros(numTracksR, numTracksG);
parfor iR = 1:numTracksR
    for iG=1:numTracksG
        distMat(iR,iG)=tracksDistanceRG(tracksR(iR),tracksG(iG), imageGap, minTimeOverlap, maxDistance, transformPara);
    end
end
% parfor i=1: (numTracksR*numTracksG)
%     %distMat(i)=tracksDistanceRG(tracksR(mod(i-1, numTracksR)+1),tracksG(floor((i-1)/numTracksR)+1), imageGap, minTimeOverlap, maxDistance, transformPara);
%     %distMat(i)=trackDistanceRGLinearIndex(tracksR,tracksG, imageGap, minTimeOverlap, maxDistance, transformPara, i);
%     [iR,iG]=ind2sub([length(tracksR),length(tracksG)], i);
%     distMat(i)=tracksDistanceRG(tracksR(iR),tracksG(iG), imageGap, minTimeOverlap, maxDistance, transformPara);
% end
end

function d=trackDistanceRGLinearIndex(tracksR, tracksG, imageGap, minTimeOverlap, maxDistance, transformPara, ind)
    [iR,iG]=ind2sub([length(tracksR),length(tracksG)], ind);
    d=tracksDistanceRG(tracksR(iR),tracksG(iG), imageGap, minTimeOverlap, maxDistance, transformPara);
end

