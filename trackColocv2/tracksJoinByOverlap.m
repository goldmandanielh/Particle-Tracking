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

adjmat(isnan(adjmat))=0;
dg=sparse(adjmat);      %convert to sparse matrix for graph function for directed graph
mxDist=0;
mxPath=[];
for i=1:nTracks
    [dist,path]=graphshortestpath(dg,i,'Directed',true);    %This is equivalent to choose minimal gap time when connecting two segments
    dist(dist==Inf)=nan;
    [mxd,ind]=nanmax(dist);        %This is trying to get the longest path
    if(mxd > mxDist)
        mxDist=mxd;
        mxPath=path{ind};
    end
end
if isempty(mxPath)      %In this case, there will be two overlapping tracks in time
    disp(['tracksJoinedByOverlap: join overlapping ' num2str(nTracks) ' tracks']);
    [trackOut, trackIndx]=joinOverlappedTracks(tracks);
else
    trackIndx=mxPath;
    trackOut=joinTracks(tracks,{trackIndx});
end

end