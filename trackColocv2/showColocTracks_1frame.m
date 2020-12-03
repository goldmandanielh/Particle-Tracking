function F=showColocTracks(tracksR, tracksG, co, para, stackR, stackG, imageGap, startEnd)
%Obj: 
%   Given two sets of tracks in red and green channel, plot colocalized
%   tracks given in co
%Input
%   tracksR, tracksG: the red and green tracks respectively
%   co: the colocalization array: [i1, i2, dist, distT; ...]
%   para: the transformation parameter between the two channel
%   stackR: the Red image
%   stackG: the green image
%   imageGap: the different image interval between Red and Green
%   startEnd: [start, end] frames to show
%Output
%   F: movie structure
close all;
tracksR=tracksR(co(:,1));
tracksG=tracksG(co(:,2));
trackSELR=getTrackSEL(tracksR);
trackSELG=getTrackSEL(tracksG);
nT=length(tracksR);
nIm=size(stackG,3);
if nargin < 8
    startEnd=[1,nIm];
end
monitor = 0;
imInd = startEnd(1);
while monitor == 0;
    imr=stackR(:,:,ceil(imInd/imageGap));
    img=stackG(:,:,imInd);
    imshow(imfuse(imadjust(imr,[0,0.1]), imadjust(img,[0, 0.05],[]), 'falsecolor', 'Scaling', 'independent', 'ColorChannels', [1,2,0]));
    hold on;
    for iTracks=1
        timeR=ceil(imInd/imageGap);
        if trackSELR(iTracks,1) <= timeR
            [x,y,a,t]=extractCoordinateAmpFromTrack(tracksR(iTracks));
            if (trackSELR(iTracks,2) > timeR)    %the track is not finished
                ind=timeR-trackSELR(iTracks,1)+1;
            else
                ind=trackSELR(iTracks,2)-trackSELR(iTracks,1)+1;         
            end
            plot(x(1:ind),y(1:ind),'--r', 'LineWidth',2);
            plot(x(1),y(1),'rs','LineWidth',2,'MarkerSize',10);   %start with a green square
            h3=plot(x(ind),y(ind),'ro', 'LineWidth',2, 'MarkerSize',10);
        end
        
        if trackSELG(iTracks,1) <= imInd
            monitor = 1;
            [x,y,a,t]=extractCoordinateAmpFromTrack(tracksG(iTracks));
            if (trackSELG(iTracks,2) > imInd)    %the track is not finished
                ind=imInd-trackSELG(iTracks,1)+1;
            else
                ind=trackSELG(iTracks,2)-trackSELG(iTracks,1)+1;         
            end
            plot(x(1:ind),y(1:ind),'--g', 'LineWidth',2);
            plot(x(1),y(1),'gs','LineWidth',2,'MarkerSize',10);   %start with a green square
            h3=plot(x(ind),y(ind),'go', 'LineWidth',2, 'MarkerSize',10);
        end
    end
    %pause(0.1);
    %waitforbuttonpress;
    F(imInd)=getframe;
    if exist('h3')
        set(h3,'visible', 'off');
        clear h3;
    end
    hold off;
    imInd = imInd + 1;
end
end