function trackOut=joinTracks(tracks, trackIndx)
%Given tracks and indx, combined the tracks in the same cell of indx into
%one track
%Mod History
%   BW: 7/26/2019, allow the gap between two tracks to be 0. 

nTP=length(trackIndx);
trackSEL=getTrackSEL(tracks);
trackOut=repmat(struct('tracksFeatIndxCG',[],'tracksCoordAmpCG',[],'seqOfEvents',[]),nTP,1);
for j=1:nTP
    segment=trackIndx{j};
    tracksFeatIndxCG=tracks(segment(1)).tracksFeatIndxCG;
    tracksCoordAmpCG=tracks(segment(1)).tracksCoordAmpCG;
    seqOfEvents=tracks(segment(1)).seqOfEvents;
    for k=2:length(segment)
        gaplength=trackSEL(segment(k),1)-trackSEL(segment(k-1),2)-1;
        %if trackSEL(gaplength>0)  %gap exists, need to fill in 
        if gaplength>0  %gap exists, need to fill in 
            tracksFeatIndxNan=zeros(1,gaplength);
            tracksCoordAmpNan=nan(1,8*gaplength);
            tracksFeatIndxCG=[tracksFeatIndxCG tracksFeatIndxNan];  %append Nan to the previous track
            tracksCoordAmpCG=[tracksCoordAmpCG tracksCoordAmpNan];
            tracksFeatIndxCG=[tracksFeatIndxCG tracks(segment(k)).tracksFeatIndxCG];
            tracksCoordAmpCG=[tracksCoordAmpCG tracks(segment(k)).tracksCoordAmpCG];
        elseif gaplength == 0    %consecutive, don't need to do anything, just concatenate
            tracksFeatIndxCG=[tracksFeatIndxCG tracks(segment(k)).tracksFeatIndxCG];
            tracksCoordAmpCG=[tracksCoordAmpCG tracks(segment(k)).tracksCoordAmpCG];
        elseif gaplength == -1  %0 gap, the end of the first equal to the begining of the 2nd: Ignore the beginning of the second track
            tracksFeatIndxCG=[tracksFeatIndxCG tracks(segment(k)).tracksFeatIndxCG(2:end)]; 
            tracksCoordAmpCG=[tracksCoordAmpCG tracks(segment(k)).tracksCoordAmpCG(9:end)];
        else
            disp('Error in JoinTracks: negative gap between tracks !!!!');
        end
    end
    seqOfEvents(2,:)=tracks(segment(end)).seqOfEvents(2,:);
    trackOut(j).tracksFeatIndxCG=tracksFeatIndxCG;
    trackOut(j).tracksCoordAmpCG=tracksCoordAmpCG;
    trackOut(j).seqOfEvents=seqOfEvents;
end
end
