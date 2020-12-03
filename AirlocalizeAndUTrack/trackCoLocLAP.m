function [co, s1, s2]=trackCoLocLAP(tracks1, tracks2, threshold)
%tracks1: (n col)        tracks2 = (m rows)
%threshold is the maximum distance allowed between colocalized tracks

%outputs:
%co is the array that gives the matched indices of the colocalized tracks:
% co = [i1,i2,dist]
%s1 and s2 are the arrays of indices of the left out spots (no match in the
%other list)

n=length(tracks1); m=length(tracks2);
NONLINK_MARKER=-1;
probDim=2;
%Creat the cost matrix, only use 2d distance
dist=calcDistanceMatrix(tracks1, tracks2); %dist matrix, nxm
maxDist=max(max(dist));
searchRadius=10*threshold;
dist(isnan(dist))=maxDist;
%dist(dist > searchRadius)=NONLINK_MARKER;
noLinkingCost=threshold;
%noLinkingCost=searchRadius;

d12=zeros(n)+NONLINK_MARKER+eye(n)*(-NONLINK_MARKER+noLinkingCost);
d21=zeros(m)+NONLINK_MARKER+eye(m)*(-NONLINK_MARKER+noLinkingCost);
d22=ones(m,n);
cc=[dist, d12; d21, d22];

%calling LAP, return the index of matching pair. 
[c1, c2]=lap(cc, NONLINK_MARKER);
i1=find(c1(1:n)<=m);        %the matching indices should be less than m. 
i2=double(c1(i1));                  %these are indices of pos2 matched to pos1
d=dist((i2-1)*n+i1);

co=[i1, i2, d];     %colocalizing tracks
s1=setdiff(1:n, i1)';   %the rest noncolocalizing tracks
s2=setdiff(1:m, i2)';

end