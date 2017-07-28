pth = '/mnt/RD/DataSet/SCUT_FIR_101/data';
tDir = '/mnt/RD/DataSet/SCUT_FIR_101/scut/';
for s=1:2
  if(s==1), type='test'; skip=5;
  else, type='train'; skip=5;
  end
  dbInfo(['scut' type]);
  if(s==1), type=['test' int2str2(skip,2)]; end
  if(s==2), type=['train' int2str2(skip,2)]; end
  if(exist([tDir type '/annotations'],'dir')), continue; end
  dbExtract_scut([tDir type],1,skip,pth);
end