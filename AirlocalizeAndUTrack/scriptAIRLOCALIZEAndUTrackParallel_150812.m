%matlabpool 2

% dataDir='F:\HS\150812_tmH+phR-scFV+pBabe-osT_sorted\1_transient cyt-24xst-oxB-AID\analysis\';
% %for red channel, the best parameter is sigma=1.32, nlo=6, nhi=3, level=4;
% sigma=1.32;
% thresh=4;
% nlo=6;
% nhi=3;
% baseName='C1-corrStr';
% parfor dataID=11:11;
%     [res,tracksFinal,movieInfo]=airLocalizeAndUTrack(sigma, thresh, nlo, nhi, dataDir,baseName, dataID, ['corrStr',num2str(dataID) '_mask.mat']); 
% end
% 
% sigma=1.25;
% thresh=5;
% nlo=10;
% nhi=3;
% baseName='C2-corrStr';
% parfor dataID=7:7;
%     [res,tracksFinal,movieInfo]=airLocalizeAndUTrack(sigma, thresh, nlo, nhi, dataDir,baseName, dataID, ['corrStr',num2str(dataID) '_mask.mat']); 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataDir='F:\HS\150812_tmH+phR-scFV+pBabe-osT_sorted\3_transient cyt-24xst-fluc-oxB-AID\analysis\';
%for red channel, the best parameter is sigma=1.32, nlo=6, nhi=3, level=4;
sigma=1.32;
thresh=6;
nlo=6;
nhi=3;
baseName='C1-corrStr';
parfor dataID=8;
    [res,tracksFinal,movieInfo]=airLocalizeAndUTrack(sigma, thresh, nlo, nhi, dataDir,baseName, dataID, ['corrStr',num2str(dataID) '_mask.mat']); 
end

sigma=1.25;
thresh=5;
nlo=10;
nhi=3;
baseName='C2-corrStr';
parfor dataID=8;
    [res,tracksFinal,movieInfo]=airLocalizeAndUTrack(sigma, thresh, nlo, nhi, dataDir,baseName, dataID, ['corrStr',num2str(dataID) '_mask.mat']); 
end

matlabpool close
