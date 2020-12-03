function amp=getTrackAmpInterpGap(track)
%Obj: extract the amplitude of a track, only for continous track with
%potential gap, not for tracks joined by linkTracks
%   for track gap, using interpolation to get the intensity. 
amp=track.tracksCoordAmpCG(4:8:end);
indx=find(~isnan(amp));     %the valid time points
indxNan=find(isnan(amp));   %Gap points
for ind=indxNan 
   indL=max(indx(indx<ind)); %the gap will not be in the beginning or end
   indU=min(indx(indx>ind));
   amp(ind)=interp1([indL, indU],amp([indL, indU]), ind);
end
end