function trackAnalysisRes=extractTrackProperty(tracks)
[diffAnalysisRes,errFlag]=trackDiffusionAnalysis1(tracks,1,2,0,[0.05,0.1],1,1);
nTracks=length(tracks);  
trackClass=vertcat(diffAnalysisRes.classification);
trackClass=trackClass(:,2);
confinedTrackInd=find(trackClass==1);
unclassifiedTrackInd=find(isnan(trackClass));
amps=zeros(nTracks,1);
for iTrack=1:nTracks
    amps(iTrack)=nanmean(tracks(iTrack).tracksCoordAmpCG(4:8:end));
end
tmp=vertcat(diffAnalysisRes.fullDim);   %structural array, get diff const
diffConst=vertcat(tmp.normDiffCoef);    %array of diffusion constant
diffConst=diffConst;      %convert to acquisition 
for i=1:length(unclassifiedTrackInd)
    ind=unclassifiedTrackInd(i);
    [msd, stdmsd,amps]=tracksExtractMSD(tracks(ind),200); 
    diffConst(ind)=fitMSD(msd,stdmsd, 7, 1, 1);
end
end