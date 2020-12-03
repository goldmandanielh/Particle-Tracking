function td=tracksTimeDist(tracks)
%Obj: Calculate the distance in time between tracks. 
%History
% July 26, 2019: Allows the end of one track to be the beggining of another
% track, set the distance between the 2 equal to 1, i.e., it could be
% linked

nT=length(tracks);
td=nan(nT);
sel=getTrackSEL(tracks);
for i=1:nT
    for j=i+1:nT
        if sel(i,1)<=sel(j,2) && sel(i,2)<sel(j,1)   %i is earlier than j, j can be linked after i
            td(i,j)=sel(j,1)-sel(i,2);
        elseif sel(i,1)>sel(j,2) && sel(i,2)>=sel(j,1)   % i is later than j, i can be linked to j
            td(j,i)=sel(i,1)-sel(j,2);
        elseif sel(i,1)<=sel(j,2) && sel(i,2)==sel(j,1) % i is earlier than j, the end of i is the beginning of j
            td(i,j)=1;      %set to 1, it should be 0;
        elseif sel(i,1)==sel(j,2) && sel(i,2)>=sel(j,1)   % i is later than j, the end of j is the beginning of i
            td(j,i)=1;      %set to 1, it should be 0;
%         else
%             td(i,j)=0;
        end
    end
end
end