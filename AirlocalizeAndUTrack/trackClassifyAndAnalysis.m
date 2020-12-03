function trackAnalysisRes=trackClassifyAndAnalysis(tracks, plotRes)
if nargin<2
    plotRes=1;
end
if (length(tracks)<1) 
    trackAnalysisRes=[];
    return;
end
[diffAnalysisRes,errFlag]=trackDiffusionAnalysis1(tracks,1,2,0,[0.2,0.1],plotRes,1);
nTracks=length(tracks);  
trackClass=vertcat(diffAnalysisRes.classification);
trackClass=trackClass(:,2);

tmp=vertcat(diffAnalysisRes.fullDim);   %structural array, get diff const
diffConst=vertcat(tmp.normDiffCoef);    %array of diffusion constant

amps=zeros(nTracks,1);
stdPos=zeros(nTracks,1);
diffConstFit=zeros(nTracks,1);
for iTrack=1:nTracks                    %Fit the MSD to get diffusion 
    [msd, stdmsd,ampsDummy, stdPosDummy]=tracksExtractMSD(tracks(iTrack),200); 
    dcDummy=fitMSD(msd,stdmsd, 7, 1, 1);    
    if ~isnan(dcDummy)
        diffConstFit(iTrack)=dcDummy;
    else
        diffConstFit(iTrack)=diffConst(iTrack);
    end
    amps(iTrack)=ampsDummy;
    stdPos(iTrack)=stdPosDummy;
end
trackAnalysisRes=repmat(struct('classification',[],'diffConst',[],'diffConstFit',[], 'amps',[],'stdPos',[]), nTracks,1);
for iTrack=1:nTracks;
    trackAnalysisRes(iTrack).classification=trackClass(iTrack);
    trackAnalysisRes(iTrack).diffConst=diffConst(iTrack);
    trackAnalysisRes(iTrack).diffConstFit=diffConstFit(iTrack);
    trackAnalysisRes(iTrack).amps=amps(iTrack);
    trackAnalysisRes(iTrack).stdPos=stdPos(iTrack);    
end
end