function dispDetSeq(dataname,method,s,v)
[pth,sIds,vIds]=dbInfo(dataname);
vPth= sprintf('%s/videos/set%02i/V%03i.seq',pth,sIds(s),vIds{s}(v));
gPth= sprintf('%s/annotations/set%02i/V%03i.txt',pth,sIds(s),vIds{s}(v));
dPth= sprintf('%s/res/%s/set%02i/V%03i.txt',pth,method,sIds(s),vIds{s}(v));
detPlayer(vPth,gPth,dPth);
end