function dispRes(gt,dt,iou)
maxImg = length(gt);
imgList=getImgList(maxImg);
scrsz = get(groot,'ScreenSize');
hf = figure;
% set(hf,'Position',[1 1 scrsz(3) scrsz(4)]);

curdir = fileparts(fileparts(mfilename('fullpath')));
output_dir = 'scut/results/vis/frcn';
output_dir = fullfile(curdir, output_dir);
mkdir_if_missing(output_dir);
for i = 1:size(imgList,1)
    s = imgList(i,1);
    v = imgList(i,2);
    f = imgList(i,3);
    subplot(2,2,1);
    fname = showImg(s,v,f);
    % show score
    hs = showRes(gt{i}, dt{i},'dtShow',0);
    title('Ground Truth');
    subplot(2,2,2);
    showImg(s,v,f);
    % show distance
    hs = showRes(gt{i}, dt{i});
    title('Detection');
    subplot(2,2,3);
    showImg(s,v,f);
    hs = showRes(gt{i}, dt{i},'gtShow',0);
    title('Detection Score');
    subplot(2,2,4);
    showImg(s,v,f);
    hs = showRes(gt{i}, iou{i},'gtShow',0);
    title('Detection IoU');
    fname = fullfile(output_dir,[fname '.jpg']);
    mkdir_if_missing(fileparts(fname));
%     print('ScreenSizeFigure','-dpng','-r0')
    saveas(hf,fname);
    pause(1);
end


end

function imgList=getImgList(numImg)
% get img index
index = 1;
imgList = zeros(numImg,3);
[pthl,setIds,vidIds,skip] = dbInfo('scuttest');
pth = pthl;
for si = 1:numel(setIds)
    for vi = 1:numel(vidIds{si})
        name=sprintf('set%02d/V%03d',setIds(si),vidIds{si}(vi));
        sr=seqIo([pth '/videos/' name '.seq'],'reader'); info=sr.getinfo();
        for i = skip:skip:info.numFrames
            imgList(index,:)=[setIds(si),vidIds{si}(vi),i];
            index = index + 1;
        end
    end
end
end

function fname = showImg(s,v,f)
% s = s+1;
% v = v+1;
pthl = dbInfo('scuttest');
pth = pthl;
% name=sprintf('set%02d/V%03d',setIds(s),vidIds{s}(v));
name=sprintf('set%02d/V%03d',s,v);
sr=seqIo([pth '/videos/' name '.seq'],'reader');
sr.seek(f-1); 
I=sr.getframe();
sr.close();
imshow(I,'border','tight');
fname = sprintf('set%02d_V%03d_I%05d',s,v,f);
disp(fname);
end