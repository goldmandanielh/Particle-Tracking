function [c1,c2] = getNearestTrackThresholdInclusive(tracksR,tracksG,atmat,...
    threshold)
%getNearestTrackThreshold: to calculate the closest track between two 
%   channel image
%tracksG: trackFinal obtained from u-track for green channel
%tracksR: ... for red channel
%atmat: The affine transformation matrix to transform G to R
%threshold is the maximum distance allowed between two tracks

%outputs:
%co is the array that gives the matched indices of two tracks
% co = [i1,i2,dist]
%s1 and s2 are the arrays of indices of the left out tracks (no match in the
%other list)
%s1 = [i1]
%s2=[i2]

%%
%number of tracks in each array
n1 = length(tracksR); n2 = length(tracksG);

if(n1 == 0 | n2 ==0)
    c1=[];
    c2=[];
    return;
end
%distance matrix between all tracks pairs form G and R
dist = calcDistanceMatrix(tracksR,tracksG, atmat);

if threshold == -1
    threshold = max(max(dist))+1;
end

%% nearest neighbor finding
%this is the array of the matched spots. Empty by default.
c1 = zeros(n1,3);
c1(:,1)=1:n1;
c2=zeros(n2,3);
c2(:,1)=1:n2;

for j= 1:n1
    [min_dist k] = min( dist(j,:));
    c1(j,2:3)=[k min_dist];
end

for j= 1:n2
    [min_dist k] = min( dist(:,j));
    c2(j,2:3)=[k min_dist];
end
indx=find(c1(:,3) < threshold);
c1=c1(indx,:);

indx=find(c2(:,3) < threshold);
c2=c2(indx,:);
clear('dist');
end