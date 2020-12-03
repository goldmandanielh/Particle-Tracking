function tracksOut=selTracksByLength(tracks, lenThresh)
%obj: return tracks with length longer than threshold
%
sel=getTrackSEL(tracks);
tracksOut=tracks(sel(:,3)>lenThresh);
end