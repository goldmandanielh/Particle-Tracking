function showAllTracks(tracksFinal, atmat, stack)
%given a track structure, show all tracks
for i=1:20
    imshow(stack(:,:,i),[]);
    pause(0.1);
end

end