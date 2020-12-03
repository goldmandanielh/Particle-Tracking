function tracksOut=insertMissingPoint2Tracks(tracksIn,detRes, maxDisp, midY,yDev)
%This function go over the gaps between the tracked segment and looks for
%spots detected within the maxDisp distance in between the positions before
%disappearing and after reappearing. To be sure, the spots should be in
%relative middle of the image, because the dendrite has been straightened.
%Any spots that is on the edge of image is spurious. 

%tracksIn: the input tracks
%detRes: the detection results obtained from airlocalize: I should have
%       used the movieInfo, anyway
%maxDisp: the maximum displacement that a particle can travel in the gap
%midY: the middle position of y, should be half to the image height
%yDev: the deviation from the middle midY that allowed:remove spurious spot
%


tracksOut=tracksIn;
trackSEL=getTrackSEL(tracksOut);    %start, end, length of the track
nTracks=length(tracksOut);
nT=length(detRes);      %total number of frames
numSpots=zeros(nT,1);
for i=1:nT      %found out how many spots in each frame
    numSpots(i)=size(detRes(i).final_pix,1);
end
featIndx=zeros(nT, max(numSpots));      %save all spots indx
for i=1:nT
    featIndx(i,1:numSpots(i))=1:numSpots(i);
end

for i=1:nTracks     %remove the points already in the track
    ind=trackSEL(i,1):trackSEL(i,2);    %start to end of track i
    numSpots(ind)=numSpots(ind)-(tracksOut(i).tracksFeatIndxCG>0)';
    indNonNull=find(tracksOut(i).tracksFeatIndxCG);
    for j=indNonNull
        featIndx(trackSEL(i,1)+j-1,tracksOut(i).tracksFeatIndxCG(j))=0;
    end  
end
for i=1:nTracks     %Go over all tracks
    indNull=find(tracksOut(i).tracksFeatIndxCG==0);  %find the null points, indx IN the track
    indSpots=find(tracksOut(i).tracksFeatIndxCG>0); %Note, this is determined before insertion. So the pre and post will not change with insertion
    trackStart=trackSEL(i,1);   %start, this is to obtain time in the movie    
    for j=1:length(indNull)
        currInd=trackStart+indNull(j)-1;    %The indx in the movie
        ns=numSpots(currInd);
        if(ns)>0     %there are left spots
            indPre=indSpots(indSpots<indNull(j));   
            indPre=max(indPre);     %find the spots just before in the track
            xPre=tracksOut(i).tracksCoordAmpCG(8*(indPre-1)+1);
            yPre=tracksOut(i).tracksCoordAmpCG(8*(indPre-1)+2);
            indPost=indSpots(indSpots>indNull(j));
            indPost=min(indPost);  %find the spots right after 
            xPost=tracksOut(i).tracksCoordAmpCG(8*(indPost-1)+1);
            yPost=tracksOut(i).tracksCoordAmpCG(8*(indPost-1)+2);
            indFeat=featIndx(currInd,:);    %The available spots currently
            indFeat=indFeat(indFeat>0);     %Keep only the positive
            for k=1:ns
                x=detRes(currInd).final_pix(indFeat(k),2);
                y=detRes(currInd).final_pix(indFeat(k),1);
                distPre=sqrt((x-xPre)^2+(y-yPre)^2);    %distance to pre
                distPost=sqrt((x-xPost)^2+(y-yPost)^2); %distance to post
                if(distPre<maxDisp && distPost<maxDisp && abs(y-midY)<yDev)
                    featIndx(currInd,indFeat(k))=0; %Then insert the point
                    numSpots(currInd)=numSpots(currInd)-1;
                    tracksOut(i).tracksFeatIndxCG(indNull(j))=indFeat(k);
                    tracksOut(i).tracksCoordAmpCG(8*(indNull(j)-1)+1 : 8*(indNull(j)-1)+7)=0;
                    tracksOut(i).tracksCoordAmpCG(8*(indNull(j)-1)+1)=x;
                    tracksOut(i).tracksCoordAmpCG(8*(indNull(j)-1)+2)=y;
                    tracksOut(i).tracksCoordAmpCG(8*(indNull(j)-1)+4)=detRes(currInd).final_pix(indFeat(k),3);
                    break;
                end
            end
        end
    end
end

end