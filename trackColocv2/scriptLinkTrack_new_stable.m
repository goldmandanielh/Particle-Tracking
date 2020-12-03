%%

direct='/Users/Daniel/Documents/GreenLab/IDrive-Sync/SunTagData/ATF4/';
baseName='ATF4_1_green';
nframes = 721;
load(fullfile(direct, [baseName '.mat']));
tracksG=tracksFinal;
localizeParaG=p;
load(fullfile(direct, [baseName(1:end-5) 'red.mat']));
tracksR=tracksFinal;
localizeParaR=p;
thresh=5;
minObsTime = 60; %minimum # of observation frames to include in verified structure
transformPara=[0 0 0 0 0 0];

imageGap=1;
minTimeOverlap=5;
maxDistance=100;
maxDisp=100;

[tR, tG, co, s1, s2]=linkTracks(tracksR, tracksG, thresh, transformPara, imageGap, minTimeOverlap, maxDistance, maxDisp);
s = struct;
s.tR = tR;
s.tG = tG;
s.co = co;  

stackR=tiffread5(fullfile(direct,localizeParaR.data_stackname), 1,nframes);
stackG=tiffread5(fullfile(direct,localizeParaG.data_stackname), 1,nframes);

trackInfo = [];
trackInfoR = [];
coVerified = [];
counter = 1;
for iTrack=1:numel(tR(co(:,1)));
    [ampG, ampR, indxGAll, indxRAll, startTime]=trackColocAmp_outputStartTime(tR(co(iTrack,1)), tG(co(iTrack,2)), imageGap, transformPara, true, 4, stackG, localizeParaG, stackR, localizeParaR);
    tempAmp = zeros(1,nframes);
    tempAmpR = zeros(1,nframes);
    if numel(indxGAll)>=minObsTime;
        if startTime == 1;
           tempAmp(1:numel(indxGAll)) = ampG;
           tempAmpR(1:numel(indxRAll)) = ampR;
           coVerified(counter,:) = co(iTrack,:);
           trackInfo(counter,:) = tempAmp;
           trackInfoR(counter,:) = tempAmpR;
           counter = counter + 1;
        else;
           tempAmp(1:startTime-1) = NaN;
           tempAmp(startTime:numel(indxGAll)+startTime-1) = ampG;
           tempAmpR(1:startTime-1) = NaN;
           tempAmpR(startTime:numel(indxRAll)+startTime-1) = ampR;
           coVerified(counter,:) = co(iTrack,:);
           trackInfo(counter,:) = tempAmp;
           trackInfoR(counter,:) = tempAmpR;
           counter = counter + 1;
        end
    end

end
s.coVerified = coVerified;
s.trackInfo = trackInfo;
s.trackInfoR = trackInfoR;
save(fullfile(direct,[baseName,'_linked.mat']), 's');
