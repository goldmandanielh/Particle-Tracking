function tracksJoinCompatible(adjmat, currentInd, verInd,currentPathIn, totalPathIn)
%This function will form all the joined tracks that are compatible in time
%Then it will allow the driver function to determine the minimum number of
%tracks in the movie
%Note: I have used a recursive function to achieve the goal
%adjmat: the adjacent matrix, which determine the allowed joining between
%       tracks
%currentInd: the current index of tracks to determine
%verInd: The rest indx to be joined
%currentPathIn: the current joined tracks, it is an array of indices


%I have to use this global variable. I don't know how to do without it
%It saves all combinations of time compatible compound tracks
global totalPathOut
if isempty(verInd)      %When there is no more track segment, it means all segment have been used, so save it in the global varialbe totalPath
    totalPathOut=[totalPathOut; currentPathIn];
%     currentPathOut=currentPathIn;
else
    avInd=intersect(find(~isnan(adjmat(currentInd, :))),verInd);   %In the rest of verInd, find the compatible segments that can be linked to the current segment
    for i=1:length(avInd)  %only when there is available segment
        currentIndOut1=avInd(i);    %link to each of the possible segment
        verIndOut1=setdiff(verInd,currentIndOut1);%remove it from the rest.
        currentPathOut1=[currentPathIn currentIndOut1]; %add the current index        
        %Recursive call: join the rest of the segments
        tracksJoinCompatible(adjmat,currentIndOut1,verIndOut1,currentPathOut1, totalPathIn);
    end
    % if there is no available link, we have to add a new path
    if isempty(avInd)
        currentIndOut2=verInd(1);
        verIndOut2=verInd(2:end);
        currentPathOut2=currentIndOut2;
        tracksJoinCompatible(adjmat,currentIndOut2,verIndOut2,currentPathOut2, totalPathIn);
    end
end
end