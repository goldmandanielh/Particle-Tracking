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
lineWidth=1;
markerSize=8;
tracksR=tracksR(co(:,1));
tracksG=tracksG(co(:,2));
trackSELR=getTrackSEL(tracksR);
trackSELG=getTrackSEL(tracksG);
nT=length(tracksR);
nIm=size(stackG,3);
if nargin < 8
    startEnd=[1,nIm];
end
for imInd=startEnd(1) : startEnd(2)
    imr=stackR(:,:,ceil(imInd/imageGap));
    img=stackG(:,:,imInd);
    imshow(imfuse(imadjust(imr,[0,0.2]), imadjust(img,[0, 0.1],[]), 'falsecolor', 'Scaling', 'independent', 'ColorChannels', [1,2,0]));
    hold on;
    for iTracks=1:nT
        timeR=ceil(imInd/imageGap);
        if trackSELR(iTracks,1) <= timeR
            [x,y,a,t]=extractCoordinateAmpFromTrack(tracksR(iTracks));
            if (trackSELR(iTracks,2) > timeR)    %the track is not finished
                ind=timeR-trackSELR(iTracks,1)+1;
            else
                ind=trackSELR(iTracks,2)-trackSELR(iTracks,1)+1;         
            end
            plot(x(1:ind),y(1:ind),'--r', 'LineWidth',lineWidth);
            plot(x(1),y(1),'rs','LineWidth',lineWidth,'MarkerSize',markerSize);   %start with a green square
            h3=plot(x(ind),y(ind),'ro', 'LineWidth',lineWidth, 'MarkerSize',markerSize);
        end
        
        if trackSELG(iTracks,1) <= imInd
            [x,y,a,t]=extractCoordinateAmpFromTrack(tracksG(iTracks));
            if (trackSELG(iTracks,2) > imInd)    %the track is not finished
                ind=imInd-trackSELG(iTracks,1)+1;
            else
                ind=trackSELG(iTracks,2)-trackSELG(iTracks,1)+1;         
            end
            plot(x(1:ind),y(1:ind),'--g', 'LineWidth',lineWidth);
            plot(x(1),y(1),'gs','LineWidth',lineWidth,'MarkerSize',markerSize);   %start with a green square
            h3=plot(x(ind),y(ind),'go', 'LineWidth',lineWidth, 'MarkerSize',markerSize);
        end
    end
%     pause(0.0001);
    F(imInd)=getframe;
    if exist('h3')
        set(h3,'visible', 'off');
        clear h3;
    end
    hold off;
end
end