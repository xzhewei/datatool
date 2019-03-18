function eval_roadline_script
caltech_gpp = load('E:\Work\Work_scut\论文\05.ROI\exp\caltech\S1-G1-7-frcnn_VGG16_C4-roadline\detectron-output\test\caltech_test_1x_roadline\generalized_rcnn\roadline.mat');
caltech_gt_all = load('E:\Datasets\caltech\mat\test30\gt-All.mat');
scut_gpp = load('E:\Work\Work_scut\论文\05.ROI\exp\scut\S1-G1-4-frcnn_VGG16_C4-roadline-acr\detectron-output\test\scut_test_1x_roadline_bak\generalized_rcnn\roadline.mat');
scut_gt_all = load('E:\Datasets\scut\mat\test25\gt-All.mat');


caltech_gpp_center = double(caltech_gpp.roadline');
[caltech_gpp_err] = eval_roadline(caltech_gpp_center,caltech_gt_all.gt);
scut_gpp_center = double(scut_gpp.roadline');
[scut_gpp_err] = eval_roadline(scut_gpp_center,scut_gt_all.gt);

index = caltech_gpp_err.index;
gt = caltech_gpp_err.gt_line;
dt = caltech_gpp_center;
YMatrix1=[gt(index),dt(index)];
draw_roadline(YMatrix1)

index = scut_gpp_err.index;
gt = scut_gpp_err.gt_line;
tindex = gt<140;
dt = scut_gpp_center;
gt(tindex) = dt(tindex);
YMatrix1=[gt(index),dt(index)];
draw_roadline(YMatrix1)

end


function draw_roadline(YMatrix1)
%CREATEFIGURE1(YMATRIX1)
%  YMATRIX1:  y 数据的矩阵

%  由 MATLAB 于 31-Jan-2019 23:35:14 自动生成

% 创建 figure
figure1 = figure('InvertHardcopy','off','Color',[1 1 1],...
    'Renderer','painters');

% 创建 axes
axes1 = axes('Parent',figure1,'LineWidth',1,'FontSize',12);
%% 取消以下行的注释以保留坐标轴的 X 范围
xlim(axes1,[0 2200]);
%% 取消以下行的注释以保留坐标轴的 Y 范围
%ylim(axes1,[120 300]);
%% 取消以下行的注释以保留坐标轴的 Z 范围
% zlim(axes1,[-1 1]);
box(axes1,'on');
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多行
plot1 = plot(YMatrix1,'LineWidth',1);
set(plot1(1),'DisplayName','GT','Color',[0 0.6 0]);
set(plot1(2),'DisplayName','GPP','Color',[1 0 0]);


% 创建 legend
legend1 = legend(axes1,'show');
set(legend1,'FontSize',10.8);

end
