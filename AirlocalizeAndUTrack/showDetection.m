function  F=showDetection( detRes, stack, saveMovie)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%Example
%  img=tiffread5('')
numImage=length(detRes);
sz=size(stack);
if length(sz) == 3 
    if sz(3) ~= numImage
        display('showDetection: the dimension of detRes and stack do not agree');
        return;
    end
end
for imInd=1:numImage
    imshow(stack(:,:,imInd),[]);
    hold on
    plot(detRes(imInd).final_pix(:,2),detRes(imInd).final_pix(:,1),'ro','MarkerSize',10);
    pause(0.05);
    F(imInd)=getframe;
    hold off
end
%     movie(F);
end

