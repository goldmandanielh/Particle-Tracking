function [co,s1,s2] = tracksGetColocWMaxOverlap(tracksR,tracksG,thresh,imageGap, minTimeOverlap, maxDistance, transformPara, dist)
%Obj: 
%   find colocalized tracks within threshold and choose the one with
%   maximal overlap time
%
%Input Para

%outputs:
%co is the array that gives the matched indices of the colocalized spots:
% co = [i1,i2,dist,overlapTime]
%s1 and s2 are the arrays of indices of the left out tracks (no match in the
%other list)
%s1 = [i1]
%s2 = [i2]
%%
%number of spots in each array
nr = length(tracksR); ng = size(tracksG,1);
%distance matrix between all track pairs form tracksR and tracksG
if nargin<8
    dist=calcTrackDistMat(tracksR, tracksG, imageGap, minTimeOverlap, maxDistance, transformPara);
end

%this is the array of the matched spots. Empty by default.
co = zeros(max(nr,ng),4); 
s1 = 1:nr;
s2 = 1:ng;
ic1 = 0; 
for i= 1:nr
    indColocG=find(dist(i,:)<thresh);   %All green tracks within the threshold
    nColocG=length(indColocG);
    
    if (nColocG>1)      %If more than one candidate, choose the one with longest overlap. By now, if more than one non-overlaping tracks colocalize, they have been joined
        overlapTime=zeros(nColocG,1);   %calculate overlap time
        for j=1:nColocG
            overlapTime(j)=length(trackOverlapTimePos(tracksR(i), tracksG(indColocG(j)), imageGap));
        end
        [mxOverlapG, k]=max(overlapTime);
        colocIndxG=indColocG(k);
    elseif nColocG==1
        colocIndxG=indColocG;
        mxOverlapG=length(trackOverlapTimePos(tracksR(i), tracksG(colocIndxG), imageGap));
    else
        continue;   %This track does not have any colocalized green track
    end
    
    %Test if the the green track colocIndx also has maximum overlap with
    %the current red track. Do I have to do this? 
    indColocR=find(dist(:, colocIndxG)<thresh);
    nColocR=length(indColocR);
    if (nColocR>1)
        overlapTime=zeros(nColocR,1);
        for j=1:nColocR
            overlapTime(j)=length(trackOverlapTimePos(tracksR(indColocR(j)), tracksG(colocIndxG), imageGap));
        end
        [mxOverlapR,k]=max(overlapTime);
        colocIndxR=indColocR(k);
    elseif nColocR==1
        colocIndxR=indColocR;
        mxOverlapR=length(trackOverlapTimePos(tracksR(colocIndxR), tracksG(colocIndxG), imageGap));
    else
        continue;
    end
    if(i==colocIndxR)   %Mutally agree
        %Adding the indices to the co array
        ic1=ic1+1;
        co(ic1,1)=i;
        co(ic1,2)=colocIndxG;
        co(ic1,3)=dist(colocIndxR, colocIndxG);
        co(ic1,4)=mxOverlapR;
%         co(ic1,5)=mxOverlapG;
        %remove the first arr indx
        j1=find(s1 == colocIndxR);
        if j1 ~= length(s1)
            s1(j1:length(s1)-1)=s1(j1+1:length(s1));
        end
        s1=s1(1:length(s1)-1);
        j2=find(s2 == colocIndxG);
        if j2 ~= length(s2)
            s2(j2:length(s2)-1) = s2(j2+1:length(s2));
        end
        s2 = s2(1:length(s2)-1);
    end
end

if ic1 ~= 0
    co = co(1:ic1,1:4);
else
    co = [0,0];
end
clear('dist');
end