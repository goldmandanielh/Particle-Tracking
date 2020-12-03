function atmat=calibratePixelShift(selR, selG)
%selR, selG, the selected tracks in the ROI
% setTackAnalysisParameter;
% homeDir='F:\HS\';
% % dataDir=[homeDir '150812_tmH+phR-scFV+pBabe-osT_sorted\1_transient cyt-24xst-oxB-AID\analysis\'];
% dataDir=[homeDir '150812_tmH+phR-scFV+pBabe-osT_sorted\2_transient cyt-24xst-fluc-AID\analysis\'];
% baseName='corrStr';
% dataID=15;
% load([dataDir 'C1-' baseName num2str(dataID) '.mat'],'-mat');
% load([dataDir baseName num2str(dataID) '_mask.mat'],'-mat');   %load mask
% tracksR=tracksFinal(removeShortTrack(tracksFinal, minTrackLength));   %select track length
% selR=selTracksInROI(tracksR,msk);    %select in the mask
% 
% load([dataDir 'C2-' baseName num2str(dataID) '.mat'],'-mat');
% load([dataDir baseName num2str(dataID) '_mask.mat'],'-mat');   %load mask
% tracksG=tracksFinal(removeShortTrack(tracksFinal, minTrackLength));   %select track length
% selG=selTracksInROI(tracksG,msk);    %select in the mask
% 
threshColocalize=5;
[c1,c2]=getNearestTrackThresholdInclusive(selR,selG, [1,0,0,0], threshColocalize);
%align the channel
[atmat]=doAffineTransform(selR,selG,c1);
end