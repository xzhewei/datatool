function drawBBox(s,v,f,bbox,col,ls,lw)
s = s+1;
v = v+1;
[pthl,setIds,vidIds] = dbInfo('scut');
pth = pthl;
name=sprintf('set%02d/V%03d',setIds(s),vidIds{s}(v));
sr=seqIo([pth '/videos/' name '.seq'],'reader'); info=sr.getinfo();
sr.seek(f-1); I=sr.getframe();
fig = figure(11);imshow(I,'border','tight');
if isempty(lw)
    lw = 2;
end
for i = 1:size(bbox,1)
    hs = bbApply( 'draw', bbox(i,:), col, lw, ls);
end
end