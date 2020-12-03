% dataDir='d:\Users\biwu\Desktop\tmp\150702_tmH+pBabe-osT-9myc+phR-scFV\1_flag-24xstv4-oxB-AID\analysis\';
dataDir='E:\Data\temp\';
dataID=1;
minTrackLength=2;
stackName='C1-MAXNDExpSeq000';
img=imread([dataDir stackName num2str(dataID) '.tif']);

load([dataDir stackName num2str(dataID) '.mat'],'-mat');
load([dataDir,stackName num2str(dataID) '_mask.mat'],'-mat');   %load mask
%movieInfo=output_trajectories_as_structure_from_res2(detection_result)
% plot(movieInfo(3).xCoord(:,1), movieInfo(3).yCoord(:,1),'ro');
%scriptTrackGeneral;
tracksR=tracksFinal(removeShortTrack(tracksFinal, minTrackLength));   %select track length
selR=selTracksInROI(tracksR,msk);    %select in the mask

load([dataDir 'C2-Str' num2str(dataID) '.mat'],'-mat');
load([dataDir,'Str' num2str(dataID) '_mask.mat'],'-mat');   %load mask
% movieInfo=output_trajectories_as_structure_from_res2(detection_result)
% scriptTrackGeneral;
tracksG=tracksFinal(removeShortTrack(tracksFinal, minTrackLength));   %select track length
selG=selTracksInROI(tracksG,msk);    %select in the mask
% save([dataDir,'C2-Str' num2str(dataID) '.mat'], 'msk','-append')


%sG=tracksFinal(removeShortTrack(tracksFinal, 7));   %select track length
% selR=selTracksInROI(tracksR,msk);    %select in the mask
% selG=selTracksInROI(tracksG,msk);    %select in the mask
threshColocalize=5;
[c1,c2]=getNearestTrackThresholdInclusive(selR,selG, [1,0,0,0], threshColocalize);
%align the channel
[atmat]=doAffineTransform(selR,selG,c1)
[c1,c2]=getNearestTrackThresholdInclusive(selR,selG, atmat, threshColocalize);

h=imshow(img(:,:,1),'DisplayRange',[]);
hold on;
% plot(movieInfo(1).xCoord(:,1),movieInfo(1).yCoord(:,1),'go')
plotAllTracks(selR,'r');
plotAllTracks(selG,'g',atmat);   %length
plotAllTracks(selG(c1(:,2)),'b',atmat);
hold off
figure
[diffConst, amp]=classifyTrackDiffusion(selG); mean(diffConst)
% 
% % plot(movieInfo(1).xCoord(:,1),movieInfo(1).yCoord(:,1),'go')
% % plotAllTracks(tracksFinal,'b');
% % plotAllTracks(sG,'g');   %length
% % plotAllTracks(selG,'r'); %in the mask
% % hold off
