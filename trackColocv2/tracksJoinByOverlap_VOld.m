function [trackOut, trackIndx]=tracksJoinByOverlap(tracks, maxDisp, trackRef, imageGap)
%Obj: join track segments that colocalized with trackRef
%   among all candidates, choose the joined tracks that has maximum overlap
%   with the reference track
%Input:
%   tracks: All track segments that colocalize with trackRef
%   maxDisp: maximum displacement allowed between the ends of track segment
%   trackRef: the reference track that colocalize
%   imageGap: the difference of imaging interval between tracks and trackRef
%Output
%   trackOut: the output joined track
%   trackIndex: the index of joined track segments in the tracks. 

nTracks=length(tracks);
if nTracks == 1
    trackOut=tracks;
    trackIndx=1;
    return
end
adjmat=tracksTimeDist(tracks);    %only care about the time, since the candidate tracks all colocalize with trackRef
global totalPath;
totalPath={};
% [verIndOut, currentIndOut,currentPathOut]=countJoinedTracks(adjmat, 1, 2:length(tracks), {{1}});    %calculate all possible track joining scenario, saved in the global parameter totalPath
% countJoinedTracks(adjmat, 1, 2:length(tracks), {{1}});    %calculate all possible track joining scenario, saved in the global parameter totalPath
for i=1:nTracks
    countJoinedTracks(adjmat, i, setdiff(1:nTracks,i), {{i}});    %calculate all possible track joining scenario, saved in the global parameter totalPath
end
%Select the minimum number of total tracks
nTP=length(totalPath);
lenTP=zeros(nTP,1);
for i=1:nTP
    lenTP(i)=length(totalPath{i});
end
%Among all the choices, choose the one that mimize the distance of end joining
minTP=min(lenTP);
totalPath=totalPath(lenTP == minTP);   %only keep the minimum number of path. There may be more than 1 possiblilities
nTP=length(totalPath);
mxOverlap=0;
trackIndx=[];
trackOut=[];
for i=1:nTP
    trackTemp=joinTracks(tracks, totalPath{i});
    for j=1: length(trackTemp)
        dummy=length(trackOverlapTimePos(trackRef, trackTemp(j), imageGap));
        if dummy>mxOverlap
            mxOverlap=dummy;
            trackIndx=totalPath{i}{j};
            trackOut=trackTemp(j);
        end
    end
end
end