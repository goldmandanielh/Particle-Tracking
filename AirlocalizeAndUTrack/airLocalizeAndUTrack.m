function [res, tracksFinal,movieInfo, p]=airLocalizeAndUTrack(sigma, thresh, nlo,nhi,dataDir, baseName, dataID, roiMaskFile, timeWindow, minTrackLen, maxSearchRadius)
%do airlocalize and u-track given the initial parameters

setAirLocalizeParameter;
p.sigma_xy=sigma;
p.thresh.level=thresh;
p.filter.nlo=nlo;
p.filter.nhi=nhi;
p.data_dirname=dataDir;
p.save_dirname=dataDir;
p.data_stackname=[baseName '.tif'];
[res, movieInfo]=AIRLOCALIZE_standalone(p);
if nargin>7     %select only the points in the mask
    load(fullfile(dataDir, roiMaskFile));
    res=selPointsInROI(res,msk);
end
movieInfo=output_trajectories_as_structure_from_res2(res);
% scriptTrackGeneral;
tracksFinal=uTrackStandalone(movieInfo,timeWindow, minTrackLen, maxSearchRadius);
save([dataDir,baseName '.mat'], 'res','tracksFinal','movieInfo','p');
end