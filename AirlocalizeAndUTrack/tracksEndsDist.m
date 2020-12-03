function [trackDist, trackTimeDist]=tracksEndsDist(tracks, maxDisp)
%This function determine the distance between ends of strack segments both
%in time and space.
%tracks: the input tracks
%maxDisp: the allowed maximum displacement
%Output: 
%trackDist: the distance between the ends of the first segment and the
%       start of the 2nd segment
%trackTimeDist: the distance in time between segments, if the ends are too
%       far, it is not allowed to connect
%

nTracks=length(tracks);
tracksStart=zeros(nTracks,2);
tracksEnd=zeros(nTracks,2);
for i=1:nTracks
    tracksStart(i,:)=tracks(i).tracksCoordAmpCG(1:2);
    tracksEnd(i,:)=tracks(i).tracksCoordAmpCG(end-7:end-6);
end
tracksSEL=getTrackSEL(tracks);
trackDist=zeros(nTracks,nTracks)-1;
trackTimeDist=nan(nTracks,nTracks);
for i=1:nTracks
    for j=i+1:nTracks
        if tracksSEL(j,1)>tracksSEL(i,2)
            trackDist(i,j)=sqrt((tracksStart(j,1)-tracksEnd(i,1))^2+ ...
                (tracksStart(j,2)-tracksEnd(i,2))^2);
            if (trackDist(i,j)<maxDisp)
                trackTimeDist(i,j)=tracksSEL(j,1)-tracksSEL(i,2);
            end
        else
            trackDist(i,j)=nan;
        end
    end
end

end