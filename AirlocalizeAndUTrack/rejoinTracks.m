function [trackOut, trackIndx]=rejoinTracks(tracks,maxDist)
%This function rejoin the tracks to minimum number of tracks that allowed
%in time and the distance between ends are within maxDist
%
nTracks=length(tracks);
if(nTracks)<=1
    trackOut=tracks;
    trackIndx={1};
    return;
end
[trackDist, adjmat]=tracksEndsDist(tracks,maxDist); %calcualte the distance between tracks in space and time
verInD=1:nTracks;   %the availalbe track indices
global totalPath;   %globle varialbe to save all possible combinations of tracks that is compatilbe to join
totalPath={};
[verIndOut, currentIndOut,currentPathOut]=countJoinedTracks(adjmat, 1, 2:nTracks,{{1}});

%Select the minimum number of total tracks
nTP=length(totalPath);
lenTP=zeros(nTP,1);
for i=1:nTP
    lenTP(i)=length(totalPath{i});
end

%Among all the choices, choose the one that mimize the distance of end
%joining
minTP=min(lenTP);
totalPath=totalPath(lenTP == minTP);   %only keep the minimum number of path
nTP=length(totalPath);
distTP=zeros(nTP,1);
for i=1:nTP
    for j=1:minTP
        for k=2:length(totalPath{i}{j})
            distTP(i)=distTP(i)+trackDist(totalPath{i}{j}(k-1), totalPath{i}{j}(k));
        end
    end
end
[~, ind]=min(distTP);
%trackOut=totalPath{ind};

%Merge the joined tracks
trackIndx=totalPath{ind};
trackOut=joinTracks(tracks,trackIndx);
end