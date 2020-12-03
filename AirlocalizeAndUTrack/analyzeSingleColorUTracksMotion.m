function [sel, selRes, anaRes]=analyzeSingleColorUTracksMotion(dataDir, baseName, dataID, showTracks,maskFile)
setTackAnalysisParameter;
load([dataDir baseName num2str(dataID) '\TrackingPackage\MotionAnalysis\channel_1.mat'],'-mat');
if nargin>=5
    load(fullfile(dataDir, maskFile),'-mat');
end
sel=tracks(removeShortTrack(tracks, minTrackLength));   %select track length
% sel=selTracksInROI(tracks,msk);    %select in the mask
selRes=trackClassifyAndAnalysis(sel,0);

trackClass=vertcat(selRes.classification);
dcFit=vertcat(selRes.diffConstFit);
dc=vertcat(selRes.diffConst);
stdPos=vertcat(selRes.stdPos);

indxMobile=find(trackClass>1 & dcFit>threshMobile & stdPos>threshStdPos);
indxDiff=find(trackClass == 1 | trackClass ==2);
indxDiffMobile=find(trackClass==2 & dcFit>threshMobile & stdPos>threshStdPos);
indxConfined=find(trackClass==1 | (trackClass>=2 & (dcFit<=threshMobile & stdPos<threshStdPos)));   %stationary RNA
fracMobile=length(indxMobile)/length(sel);
fracConfined=length(indxConfined)/length(sel);
dcFit=dcFit(indxDiff);
dc=dc(indxDiff);

if showTracks==1
    img=imread([dataDir baseName num2str(dataID) '.tif']);
    h=imshow(img,'DisplayRange',[]);
    hold on;
    trackClass=vertcat(selRes.classification);
    plotAllTracks(sel,'w');
    plotAllTracks(sel(trackClass==2),'c');    %mobile RNA
    plotAllTracks(sel(trackClass==3),'b');    %mobile RNA
    plotAllTracks(sel(trackClass==1),'r');    %mobile RNA
    hold off
end
anaRes=struct( ...
    'indxMobile',indxMobile,        ...
    'indxDiff', indxDiff,           ...
    'indxDiffMobile',indxDiffMobile,...
    'indxConfined',indxConfined,    ...
    'dcFit',dcFit,                  ...        %contain only diffusing
    'dc',dc,                        ...         %contain only diffusing
    'stdPos', stdPos,               ...
    'fracMobile', fracMobile,       ...
    'fracConfined',fracConfined);
end