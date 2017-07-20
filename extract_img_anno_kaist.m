% extract_img_anno_kaist()
% 从KAIST数据集中提取帧图像和帧标注文件
% -------------------------------------------------------
% Copyright (c) 2017, Zhewei Xu
% -------------------------------------------------------
pth = '/mnt/RD/DataSet/KAIST/data-kaist-lwir/';
tDir = './datasets/kaist_lwir/';

for s=1:2
  if(s==1), type='test'; skip=[]; else type='train'; skip=3; end
  dbInfo3(['kaist-lwir-all-' type]);
  if(exist([tDir type '/annotations'],'dir')), continue; end
  dbExtract3(pth,[tDir type],'lwir',1,skip);
end

