%%
direct='/Users/Daniel/Documents/GreenLab/IDrive-Sync/SunTagData/201114';
baseName='sample4_1_1_green';
nframes = 121;
% direct='C:\Users\Bin\OneDrive - Johns Hopkins University\Documents\HaloPA30min\';
load(fullfile(direct, [baseName '.mat']));
tracksG=tracksFinal;
localizeParaG=p;
load(fullfile(direct, [baseName(1:end-5) 'red.mat']));
tracksR=tracksFinal;
localizeParaR=p;
thresh=5;
transformPara=[0 0 0 0 0 0];
%transformPara = [ -0.0067    0.0060   -0.0037    0.0028         0         0]; %parameters for 180719
%transformPara=[ 0.0035 0 0.0014 0 0 0]; %parameters for 180726
%transformPara = [0.0162   -0.0193   -0.0021    0.0057   -0.3477    0.0483]; %parameters for 180803
%transformPara = [0.0136   -0.0053   -0.0036    0.0032   -0.6666    0.8021]; %parameters for 180809
%transformPara = [0.0071   -0.0051    0.0022   -0.0047   -0.0265    0.0104]; %parameters for 180816
%transformPara = [0.0025   -0.0036   -0.0089    0.0031   -0.1454   -0.0531]; %parameters for 180820
%transformPara = [0.0105   -0.0084   -0.0002    0.0004   -0.0077   -0.0125]; %parameters for 180906
%transformPara = [-0.0175    0.0124    0.0314   -0.0220    0.1183   -0.0525]; %parameters for 180909
%transformPara = [-0.0021    0.0021    0.0009    0.0011    0.1062   -0.2185]; %parameters for 180911
%transformPara = [0.0097   -0.0059   -0.0014   -0.0001    0.0340   -0.0096]; %parameters for 181010
%transformPara = [-0.0012    0.0024   -0.0036    0.0012    0.1273    0.0646]; %parameters for 181102
%transformPara = [ -0.0004    0.0021   -0.0002    0.0008   -0.2821 -0.1029]; %parameters for 181105
%transformPara = [0.0004   -0.0011    0.0018   -0.0018    0.0012   -0.2010]; %parameters for 181121
%transformPara = [ -0.0027    0.0024    0.0056   -0.0017    0.3290  -0.3653]; %parameters for 181129
%transformPara = [-0.0011    0.0017    0.0005    0.0007   -0.2988    0.0570]; %parameters for 181207
%transformPara = [-0.0363    0.0238   -0.0342    0.0163         0 0]; %parameters for 181220
%transformPara = [0.0053   -0.0098    0.0086   -0.0095    0.5953    0.4918]; %parameters for 190111
%transformPara = [-0.0010    0.0006   -0.0073    0.0081    0.0964   -0.0011]; %parameters for 190115 %some of these movies have larger x-y offset than usual; may need to expand search radius to ~8
%transformPara = [0.0259   -0.0191    0.0021    0.0082    0.5155   -1.1173]; %alternate parameters for 190115
%transformPara = [0.0051   -0.0066   -0.0090    0.0186    1.4562   -2.0222]; %alternate 2 parameters for 190115 %Note: need to use a larger distance threshold for co-localization
%transformPara = [0.0033   -0.0033    0.0176   -0.0113   -0.3646   -0.8988]; %parameters for 190214
%transformPara = [0.0037   -0.0003    0.0014    0.0007   -0.1243   -0.2724]; %parameters for 190507 %sample1_1 has an acquisition glitch, might not be able to use
%transformPara = [0.0006    0.0009    0.0058   -0.0029   -0.1516   -0.0948];
%190509
%transformPara = [-0.0010   -0.0004   -0.0001    0.0026    0.7464   -0.3096]; %190514
%transformPara = [0.0006    0.0004   -0.0005    0.0041    0.5394   -0.6447]; %190516
%transformPara = [0.0043   -0.0007   -0.0044    0.0046    0.0331   -0.1655]; %190523
%transformPara = [0.0050   -0.0039    0.0005    0.0018   -0.2453   -0.0608]; %190620
%transformPara = [-0.0009   -0.0021   -0.0102    0.0117   -0.5729   -0.8626]; %190627
%transformPara = [0.0006    0.0002   -0.0068   -0.0003    0.1532    1.2600]; %190710
%transformPara = [ -0.0067    0.0036    0.0143   -0.0046    0.5296   -1.6864]; %190919
%transformPara = [ -0.0101    0.0020   -0.0034   -0.0068    2.1622    2.8728]; %190926
%transformPara = [ 0.0028    0.0026    0.0079   -0.0064   -1.2184    1.1210]; %191011
%transformPara = [0.0040   -0.0044    0.0023    0.0025    0.6977   -0.6168]; %191024
%transformPara = [-0.0043   -0.0030   -0.0014   -0.0000    0.3011    0.1950]; %191107
%transformPara = [  -0.0025   -0.0020    0.0035   -0.0029    1.2083    0.0242]; %191114
%transformPara = [  -0.0028   -0.0023    0.0014    0.0050    0.9146   -1.5563]; %191122
%transformPara = [0.0021   -0.0017    0.0010    0.0029   -0.1405   -1.3027]; %200722

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
