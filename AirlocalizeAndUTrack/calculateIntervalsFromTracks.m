function [intervalPos, intervalNeg]=calculateIntervalsFromTracks(amp,thresh,ignoreNegLength, ignorePosLength)
%Given the threshold, calculate the interval length of the translation
%pulse

%amp: the intensity value of the translation sites
%thresh: threshold above which it is considered as positive 
%ignoreNegLength: the length of negtive to be ignored and considered as positive

if nargin<3
    ignoreNegLength=1;
end
if nargin<4
    ignorePosLength=1;
end

nTracks=size(amp,1);
% nT=size(amp,2);
intervalPos=[];
intervalNeg=[];
for i=1:nTracks
    pos=amp(i,:)>=thresh;
    neg=amp(i,:)<thresh;
    
    indxPos=find(pos);      %First to remove the single positive point
    [np,indxConsPos]=consequtiveIndex(indxPos); %find consequtive index in indxPos
    singlePos=find(np<=ignorePosLength);
    for j=1:length(singlePos)
        startInd=indxPos(indxConsPos(singlePos(j)));
        neg(startInd:startInd+np(singlePos(j))-1)=true;
        pos(startInd:startInd+np(singlePos(j))-1)=false;
    end
    
    indxNeg=find(neg);      %Then to remove single negative point
    [nn,indxConsNeg]=consequtiveIndex(indxNeg);  
    singleNeg=find(nn<=ignoreNegLength);      
    for j=1:length(singleNeg)
        startInd=indxNeg(indxConsNeg(singleNeg(j)));
        pos(startInd:startInd+nn(singleNeg(j))-1)=true;
        neg(startInd:startInd+nn(singleNeg(j))-1)=false;        
    end

    indxPos=find(pos);     %positive
    [np,indxConsPos]=consequtiveIndex(indxPos); %consequtive positive indx
    intervalPos=[intervalPos np];
    
    indxNeg=find(neg);     %positive
    [np,indxConsNeg]=consequtiveIndex(indxNeg); %consequtive positive indx
    intervalNeg=[intervalNeg np];    
end


end