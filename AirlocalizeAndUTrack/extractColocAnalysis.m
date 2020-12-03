function [resColocAna]=extractColocAnalysis(colocAnaRes)
%Get the parameters from colocAnaRes structure array obtained from
%analyzeColocalizedTracks.m
%colocAnaRes: selR,selRRes,selG,selGRes,c1,c2
% resColocAna=struct( ...
%     'indxTr', 	indx of translating tracks
%     'indxTrG', 	indx of translating RNA correponds to Green channel
%     'distanceRG', distance between green and red
%     'indxNTr',    indx of nontranslating tracks
%     'trackClass', the classficiation of tracks
%     'indxMobile', indx of Mobile tracks
%     'indxDiff',   indx of Diffusing tracks, including confined
%     'indxDiffMobile', indx of Diffusing and Mobile tracks
%     'indxConfined', indx of Confined tracks
%     'dcFit',      diffusion constant obtained by fit MSD
%     'dc',         diffusion constant by MSS
%     'dcTr',       dc of translating diffsuing tracks
%     'dcNTr',      dc of non-translating diffusing tracks
%     'dcTrMobile', dc of mobile, diffusing, translating tracks
%     'dcNTrMobile', dc of mobile, diffusing, nontranslating tracks
%     'dcTrG',      dc of translating RNA calculated in the green channel
%     'dcTrGMobile', dc of mobile translating RNA calculated in the green channel
%     'ampTr',      amp of all translating tracks
%     'ampDiffTr',  amp vs dc of diffusing translating tracks
%     'ampDiffMobileTr', amp vs dc of diffusing, mobile, translating
%     'fracTrConfined', fraction of translating RNA in confined tracks
%     'fracTrMobile', fraction of translating RNA in mobile tracks
%     'fracTr',     fraction of translating RNA in all tracks

setTackAnalysisParameter;
c1=colocAnaRes.c1;
c2=colocAnaRes.c2;
if length(c1) == 0 | length(c2)==0  %No particle
    resColocAna=[];
    return
end
selRRes=colocAnaRes.selRRes;
selGRes=colocAnaRes.selGRes;
indxTr=c1(:,1);
indxTrG=c1(:,2);   
distanceRG=c1(:,3);
indxNTr=setdiff(1:length(colocAnaRes.selR),indxTr)';

trackClass=vertcat(selRRes.classification);     %All tracks
dcFit=vertcat(selRRes.diffConstFit);     %All tracks
dc=vertcat(selRRes.diffConst);           %All tracks
stdPos=vertcat(selRRes.stdPos);
indxMobile=find(trackClass>1 & dcFit>threshMobile & stdPos>threshStdPos);
indxDiff=find(trackClass == 1 | trackClass ==2);
indxDiffMobile=find(trackClass==2 & dcFit>threshMobile & stdPos>threshStdPos);

indxConfined=find(trackClass==1 | (trackClass>=2 & (dcFit<=threshMobile & stdPos<threshStdPos)));   %stationary RNA
dcTr=dcFit(intersect(indxTr, indxDiff));    %DC for translating
dcNTr=dcFit(intersect(indxNTr, indxDiff));  %DC for Nontranslating
dcTrMobile=dcFit(intersect(indxTr, indxDiffMobile));    %DC for mobile,diff, translating RNA
dcNTrMobile=dcFit(intersect(indxNTr, indxDiffMobile));    %DC for mobile,diff, non-translating RNA

ampTr=vertcat(selGRes(indxTrG).amps);   %amp of All translating RNA

[~, indIndxDiff, indIndxTr]=intersect(indxDiff, indxTr);
ampDiffTr=[ampTr(indIndxTr) dcFit(indxDiff(indIndxDiff))]; %dc vs amp for all diffusing RNA 
dcTrG=vertcat(selGRes(indxTrG(indIndxTr)).diffConstFit);

[~, indIndxDiffMobile, indIndxTr]=intersect(indxDiffMobile, indxTr);
ampDiffMobileTr=[ampTr(indIndxTr) dcFit(indxDiffMobile(indIndxDiffMobile))];
dcTrGMobile=vertcat(selGRes(indxTrG(indIndxTr)).diffConstFit);

fracTrConfined=length(intersect(indxTr, indxConfined))/length(indxConfined);
fracTrMobile=length(intersect(indxTr, indxMobile))/length(indxMobile);
fracTr=length(indxTr)/length(selRRes);

resColocAna=struct( ...
    'indxTr', indxTr,               ...
    'indxTrG', indxTrG,             ...
    'distanceRG',distanceRG,        ...
    'indxNTr', indxNTr,             ...
    'trackClass', trackClass,       ...
    'indxMobile', indxMobile,       ...
    'indxDiff', indxDiff,           ...
    'indxDiffMobile', indxDiffMobile, ...
    'indxConfined', indxConfined,   ...
    'dcFit', dcFit,                 ...
    'dc',  dc,                      ...
    'dcTr', dcTr,                   ...
    'dcNTr', dcNTr,                 ...
    'dcTrMobile', dcTrMobile,       ...
    'dcNTrMobile', dcNTrMobile,     ...
    'dcTrG', dcTrG,                 ...
    'dcTrGMobile', dcTrGMobile,     ...
    'stdPos', stdPos,               ...
    'ampTr', ampTr,                 ...
    'ampDiffTr', ampDiffTr,         ...
    'ampDiffMobileTr', ampDiffMobileTr, ...
    'fracTrConfined', fracTrConfined, ...
    'fracTrMobile', fracTrMobile,   ...
    'fracTr', fracTr);
end