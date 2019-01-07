function extract_img_anno_scut(pth, tDir)
% extract_img_anno_scut()
% 
% Copyright (c) 2017, Zhewei Xu
% -------------------------------------------------------
if nargin == 0
    pth = 'E:\Datasets\scut';
    tDir = 'E:\Datasets\scut\extract\';
end

% type='test'; skip=1;
% dbInfo(['scut' type]);
% type=['test' int2str2(skip,2)];
% if(~exist([tDir type '/annotations'],'dir'))
%     dbExtract_scut([tDir type],1,skip,pth); 
% end

type='train'; skip=1;
dbInfo(['scut' type]);
type=['train' int2str2(skip,2)];
if(~exist([tDir type '/annotations'],'dir'))
    dbExtract_scut([tDir type],1,skip,pth); 
end

end


