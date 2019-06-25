function [ fig ] = showImg_index( set,type,f )
%SHOWIMG_INDEX 基于文件夹中的序号显示图片
[pthl,~,~] = dbInfo(set);
pth = pthl;
pth_img = [pth '/extract/' type '/images/'];
imglist = dir(pth_img);
I = imread([pth_img imglist(f+2).name]);
fig = figure(f);
% TODO: make the visible as a args
fig.Visible='off';
imshow(I,'border','tight');
end

