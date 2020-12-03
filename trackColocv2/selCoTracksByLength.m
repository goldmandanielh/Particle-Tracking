function [ tGCoSel, tGNonCoSel, tRCoSel,  tRNonCoSel]=selCoTracksByLength(tracksR, tracksG, co, s1, s2, lenThreshR, lenThreshG)
%Obj: 
%   Select colocalized and noncolocalized tracks according to the length
%Input Para
%   tracksR: track array for the red channel
%   tracksG: track array for green channel
%   co: the colocalization array [i1, i2, dist, overlapTime]
%   s1: the non colocalized indices of red tracks
%   s2: the non colocalized indices of green tracks
%   lenThreshR: the length threshold of the red channel, note that the two channel may have different imaging interval, that's why we should set different length threshold
%   lenThreshG: the length threshold of the green channel 
%Output para
%   tGCoSel: the selected colocalized green tracks
%   tGNonCoSel: the selected non colocalized green tracks
%   tRCoSel: the selected colocalized red tracks
%   tRNonCoSel: the selected non colocalized red tracks

tRCo=tracksR(co(:,1));  %colocalized red tracks
tGCo=tracksG(co(:,2));  %colocalized green tracks
lengthtR=tracksLengthExcludeGap(tRCo);  %Get the length of the tracks excluding the Nan value
lengthtG=tracksLengthExcludeGap(tGCo);
ind=(lengthtR>lenThreshR) | (lengthtG>lenThreshG);   %For coloc tracks, make sure at least one channel has track length longer than threshold
tRCoSel=tRCo(ind);  %selected colocalized tracks
tGCoSel=tGCo(ind);

%For non colocalized tracks
tRNonCo=tracksR(s1);  %colocalized red tracks
tGNonCo=tracksG(s2);  %colocalized green tracks
lengthtR=tracksLengthExcludeGap(tRNonCo);  %Get the length of the tracks excluding the Nan value
lengthtG=tracksLengthExcludeGap(tGNonCo);
tRNonCoSel=tRNonCo(lengthtR>lenThreshR);
tGNonCoSel=tGNonCo(lengthtG>lenThreshG);
end