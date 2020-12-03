function showTracksRG(trackR, trackG, atmat,  imgStack)
if nargin<3
    atmat=[1,0,0,0];
end
if nargin<4
    
end
[xr,yr,ar,tr]=extractCoordinateAmpFromTrack(trackR);
[xg,yg,ag,tg]=extractCoordinateAmpFromTrack(trackG);
xyg=[xg(:); yg(:)];
xyg=affineTransformXY(atmat, xyg, 1);
xg=xyg(:,1)';
yg=xyg(:,2)';

% xg=xg-offset(1);
% yg=yg-offset(2);
Tmnr=min(tr);
Tmng=min(tg);
Tmn=min([Tmnr Tmng]);

Tmxr=max(tr);
Tmxg=max(tg);
Tmx=max([Tmxr Tmxg]);

xmn=min([xr xg]);
xmx=max([xr xg]);
ymn=min([yr yg]);
ymx=max([yr yg]);

figure
hold on
h1=plot(yr, xr);
h2=plot(yg, xg);
set(h1,'Visible', 'off');
set(h2,'Visible', 'off');
%axis([xmn,xmx, ymn,ymx]);
axis 'tight';

for i=Tmn:Tmx
    if i>Tmnr 
        ind=min([i Tmxr])-Tmnr+1;
        plot(yr(1:ind), xr(1:ind), '--r');
        h3=plot(yr(ind),xr(ind),'ro', 'LineWidth', 2, 'MarkerSize', 10);
    end
    
    if i>Tmng
        ind=min([i Tmxg])-Tmng+1;
        plot(yg(1:ind), xg(1:ind), '-g');
        h4=plot(yg(ind),xg(ind),'gs', 'LineWidth', 2, 'MarkerSize', 10);
    end
    pause(0.1);
    if exist('h3')
        set(h3,'Visible', 'off');
        clear h3;
    end
    if exist('h4')
        set(h4,'Visible', 'off');
        clear h4;
    end
end
h3=plot(yr(end),xr(end),'ro', 'LineWidth', 2, 'MarkerSize', 10);
h4=plot(yg(end),xg(end),'gs', 'LineWidth', 2, 'MarkerSize', 10);
end