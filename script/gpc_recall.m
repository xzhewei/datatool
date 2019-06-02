% 统计基于Area过滤后的gt召回率
output_dit = 'E:\Work\Work_scut\论文\05.ROI\exp\gt_out_of_area\';

mkdir_if_missing(output_dit);

% path1 = 'E:\Code\datatool\caltech\results\UsaTest\gt-All.mat';
% path2 = 'E:\Code\maskrcnn-benchmark\output\caltech\190411-S1-G1-8-e2e_frcnn_VGG_16_C4_gpn_8_gpu-Area\inference-noslice-prop\caltech_test_1x_roadline\gpc.mat';
% set = 'usa';
% type = 'test30';
% width = 640;


path1 = 'E:\Code\datatool\scut\results\scuttest\gt-All.mat';
path2 = 'E:\Code\maskrcnn-benchmark\output\scut\190411-S1-G1-8-e2e_frcnn_VGG_16_C4_gpn_8_gpu-Area\inference-noslice\scut_test_1x_roadline\gpc.mat';
set = 'scut';
type = 'test25';
width = 720;

load(path1);
load(path2);


nframe = numel(gt);

gt_d = zeros(nframe,1);
gt_gt = zeros(nframe,1);

for i=1:nframe
    if(isempty(gt{i}))
        continue;
    end
    gt_g = gt{i}(:,5)==0;
    if ~any(gt_g)
        continue;
    end
    gt_g = gt{i}(gt_g,:);
    [xc,yc]=box2center(gt_g);
    top = all_gpcs(i,2);
    bottom = all_gpcs(i,3);
    outer = yc<top | yc>bottom;
    gt_d(i) = sum(outer);
    gt_gt(i) = size(gt_g,1);
    if(gt_d(i)~=0)
        hs = drawBBox_index(set,type,i,gt_g(~outer,1:4),'g','-',2);
        bbApply('draw',gt_g(outer,1:4), 'g',2 ,'--');
        line([0 width],[top top],'Color',[1 0 0],'LineWidth',2);
        line([0 width],[bottom bottom],'Color',[1 0 0],'LineWidth',2);
        saveas(hs,[output_dit set '_' type '_' int2str(i) '.jpg']);
%         pause;
        close(hs); 
    end
end

recall = 1-sum(gt_d)/sum(gt_gt);
gt_num = sum(gt_gt);
gt_out = sum(gt_d);

