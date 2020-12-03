function [amp ind]=calculateIntensityFromTracks(tracks, stack, param)
%Given the tracks and the image, extract the intensity of the track, for
%time point the particle is not there, just calculate the intensity with
%the image and the given positions
%tracks: the u-track tracks structure
%stack: [x,y,t], 2d image stacks
%param: the paramter used in AirLocalize

%amp: [nTracks, nT], intensity for each track
%ind: [nTracks, nT], for missing point, ind should be Nan

nTracks=length(tracks);
nT=size(stack,3);
amp=zeros(nTracks,nT);
ind=nan(nTracks,nT);
trackSEL=getTrackSEL(tracks);
cutsize=param.cutsize;
thickness=param.thickness;
sxy=param.sigma_xy;
for i=1:nTracks
    %first fill in the spots already available
    trackStart=trackSEL(i,1);   %start, this is to obtain time in the movie
    trackEnd=trackSEL(i,2);
    amp(i,trackStart:trackEnd)=tracks(i).tracksCoordAmpCG(4:8:end);
    
    indNull=trackStart+find(tracks(i).tracksFeatIndxCG==0)-1;  %find the null points, indx IN the track
    indSpots=trackStart+find(tracks(i).tracksFeatIndxCG>0)-1; %Note, this is determined before insertion. So the pre and post will not change with insertion
    ind(i,indSpots)=indSpots;
    indMissing=indNull;
    if trackStart>1
        indMissing=[1:trackStart indMissing];
    end
    if trackEnd<nT
        indMissing=[indMissing trackEnd:nT];
    end
    for currInd=indMissing
        indPre=max(indSpots(indSpots<currInd));
        indPost=min(indSpots(indSpots>currInd));
        if isempty(indPre)   %Find the detected indices closer to the current indx
            indxClose=indPost;
        elseif isempty(indPost);
            indxClose=indPre;
        else
            [indDist,indxMn]=min([currInd-indPre, indPost-currInd]);
            indxClose=currInd+(2*indxMn-3)*indDist;    
        end
        x=tracks(i).tracksCoordAmpCG(8*(indxClose-trackStart)+2);
        y=tracks(i).tracksCoordAmpCG(8*(indxClose-trackStart)+1);        
        amp(i,currInd)=spotIntensity(stack(:,:,currInd),x,y, cutsize,thickness,sxy);
    end
end

end