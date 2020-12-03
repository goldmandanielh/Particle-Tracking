function F=showAllTracks(tracksFinal, stack)
%given a track structure, show all tracks
numTracks=length(tracksFinal);
trackSEL=getTrackSEL(tracksFinal);  %start, end, length
imshow(stack(:,:,1),[]);
hold on

for imInd=1:size(stack,3)
    imshow(stack(:,:,imInd),[]);
    hold on
    for iTracks=1:numTracks
        if trackSEL(iTracks,1) <= imInd
            [x,y,a,t]=extractCoordinateAmpFromTrack(tracksFinal(iTracks));
            if (trackSEL(iTracks,2) > imInd)    %the track is not finished
                ind=imInd-trackSEL(iTracks,1)+1;
            else
                ind=trackSEL(iTracks,2)-trackSEL(iTracks,1)+1;         
            end
            plot(x(1:ind),y(1:ind),'--r');
            plot(x(1),y(1),'gs','MarkerSize',10);   %start with a green square
            h3=plot(x(ind),y(ind),'ro', 'LineWidth',2, 'MarkerSize',10);
        end
    end
    pause(0.001);
    F(imInd)=getframe;
    if exist('h3')
        set(h3,'Visible', 'off');
        clear h3;
    end
    hold off
end

end