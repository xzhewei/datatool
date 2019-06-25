% 统计基于Area过滤后的gt召回率
output_dit = 'E:\Work\Work_scut\论文\05.ROI\exp\vis\caltech\frcn\';

mkdir_if_missing(output_dit);

% path1 = 'E:\Code\datatool\caltech\results\UsaTest\gt-All.mat';
% path2 = 'E:\Code\maskrcnn-benchmark\output\caltech\exp\190411-S1-G1-8-e2e_frcnn_VGG_16_C4_gpn_8_gpu-Area\inference-noslice-prop\caltech_test_1x_roadline\gpc.mat';
% set = 'usa';
% type = 'test30';
% width = 640;


% path1 = 'E:\Code\datatool\scut\results\scuttest\ev-All-GPCAnet-filter.mat';
path1 = 'E:\Code\datatool\scut\results\scuttest\ev-All-FasterR-CNN.mat';
% path1 = 'E:\Code\datatool\caltech\results\usatest\ev-All-GPCAnet-filter.mat';
% path1 = 'E:\Code\datatool\caltech\results\usatest\ev-All-FasterR-CNN.mat';
% path1 = 'E:\Code\datatool\scut\results\scuttest\ev-All-YOLOv3.mat';
set = 'scuttest';
type = 'test25';
width = 720;

load(path1);


nframe = numel(R.gtr);

gt_d = zeros(nframe,1);
gt_gt = zeros(nframe,1);
ticId = ticStatus(['Extract img:'],0.2,1);
for i=1:nframe
    if(isempty(R.gtr{i}))
        continue;
    end
    if (i==1351)
       pause; 
    end
    fig = showImg_index( set,type,i );
    [hs] = showRes(R.gtr{i}, R.dtr{i},'lw',2,'gtShow',0);
    h = getframe(fig);
    imwrite(h.cdata,[output_dit set '_' type '_' int2str(i) '.jpg']);
    pause;
    close(fig);
    tocStatus(ticId,i/nframe);
end

