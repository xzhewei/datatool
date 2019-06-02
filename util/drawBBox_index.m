function fig = drawBBox_index(set,type,f,bbox,col,ls,lw)
[pthl,~,~] = dbInfo(set);
pth = pthl;
pth_img = [pth '/extract/' type '/images/'];
imglist = dir(pth_img);
I = imread([pth_img imglist(f+2).name]);
fig = figure(f);imshow(I,'border','tight');
if isempty(lw)
    lw = 2;
end
for i = 1:size(bbox,1)
    hs = bbApply( 'draw', bbox(i,:), col, lw, ls);
end
end