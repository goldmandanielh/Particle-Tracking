function [colocAnalysisRes]=analyzeColocalizedTracks(dataDir,baseName,dataID,atmat,showTracks)
%Analyze the colocalizing tracks
%selR (selG): select Red (Green) tracks
%selRRes (selGRes): the analysis results of red (Green) tracks, including 
%       classfication, diffConst, diffConstFit, amps, stdPos
%c1: the colocalization array (s1,s2,distance)
setTackAnalysisParameter;
load([dataDir 'C1-' baseName num2str(dataID) '.mat'],'-mat');
load([dataDir baseName num2str(dataID) '_mask.mat'],'-mat');   %load mask
tracksR=tracksFinal(removeShortTrack(tracksFinal, minTrackLength));   %select track length
selR=selTracksInROI(tracksR,msk);    %select in the mask
selRRes=trackClassifyAndAnalysis(selR,0);
trackClassR=vertcat(selRRes.classification);

load([dataDir 'C2-' baseName num2str(dataID) '.mat'],'-mat');
load([dataDir baseName num2str(dataID) '_mask.mat'],'-mat');   %load mask
tracksG=tracksFinal(removeShortTrack(tracksFinal, minTrackLength));   %select track length
selG=selTracksInROI(tracksG,msk);    %select in the mask
selGRes=trackClassifyAndAnalysis(selG,0);

[c1,c2]=getNearestTrackThresholdInclusive(selR,selG, atmat, threshColocalize);

% colocRes=struct('c1',c1,'c2',c2,'trIndR',trIndR,'ntrIndR',ntrIndR,'trIndG',trIndG,'ntrIndG',ntrIndG);

colocAnalysisRes=struct('selR',selR,'selRRes',selRRes,'selG',selG,'selGRes', selGRes,'c1',c1,'c2',c2);

if showTracks==1
    img=imread([dataDir 'C1-' baseName num2str(dataID) '.tif']);
    h=imshow(img,'DisplayRange',[]);
    hold on;
    if length(selR) ~= 0
        plotAllTracks(selR,'w');
        plotAllTracks(selR(trackClassR==1),'r');    %confined
        plotAllTracks(selR(trackClassR==2),'m');    %diffusing
        plotAllTracks(selR(trackClassR==3),'y');    %directed motion
    end
    if length(selG) ~= 0 
        plotAllTracks(selG,'g',atmat);   %length
        if length(c1)~=0
            plotAllTracks(selG(c1(:,2)),'b',atmat);
        end
    end
    % plotAllTracks(selR(trIndR),'r');
    % plotAllTracks(selR(ntrIndR),'g');   %length
    
    % plotAllTracks(selG(trIndG),'r');
    % plotAllTracks(selG(ntrIndG),'g');   %length

    hold off;
end

end