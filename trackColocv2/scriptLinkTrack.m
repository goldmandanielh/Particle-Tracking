%%
direct='/Users/Daniel/Documents/GreenLab/IDrive-Sync/SunTagData/200719';
baseName='sample1_3_1_green';
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
%transformPara = [ -0.0101    0.0020   -0.0034   -0.0068    2.1622    2.8728]; %190926
%transformPara = [ -0.0067    0.0036    0.0143   -0.0046    0.5296   -1.6864]; %190919

imageGap=1;
minTimeOverlap=5;
maxDistance=100;
maxDisp=100;

[tR, tG, co, s1, s2]=linkTracks(tracksR, tracksG, thresh, transformPara, imageGap, minTimeOverlap, maxDistance, maxDisp);

stackR=tiffread5(fullfile(direct,localizeParaR.data_stackname), 1,121);
stackG=tiffread5(fullfile(direct,localizeParaG.data_stackname), 1,121);
%%
showColocTracks_grad(tR, tG, co, transformPara, stackR, stackG, imageGap, [1,121]);
%%
tRs=tR(s1);
tGs=tG(s2);
save(fullfile(direct, 'stackR.mat'), stackR);
save(fullfile(direct, 'stackG.mat'), stackG);
showAllTracks(tRs(1:10), stackR);
showAllTracks(tGs(1:10), stackG);
%%
 trackInfo = [];
 trackInfoR = [];
 counter = 1;
for iTrack=1:numel(tR(co(:,1)));
%for iTrack = [2 4 6];
    [ampG, ampR, indxGAll, indxRAll, startTime]=trackColocAmp_outputStartTime(tR(co(iTrack,1)), tG(co(iTrack,2)), imageGap, transformPara, true, 4, stackG, localizeParaG, stackR, localizeParaR);
    tempAmp = zeros(1,121);
    tempAmpR = zeros(1,121);
    showColocTracks_1frame(tR, tG, co(iTrack,:), transformPara, stackR, stackG, imageGap, [1,121]);
    %disp(iTrack);
    if startTime == 1;
         tempAmp(1:numel(indxGAll)) = ampG;
         tempAmpR(1:numel(indxRAll)) = ampR;
         f = figure;subplot(2,1,1); plot(indxGAll, ampG,'-g','linewidth',2);
         set(gca, 'box', 'off')
         ylabel('Intensity', 'fontsize', 16, 'fontweight', 'bold');
         xlabel('Time (s)', 'fontsize', 16, 'fontweight', 'bold');
         set(gca, 'fontsize', 14);
         xlim([0 121]);
         %ylim([0 150000]);
         subplot(2,1,2); plot(indxRAll, ampR,'-or');
         set(gca, 'box', 'off');
         movegui(f, [1550 1000]);
         %disp(iTrack);
    else
        tempAmp(1:startTime-1) = NaN;
        tempAmp(startTime:numel(indxGAll)+startTime-1) = ampG;
        tempAmpR(1:startTime-1) = NaN;
        tempAmpR(startTime:numel(indxRAll)+startTime-1) = ampR;
        f = figure;subplot(2,1,1); plot(indxGAll + startTime -1, ampG,'-ob'); subplot(2,1,2); plot(indxRAll + startTime -1, ampR,'-or');
        movegui(f, [1550 1000]);
        xlim([0 121]);
    end
    waitforbuttonpress;
    trackInfo(counter,:) = tempAmp;
    trackInfoR(counter,:) = tempAmpR;
    counter = counter + 1;
end
