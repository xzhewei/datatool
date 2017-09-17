pth = 'F:\DataSet\SCUT_FIR_101\datasets';
tDir = 'F:\DataSet\SCUT_FIR_101\datasets\extract\';

% type='test'; skip=25;
% dbInfo(['scut' type]);
% type=['test' int2str2(skip,2)];
% if(~exist([tDir type '/annotations'],'dir'))
%     dbExtract_scut([tDir type],1,skip,pth); 
% end

type='train'; skip=100;
dbInfo(['scut' type]);
type=['train' int2str2(skip,2)];
if(~exist([tDir type '/annotations'],'dir'))
    dbExtract_scut([tDir type],1,skip,pth); 
end


