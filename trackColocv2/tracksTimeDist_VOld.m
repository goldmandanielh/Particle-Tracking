function td=tracksTimeDist(tracks)

nT=length(tracks);
td=nan(nT);
sel=getTrackSEL(tracks);
for i=1:nT
    for j=i+1:nT
        if sel(i,1)<=sel(j,2) && sel(j,1)>=sel(i,2)   %i is earlier than j, j can be linked after i, including the overlap
            td(i,j)=sel(j,1)-sel(i,2);
        elseif sel(i,1)>=sel(j,2) && sel(j,1)<=sel(i,2)   % i is later than j, i can be linked to j, including the overlap
            td(j,i)=sel(i,1)-sel(j,2);
%         else
%             td(i,j)=0;
        end
    end
end
end