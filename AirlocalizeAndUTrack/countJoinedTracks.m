function [verIndOut, currentIndOut,currentPathOut]=countJoinedTracks(adjmat, currentInd, verInd,currentPathIn)
%This function will form all the joined tracks that are compatible in time
%Then it will allow the driver function to determine the minimum number of
%tracks in the movie
%Note: I have used a recursive function to achieve the goal
%adjmat: the adjacent matrix, which determine the allowed joining between
%       tracks
%currentInd: the current index of tracks to determine
%verInd: The rest indx to be joined
%currentPathIn: the current joined tracks


%I have to use this global variable. I don't know how to do without it
%It saves all combinations of time compatible compound tracks
global totalPath;    
if isempty(verInd)      %When there is no more track segment, it means all segment have been used, so save it in the global varialbe totalPath
    verIndOutTmp=[];
    currentIndOutTmp=[];
    totalPath=[totalPath; currentPathIn];
    currentPathOutTmp=[currentPathIn; {{}}];
else
    aviInd=intersect(find(~isnan(adjmat(currentInd, :))),verInd);   %In the rest of verInd, find the compatible segments that can be linked to the current segment
    for i=1:length(aviInd)  %only when there is available segment
        currentIndOutTmp1=aviInd(i);    %link to each of the possible segment
        verIndOutTmp1=setdiff(verInd,currentIndOutTmp1);%remove it from the rest.
        np1=length(currentPathIn);      %how many total paths
        ns=length(currentPathIn{np1});  %There are ns subtracks in the current track
        if ns>0
            currentPathOutTmp1=currentPathIn;
            currentPathOutTmp1{np1}{ns}=[currentPathIn{np1}{ns} currentIndOutTmp1]; %add the current index
        else
            currentPathOutTmp1{np1}{1}=currentIndOutTmp1; %Otherwise, this will be the first segment
        end
        %Recursive call: join the rest of the segments
        [verIndOutTmp, currentIndOutTmp,currentPathOutTmp]=countJoinedTracks(adjmat,currentIndOutTmp1,verIndOutTmp1,currentPathOutTmp1);
        %return;
    end
    % if there is no available link, we have to add a new segment
    if isempty(aviInd)
        currentIndOutTmp2=verInd(1);
        verIndOutTmp2=verInd(2:end);
        currentPathOutTmp2=currentPathIn;
        np=length(currentPathOutTmp2);
        ns=length(currentPathOutTmp2(np));
        currentPathOutTmp2{np}=[currentPathOutTmp2{np} currentIndOutTmp2]; %add a new segment
        [verIndOutTmp, currentIndOutTmp,currentPathOutTmp]=countJoinedTracks(adjmat,currentIndOutTmp2,verIndOutTmp2,currentPathOutTmp2);
    end
end

verIndOut=verIndOutTmp;
currentIndOut=currentIndOutTmp;
currentPathOut=currentPathOutTmp;
end