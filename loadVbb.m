function A = loadVbb( s, v )
% Load given annotation (caches AS for speed).
persistent AS pth sIds vIds; [pth1,sIds1,vIds1]=dbInfo;
if(~strcmp(pth,pth1) || ~isequal(sIds,sIds1) || ~isequal(vIds,vIds1))
  [pth,sIds,vIds]=dbInfo; AS=cell(length(sIds),1e3); end
A=AS{s,v}; if(~isempty(A)), return; end
fName=@(s,v) sprintf('%s/annotations/set%02i/V%03i.txt',pth,s,v); % for scut
A=vbb('vbbLoad',fName(sIds(s),vIds{s}(v))); AS{s,v}=A;
end