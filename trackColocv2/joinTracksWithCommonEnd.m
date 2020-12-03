function trackOut=joinOverlapedTracks(track1, track2)
sel1=trackSEL(track1);
sel2=trackSEL(track2);
sel=[min([sel1(1),sel2(1)]), max([sel1(2),sel2(2)]), 
end