function [ distMat ] = calcDistanceMatrix(tracksR, tracksG, atmat)
%calcDistanceMatrix Summary of this function goes here
%   Detailed explanation goes here
% atmat: the affine transfomration matrix

if nargin < 3 
    atmat = [1,0, 0 0];
end
maxDistance=100;
numTracksG=length(tracksG);
numTracksR=length(tracksR);

distMat=zeros(numTracksR, numTracksG);
for iR = 1:numTracksR
    for iG=1:numTracksG
        distMat(iR,iG)=tracksDistanceWithPenalty(tracksR(iR),tracksG(iG), atmat);
    end
end
end

