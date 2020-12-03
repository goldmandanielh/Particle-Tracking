load('d:\Users\biwu\Desktop\tmp\C1-Str7\TrackingPackage\tracks\Channel_1_tracking_result.mat')
tracksRAll=tracksFinal;
load('d:\Users\biwu\Desktop\tmp\C2-Str7\TrackingPackage\tracks\Channel_1_tracking_result.mat')
tracksGAll=tracksFinal;

load('d:\Users\biwu\Desktop\tmp\C1-Fused_Str7\TrackingPackage\tracks\Channel_1_tracking_result.mat')
tracksRAll=tracksFinal;
load('d:\Users\biwu\Desktop\tmp\C2-Fused_Str7\TrackingPackage\tracks\Channel_1_tracking_result.mat')
tracksGAll=tracksFinal;

load('\\data.einstein.yu.edu\files\Bin Wu\Data\Image_HS\150204_tM2-yTT+osTIR1-B4\3_cyt-24xsuntagv4-oxB-AID\analysis\C1-Str10\TrackingPackage\tracks\Channel_1_tracking_result.mat')
tracksRAll=tracksFinal;
load('\\data.einstein.yu.edu\files\Bin Wu\Data\Image_HS\150204_tM2-yTT+osTIR1-B4\3_cyt-24xsuntagv4-oxB-AID\analysis\C2-Str10\TrackingPackage\tracks\Channel_1_tracking_result.mat')
tracksGAll=tracksFinal;


img=imread('d:\Users\biwu\Desktop\tmp\C1-Str7.tif');
h=imshow(img,'DisplayRange',[]);
hroi=impoly();
msk=createMask(hroi, h);

tracksR=tracksRAll(removeShortTrack(tracksRAll,7));
tracksG=tracksGAll(removeShortTrack(tracksGAll,7));
selR=selTracksInROI(tracksR, msk);
selG=selTracksInROI(tracksG, msk);
threshColocalize=5;
[c1,c2]=getNearestTrackThresholdInclusive(selR,selG, [1,0,0,0], threshColocalize);
%align the channel
[atmat]=doAffineTransform(selR,selG,c1)
[c1,c2]=getNearestTrackThresholdInclusive(selR,selG, atmat, threshColocalize);
plotAllTracks(selR(c1(:,1)),'r');
hold on
plotAllTracks(selG(c1(:,2)),'g',atmat); 
showTracksRG(selR(1),selG(14),atmat)
%[co,s1,s2]=trackCoLocLAP(selR, selG, 5);


