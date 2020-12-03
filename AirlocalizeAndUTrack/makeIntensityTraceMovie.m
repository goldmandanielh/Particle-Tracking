function F=makeIntensityTraceMovie(amps)
% %dataDir='F:\DS5\150916_WTNeuron_Suntag\1_flag-24xst-oxB-AID+osT-I-scFV-dNLS+tmH+pBabe-osT\analysis\';
% baseName='TS_ZS1_DendSBG';
% dataID=1;
% load(fullfile(dataDir,[baseName,num2str(dataID) '.mat']));
% F=makeIntensityTraceMovie(amp);
% savepath=[dataDir,'TS_ZS1_DendSBG1_IntensityTrace.avi'];
% movie2avi(F,savePath);

frameRate=15/60;
[nTracks,nT]=size(amps);
times=[1:nT]*frameRate-frameRate;
amps=vertcat(amps,times);
options={'go-', 'go-','ro-'};

for i=1:nT
    for j=1:nTracks
        plot(amps(2,1:i),amps(j,1:i),options{j},'LineWidth',1,'MarkerSize',3);
        axis([0,30,0,max(max(amps))]);
        set(gcf,'position',[100,200,640,480])
        set(get(gca,'XLabel'),'String','Time (min)','FontSize',16);
        set(get(gca,'YLabel'),'String','Intensity (AU)','FontSize',16);
        set(gcf,'color','w');
        set(gca, 'fontsize', 16);
        set(gca,'box','off');
        hold on;
    end
    pause(0.001);
    F(i)=getframe(gcf);
    hold off;
end
end