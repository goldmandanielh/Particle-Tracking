  function [ tracksROut, tracksGOut, co,s1, s2 ] = linkTracks_v2( tracksR, tracksG, thresh, transformPara, imageGap, minTimeOverlap, maxDistance, maxDisp)
%Obj: 
%   Given two sets of tracks in different channel, use the colocalization
%   events to help link tracks happen in different time
%Input Parameters
%   tracksR: tracks in the red channel (typically mRNA)
%   tracksG: tracks in the green channel (typically translation sites)
%   thresh: threshold to test whether two tracks colocalize
%   transformPara: transformation parameters between two channels
%   imageGap: imaging interval ratio between two channels, typically, green
%           more frequently than Red
%   minTimeOverlap: minimum overlap time to be considered colocalized
%   maxDistance: the maximum distance assigned to distance between
%           non-overlapping tracks
%   maxDisp: maximal displacement in the same channel to be considered to
%           join
%Output Parameters
%   tracksROut: the output red tracks that have been linked
%   tracksGOut: the output green tracks that have been linked
%   co: the colocalization structures = [i1,i2,dist,overlapTime]
%   s1: the nonclocalized red indices
%   s2: the noncolocalized green indices
%History: 
%   BW: July 14, 2018   
%   BW: Aug 14, 2018, Remove duplicated computation of the matix distance,
%       and use parallel computation, increased the speed by a factor of 2
%       need to use the new version of calcTrackDistMat.m which has
%       parallel computation

nr=length(tracksR); ng=length(tracksG);
if (nr ==0 || ng == 0)
    tracksROut=[];
    tracksGOut=[];
    co=[];
    s1=[];
    s2=[];
    return;
end
if nargin<3
    thresh=2;
end

if nargin<4
    transformPara=[0,0,0,0,0,0];
end

if nargin<5
    imageGap=1;
end

if nargin<6
    minTimeOverlap=3;
end

if nargin<7
    maxDistance=100;
end

if nargin < 8
    maxDisp=100;
end
count=1;

nr=length(tracksR);
ng=length(tracksG);
tracksR=tracksSortByLength(tracksR);    %First sort the track according to length
tracksG=tracksSortByLength(tracksG);
dist=calcTrackDistMat(tracksR,tracksG, imageGap, minTimeOverlap, maxDistance, transformPara);   %distance matrix between two channel tracks

while count>0
    count=0;    %count whether there are merging events, if no, quit the loop
    nr=length(tracksR);
    ng=length(tracksG);
    tracksGJoined=[];
    distGJoined=[];
    for i=1:nr
        indColocG=find(dist(i,:)<thresh);   %All green tracks within the threshold
        nColoc=length(indColocG);
        if nColoc>1
            tracksG2Link=tracksG(indColocG);
            [trackOut, trackIndx]=tracksJoinByOverlap(tracksG2Link, maxDisp, tracksR(i), imageGap); 
            tracksGJoined=[tracksGJoined; trackOut];
            distTemp = calcTrackDistMat(tracksR, trackOut, imageGap, minTimeOverlap, maxDistance, transformPara);
            distGJoined=[distGJoined, distTemp];
            indGRemain=setdiff(1:ng, indColocG(trackIndx));
            if length(trackIndx)>1 
                count=count+1;
            end
        elseif nColoc==1
            tracksGJoined=[tracksGJoined; tracksG(indColocG)];
            indGRemain=setdiff(1:ng, indColocG);
            distGJoined=[distGJoined, dist(:, indColocG)];
        else
            indGRemain=1:ng;
        end
        %remove the joined tracks from tracksG;        
        tracksG=tracksG(indGRemain);
        ng=length(tracksG);
        dist=dist(:, indGRemain);
    end
    %update the track distance matrix instead of re-calculating it
    dist=[distGJoined, dist];   %Concatenate the matrix left to right
    tracksG=[tracksGJoined; tracksG];
    ng=length(tracksG);
    
    tracksRJoined=[];
    distRJoined=[];
    for j=1:ng
        indColocR=find(dist(:,j)<thresh);
        nColoc=length(indColocR);
        if nColoc>1
            tracksR2Link=tracksR(indColocR);
            [trackOut, trackIndx]=tracksJoinByOverlap(tracksR2Link, maxDisp, tracksG(j), -imageGap);
            tracksRJoined=[tracksRJoined; trackOut];
            distTemp = calcTrackDistMat(trackOut, tracksG, imageGap, minTimeOverlap, maxDistance, transformPara);
            distRJoined=[distRJoined; distTemp];
            indRRemain=setdiff(1:nr, indColocR(trackIndx));
            if length(trackIndx)>1 
                count=count+1;
            end
        elseif nColoc==1
            tracksRJoined=[tracksRJoined; tracksR(indColocR)];
            indRRemain=setdiff(1:nr, indColocR);
            distRJoined=[distRJoined; dist(indColocR,:)];
        else
            indRRemain=1:nr;
        end
        %remove the joined tracks from tracksG;
        tracksR=tracksR(indRRemain);
        nr=length(tracksR);
        dist=dist(indRRemain,:);
    end
    dist=[distRJoined; dist];   %Concatenate the matrix up and down
    tracksR=[tracksRJoined; tracksR];
    nr=length(tracksR);
end %while

%% find the colocalized tracks with maximum overlap
[co, s1, s2]=tracksGetColocWMaxOverlap(tracksR,tracksG,thresh,imageGap, minTimeOverlap, maxDistance, transformPara, dist);
tracksROut=tracksR;
tracksGOut=tracksG;

end

