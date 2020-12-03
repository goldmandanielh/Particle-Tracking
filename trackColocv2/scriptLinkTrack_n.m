%%
direct='/Users/Daniel/Documents/GreenLab/IDrive-Sync/SunTagData/201114';
baseName='sample4_1_1_green';
nframes = 121;
load(fullfile(direct, [baseName '.mat']));
tracksG=tracksFinal;
localizeParaG=p;
load(fullfile(direct, [baseName(1:end-5) 'red.mat']));
tracksR=tracksFinal;
localizeParaR=p;
thresh=5;
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
    if startTime == 1;
        showColocTracks_1frame(tR, tG, co(iTrack,:), transformPara, stackR, stackG, imageGap, [1,nframes]);
        disp(startTime);
        tempAmp(1:numel(indxGAll)) = ampG;
        tempAmpR(1:numel(indxRAll)) = ampR;
        f = figure;subplot(2,1,1); plot(indxGAll, ampG,'-g','linewidth',2);
        xlim([0 121]);
        subplot(2,1,2); plot(indxRAll, ampR,'-or');
        movegui(f, [1550 1000]);
        waitforbuttonpress;
        kkey = get(gcf,'CurrentCharacter');
        if kkey == 121;
            coVerified(counter,:) = co(iTrack,:);
            trackInfo(counter,:) = tempAmp;
            trackInfoR(counter,:) = tempAmpR;
            counter = counter + 1;
        end
        close all;
    elseif startTime < 5;
        showColocTracks_1frame(tR, tG, co(iTrack,:), transformPara, stackR, stackG, imageGap, [1,nframes]);
        disp(startTime);
        tempAmp(1:startTime-1) = NaN;
        tempAmp(startTime:numel(indxGAll)+startTime-1) = ampG;
        tempAmpR(1:startTime-1) = NaN;
        tempAmpR(startTime:numel(indxRAll)+startTime-1) = ampR;
        f = figure;subplot(2,1,1); plot(indxGAll + startTime -1, ampG,'-ob'); subplot(2,1,2); plot(indxRAll + startTime -1, ampR,'-or');
        movegui(f, [1550 1000]);
        xlim([0 121]);
        waitforbuttonpress;
        kkey = get(gcf,'CurrentCharacter');
        if kkey == 121;
            coVerified(counter,:) = co(iTrack,:);
            trackInfo(counter,:) = tempAmp;
            trackInfoR(counter,:) = tempAmpR;
            counter = counter + 1;
        end
        close all;
    end

end
s.coVerified = coVerified;
s.trackInfo = trackInfo;
s.trackInfoR = trackInfoR;
save(fullfile(direct,[baseName,'_linked.mat']), 's');
