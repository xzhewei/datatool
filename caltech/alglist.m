function algs = alglist()
n=1000; clrs=zeros(n,3);
for i=1:n, clrs(i,:)=max(.3,mod([78 121 42]*(i+1),255)/255); end
% algs = CSP(clrs);
% algs = FCOS(clrs);
algs = paper_GPCAnet(clrs)
end

function algs = paper_GPCAnet(clrs)
algs = {  
  'ACF',       0, clrs(6,:),   '-'
  'MS-CNN',       0, clrs(10,:),   '--'
  'RPN+BF',       0, clrs(11,:),   '--'
  'AdaptFasterRCNN',       0, clrs(9,:),   '-'
%   'GPCAnet',       0, clrs(12,:),   '-'  
  'FasterR-CNN',  0, clrs(7,:),  '--'
%   'GPCAnet-filter',       0, clrs(12,:),   '-'
  'FRCNN-ratio2', 0, clrs(12,:), '-'
%   'RetinaNet', 0, clrs(13,:),  '-'
%   'GPCAnet-RetinaNet', 0, clrs(14,:),  '-'
%   'RetinaNet-far', 0, clrs(13,:),  '-'
%   'GPCAnet-RetinaNet-far', 0, clrs(14,:),  '-'
};
end

function algs = CSP(clrs)
algs = {  
  'CSP-h-off-079',       0, clrs(6,:),   '-'
};
end

function algs = FCOS(clrs)
algs = {  
  'FCOS_new',       0, clrs(6,:),   '-'
  'RPN+BF',     0, clrs(7,:), '_'
  'RetinaNet',     0, clrs(8,:), '_'
};
end