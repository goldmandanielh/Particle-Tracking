% matlabpool 2
%%


dataDir = '/Users/Daniel/Documents/GreenLab/IDrive-Sync/SunTagData/201114/';
files={'sample3_1_1_green','sample4_1_1_green'};


for k = 1:numel(files);
    sigma = 1.1;
    thresh = 3.9
    nlo=10;
    nhi=2;
    timeWindow=5;   %maximum allowed time gap (in frames) between a track segment end and a track segment start that allows linking them.
    minTrackLen=5;  %minimum length of track segments from linking to be used in gap closing.
    maxSearchRadius=10; %maximum allowed search radius. Again, if a feature's calculated search radius is larger than this maximum, it will be reduced to this maximum.

    baseName = files{k}
    for dataID=1:1;
        [res,tracksFinal,movieInfo]=airLocalizeAndUTrack(sigma, thresh, nlo, nhi, dataDir,baseName, dataID, [baseName '_mask.mat'],timeWindow, minTrackLen, maxSearchRadius); 
    end

    sigma = 1;
    thresh = 3.9; 
    nlo=7;
    nhi=1;
    timeWindow=5;   %maximum allowed time gap (in frames) between a track segment end and a track segment start that allows linking them.
    minTrackLen=5;  %minimum length of track segments from linking to be used in gap closing.
    maxSearchRadius=10; %maximum allowed search radius. Again, if a feature's calculated search radius is larger than this maximum, it will be reduced to this maximum.

    for dataID=1:1;
        [res,tracksFinal,movieInfo]=airLocalizeAndUTrack(sigma, thresh, nlo, nhi, dataDir,[baseName(1:end-5) 'red'], dataID, [baseName '_mask.mat'],timeWindow, minTrackLen, maxSearchRadius); 
    end

end
