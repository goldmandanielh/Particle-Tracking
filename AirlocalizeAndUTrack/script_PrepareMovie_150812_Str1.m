dataDir='D:\Users\biwu\Documents\Bin\paper\Suntag\data\Fig Cyt\';
baseName='C1-150812-Str1-crop-crop';
load([dataDir baseName '\TrackingPackage\tracks\Channel_1_tracking_result.mat']);
selR=tracksFinal;
selRRes=trackClassifyAndAnalysis(selR,0);
trackClassR=vertcat(selRRes.classification);
img=imread([dataDir baseName '.tif']);

sigma=1.25;
thresh=7;
nlo=10;
nhi=3;
baseName='C2-150812-Str1-crop-crop';
load([dataDir baseName '\TrackingPackage\tracks\Channel_1_tracking_result.mat']);
selG=tracksFinal;
selGRes=trackClassifyAndAnalysis(selG,0);
outputTracksForImageJ(selG(1),[dataDir 'GreenTrack_150812_Str1.txt']);
outputTracksForImageJ(selR([2,8]),[dataDir 'RedTrack_150812_Str1.txt']);
return

F=showAllTracks(selR(2), img)
setTackAnalysisParameter
atmat=[ 0.9957   -0.0032    1.2320    2.4276];
[c1,c2]=getNearestTrackThresholdInclusive(selR,selG, atmat, threshColocalize);
colocAnalysisRes=struct('selR',selR,'selRRes',selRRes,'selG',selG,'selGRes', selGRes,'c1',c1,'c2',c2);
h=imshow(img,'DisplayRange',[]);
hold on;
plotAllTracks(selR,'w');
plotAllTracks(selR(trackClassR==1),'r');    %confined
plotAllTracks(selR(trackClassR==2),'m');    %diffusing
plotAllTracks(selR(trackClassR==3),'y');    %directed motion
plotAllTracks(selG,'g',atmat);   %length
if length(c1)~=0
    plotAllTracks(selG(c1(:,2)),'b',atmat);
end

imshow(img,'DisplayRange',[]); hold on
plotAllTracks(selR(1:3),'r');
plotAllTracks(selG(c1(:,2)),'b',atmat);
% outputTracksForImageJ(selG([4,1]),'GreenTrack_150812.txt');
% outputTracksForImageJ(selR(1:3),'RedTrack_150812.txt');
