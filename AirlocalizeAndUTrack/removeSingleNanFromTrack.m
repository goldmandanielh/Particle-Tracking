function ampOut=removeSingleNanFromTrack(ampIn,indDetect)
%Go through the intensity trace and remove the single Nan value using
%interpolation
%ampIn, indDetect: the output from calculateIntensityFromTracks
ampOut=ampIn;
nTracks=size(ampIn,1);
for i=1:nTracks
    indNull=find(isnan(indDetect(i,:)));
    indSpots=find(~isnan(indDetect(i,:)));
    for currInd=indNull
        indPre=max(indSpots(indSpots<currInd));
        indPost=min(indSpots(indSpots>currInd));
        if ~isempty(indPre) && ~isempty(indPost) && (indPost-indPre)==2
            ampOut(i,currInd)=(ampOut(i,currInd-1)+ampOut(i,currInd+1))/2;
        end
    end
%     indNull=find(tracks(i).tracksFeatIndxCG==0);
%     indSpots=find(tracks(i).tracksFeatIndxCG>0);
%     for currInd=indNull
%         indPre=max(indSpots(indSpots<currInd));
%         indPost=min(indSpots(indSpots>currInd));
%         if ~isempty(indPre) && ~isempty(indPost) && (indPost-indPre)==2
%             tracksOut(i).tracksCoordAmpCG(8*(currInd-1)+1)=tracks(i).tracksCoordAmpCG(8*(indPre-1)+1);    %x = pre
%             tracksOut(i).tracksCoordAmpCG(8*(currInd-1)+2)=tracks(i).tracksCoordAmpCG(8*(indPre-1)+2);    %y =Pre
%             tracksOut(i).tracksCoordAmpCG(8*(currInd-1)+4)=(tracks(i).tracksCoordAmpCG(8*(indPre-1)+2)+tracks(i).tracksCoordAmpCG(8*(indPost-1)+2))/2;     %amp=(Pre+Post)/2
%         end
%     end
    
end
end