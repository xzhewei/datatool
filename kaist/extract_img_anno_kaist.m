% extract_img_anno_kaist()
% 从KAIST数据集中提取帧图像和帧标注文�?% -------------------------------------------------------
% Copyright (c) 2017, Zhewei Xu
% -------------------------------------------------------
pth = '/mnt/RD/DataSet/KAIST/data-kaist-lwir/';
tDir = './datasets/kaist_lwir/';

% for s=1:2
%   if(s==1), type='test'; skip=[]; else type='train'; skip=3; end
%   dbInfo(['kaist-all-' type]);
%   if(exist([tDir type '/annotations'],'dir')), continue; end
%   dbExtract3(pth,[tDir type],'lwir',1,skip);
% end

% type='test'; skip=25;
% dbInfo(['kaist-all-' type]);
% type=['test' int2str2(skip,2)];
% if(~exist([tDir type '/annotations'],'dir'))
%     dbExtract3([tDir type],'lwir',1,skip,pth); 
% end

type='train'; skip=75;
dbInfo(['kaist-' type '-all']);
type=['test' int2str2(skip,2)];
if(~exist([tDir type '/annotations'],'dir'))
    dbExtract3([tDir type],'lwir',1,skip,pth); 
end


