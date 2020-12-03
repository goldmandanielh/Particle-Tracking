
%%
dataDir='/Users/Daniel/Documents/GreenLab/IDrive-Sync/SunTagData/201124/';
dataID =[];

files={'sample1_2_1_green'};

for i = 1:numel(files);
    baseName=files{i};

    img=imread([dataDir baseName num2str(dataID) '.tif']);
    % img=imread([dataDir 'C2-Str' num2str(dataID) '.tif']);
    % img=imread([dataDir baseName num2str(dataID) '.tif']);

    h=imshow(img,'DisplayRange',[]);
    hold on;
    hroi=impoly();
    msk=createMask(hroi, h);
    save([dataDir baseName num2str(dataID) '_mask.mat'],'msk');
end