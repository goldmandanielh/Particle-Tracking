function [resOut]=selPointsInROI(res, bwMask)
%given the detection results from Air Localize, keep the points in mask

nR=length(res);
[sy,sx]=size(bwMask);
resOut=repmat(struct('final_spots', [], 'final_pix',[], 'params',res(1).params),1,nR);
for i=1:nR
    x=res(i).final_pix(:,2);
    y=res(i).final_pix(:,1);
    ind=sy*(ceil(x)-1)+round(y);
    indSel=bwMask(ind(~isnan(ind)));
    resOut(i).final_pix=res(i).final_pix(find(indSel),:);
    resOut(i).final_spots=res(i).final_spots(find(indSel),:);
end
end