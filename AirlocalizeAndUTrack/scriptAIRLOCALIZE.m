dataDir='E:\Data\temp\';
setAirLocalizeParameter;
p.sigma_xy=1.35;
p.thresh.level=5;
p.data_dirname=dataDir;
p.save_dirname=dataDir;
stackNameBase='C1-MAXNDExpSeq000';
for dataID=1:1;
    p.data_stackname=[stackNameBase num2str(dataID) '.tif'];
    [res, movieInfo]=AIRLOCALIZE_standalone(p);
    movieInfo=output_trajectories_as_structure_from_res2(res);
    scriptTrackGeneral;
    save([dataDir,stackNameBase num2str(dataID) '.mat'], 'tracksFinal','movieInfo', 'msk')
end
% 
% p.sigma_xy=1.25;
% p.thresh.level=6;
% p.data_dirname='d:\Users\biwu\Desktop\tmp\150323\2_stable flag-24xsuntagV4-oxB-AID\analysis\';
% for dataID=1:25;
%     p.data_stackname=['C2-Str' num2str(dataID) '.tif'];
%     [res, movieInfo]=AIRLOCALIZE_standalone(p);
%     movieInfo=output_trajectories_as_structure_from_res2(res);
%     scriptTrackGeneral;
%     save([dataDir,'C2-Str' num2str(dataID) '.mat'], 'tracksFinal','movieInfo', 'msk')
% end