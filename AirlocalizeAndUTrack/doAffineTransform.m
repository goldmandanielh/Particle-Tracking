function [atmat xy1, xy2]=doAffineTransform(tracksR, tracksG, c1)
%Given a set of coordinates, affine transform the 2nd one such that it has
%minimum distance to the first one. 

%x1=ax-by+c, y1=bx+ay+d; where a=s.cosa, b=-s.sina and s=sqrt(a^2+b^2)
nc=size(c1,1);
xy1=zeros(nc,2);
xy2=zeros(nc,2);
for i=1:nc
    [xyr, xyg]=getTracksCommonStartPos(tracksR(c1(i,1)), tracksG(c1(i,2)));
    xy1(i,:)=xyr;
    xy2(i,:)=xyg;
end
atmat0=[1, 0, 0, 0];
% xy2=[x2(:)'; y2(:)']';
% xy1=[x1(:)'; y1(:)']';
atmat=lsqcurvefit(@affineTransformXY, atmat0, xy2(:), xy1(:));

end