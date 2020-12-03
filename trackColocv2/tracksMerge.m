function trackMerged=tracksMerge(tracks)

tracksSEL=getTrackSEL(tracks);
startTim=min(tracksSEL(:,1));
endTime=max(tracksSEL(:,2));

end