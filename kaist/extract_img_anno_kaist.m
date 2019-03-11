% extract_img_anno_kaist()
% 
% Copyright (c) 2017, Zhewei Xu
% -------------------------------------------------------
function extract_img_anno_kaist(pth, tDir)
if nargin == 0
    pth = 'E:\Datasets\kaist';
    tDir = 'E:\Datasets\kaist\extract\';
end

% for s=1:2
%   if(s==1), type='test'; skip=[]; else type='train'; skip=3; end
%   dbInfo(['kaist-all-' type]);
%   if(exist([tDir type '/annotations'],'dir')), continue; end
%   dbExtract3(pth,[tDir type],'lwir',1,skip);
% end
% 
type='test'; cond='all'; spec='visible'; skip=1;
dbInfo(['kaist-' type '-' cond]);
type=[type '-' cond '-' spec '-' int2str2(skip,2)];
if(~exist([tDir type '/annotations'],'dir'))
    dbExtract_kaist([tDir type],spec,1,skip,pth); 
end

type='train'; cond='all'; spec='visible'; skip=1;
dbInfo(['kaist-' type '-' cond]);
type=[type '-' cond '-' spec '-' int2str2(skip,2)];
if(~exist([tDir type '/annotations'],'dir'))
    dbExtract_kaist([tDir type],spec,1,skip,pth); 
end

end


