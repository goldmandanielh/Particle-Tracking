function [trackOut, trackIndx]=joinOverlappedTracks(tracks)
nTracks=length(tracks);
sel=getTrackSEL(tracks);
[trackStart, indS]=min(sel(:,1));
[trackEnd, indE]=max(sel(:,2));
seqOfEvents=tracks(indS).seqOfEvents;   %beginning of joined track
seqOfEvents(2,:)=tracks(indE).seqOfEvents(2,:); %end of the joined track

[mxL,indL]=max(sel(:,3));    %choose the longest track to start

[~, indSort]=sort(sel(:,3),'descend');  %sort according to the length of the track
tracksFeatIndxCG=tracks(indSort(1)).tracksFeatIndxCG;
tracksCoordAmpCG=tracks(indSort(1)).tracksCoordAmpCG;
selJoined=getTrackSEL(tracks(indSort(1)));
for i=2:nTracks
    selCurrent=getTrackSEL(tracks(indSort(i)));
    if selCurrent(1)<selJoined(1)
        tracksFeatIndxCG=[tracks(indSort(i)).tracksFeatIndxCG(1:(selJoined(1)-selCurrent(1)))  tracksFeatIndxCG];
        tracksCoordAmpCG=[tracks(indSort(i)).tracksCoordAmpCG(1:8*(selJoined(1)-selCurrent(1))) tracksCoordAmpCG];
        selJoined(1)=selCurrent(1);
    elseif selCurrent(2)>selJoined(2)
        tracksFeatIndxCG=[tracksFeatIndxCG tracks(indSort(i)).tracksFeatIndxCG((selJoined(2)-selCurrent(1)+2):end) ];
        tracksCoordAmpCG=[tracksCoordAmpCG tracks(indSort(i)).tracksCoordAmpCG((8*(selJoined(2)-selCurrent(1)+1)+1):end)];        
        selJoined(2)=selCurrent(2);
    end
    selJoined(3)=selJoined(2)-selJoined(1)+1;        
end
trackOut=struct('tracksFeatIndxCG',[],'tracksCoordAmpCG',[],'seqOfEvents',[]);
trackOut.tracksFeatIndxCG=tracksFeatIndxCG;
trackOut.tracksCoordAmpCG=tracksCoordAmpCG;
trackOut.seqOfEvents=seqOfEvents;
trackIndx=indSort;

end