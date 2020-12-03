%%
direct='E:\Data\temp\movies\';
baseName='movie1_1';
load(fullfile(direct, ['C1-', baseName,'.mat']));
tracksG=tracksFinal;
localizeParaG=p;
load(fullfile(direct, ['C2-', baseName,'.mat']));
tracksR=tracksFinal;
localizeParaR=p;
thresh=2;
% transformPara=[0 0 0 0 0 0];
transformPara=[0.0009, -0.0001, 0.0028, 0.0004, -0.6809, -0.5579];
imageGap=6;
minTimeOverlap=3;
maxDistance=100;
maxDisp=100;
[tR, tG, co, s1, s2]=linkTracks(tracksR, tracksG, thresh, transformPara, imageGap, minTimeOverlap, maxDistance, maxDisp);
% transformPara=calibrateWithTracks(tR, tG, co, imageGap, thresh);
%%
stackR=tiffread5(fullfile(direct,localizeParaR.data_stackname), 1,45);
stackG=tiffread5(fullfile(direct,localizeParaG.data_stackname), 1,270);
%% prepare the movie
figure
F=showColocTracks(tR, tG, co(:,:), transformPara, stackR, stackG, imageGap, [1,270]);
% write video
myVideo=VideoWriter(fullfile(direct,[baseName,'.avi']));
myVideo.FrameRate=20;
open(myVideo);
writeVideo(myVideo,F);
close(myVideo);
%% show the uncolocalized tracks
tRs=tR(s1);
tGs=tG(s2);
F=showAllTracks(tRs, stackR);
F=showAllTracks(tGs(1:10), stackG);
%%
iTrack=18;
[ampG, ampR, indxGAll, indxRAll]=trackColocAmp(tR(co(iTrack,1)), tG(co(iTrack,2)), imageGap, transformPara, true, 4, stackG, localizeParaG, stackR, localizeParaR); 
subplot(3,1,1); plot(indxGAll, ampG,'-go'); subplot(3,1,2); plot(indxRAll, ampR,'-ro');
subplot(3,1,3); plotTracksRG(tR(co(iTrack,1)), tG(co(iTrack,2)), transformPara);