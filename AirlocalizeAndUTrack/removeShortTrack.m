function [ indx ] = removeShortTrack( tracks, threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
lengths=tracksLengthExcludeGap(tracks);
indx=find(lengths >= threshold);

end

