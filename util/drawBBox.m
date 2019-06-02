function [fig] = drawBBox(set,s,v,f,bbox,col,ls,lw)
% drawwBBox('usa',7,10,200,bbox,'r','-',2)
% 从数据集set中�?择set07_V010_I00199帧按照bbox绘制图片
s = s+1;
v = v+1;
[pthl,setIds,vidIds] = dbInfo(set);
pth = pthl;
name=sprintf('set%02d/V%03d',setIds(s),vidIds{s}(v));
sr=seqIo([pth '/videos/' name '.seq'],'reader'); info=sr.getinfo();
sr.seek(f-1); I=sr.getframe();
fig = figure;imshow(I,'border','tight');
if isempty(lw)
    lw = 2;
end
for i = 1:size(bbox,1)
    hs = bbApply( 'draw', bbox(i,:), col, lw, ls);
end
end