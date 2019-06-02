% ��roiͼ
% ����ѡ���ͼ��
function paper_draw_roi_and_filter_roi
% SCUT
% set='scut';
% s=15;
% v=5;
% f=2074;
% nf=1634; % ���Լ��еڼ���ͼ
% path1 = 'E:\Code\maskrcnn-benchmark\output\scut\190411-S1-G1-8-e2e_frcnn_VGG_16_C4_gpn_8_gpu-Area\inference-noslice\scut_test_1x_roadline\predictions.mat';
% path2 = 'E:\Code\maskrcnn-benchmark\output\scut\190411-S1-G1-8-e2e_frcnn_VGG_16_C4_gpn_8_gpu-Area\inference-noslice\scut_test_1x_roadline\gpc.mat';
% p_text=550;

% Caltech
set='usa';
s=6;
v=6;
f=239;
nf=370; % ���Լ��еڼ���ͼ
path1 = 'E:\Code\maskrcnn-benchmark\output\caltech\190411-S1-G1-8-e2e_frcnn_VGG_16_C4_gpn_8_gpu-Area\inference-noslice-prop\caltech_test_1x_roadline\predictions.mat';
path2 = 'E:\Code\maskrcnn-benchmark\output\caltech\190411-S1-G1-8-e2e_frcnn_VGG_16_C4_gpn_8_gpu-Area\inference-noslice-prop\caltech_test_1x_roadline\gpc.mat';
p_text=450;

draw(set,s,v,f,nf,path1,path2,p_text)



end
function draw(set,s,v,f,nf,path1,path2,p_text)

load(path1);
load(path2);

scale=1;

bbox = all_boxes{nf}*scale;
bbox = bbox(:,1:4);
bbox(:,3) = bbox(:,3) - bbox(:,1);
bbox(:,4) = bbox(:,4) - bbox(:,2);
gpc = all_gpcs(nf,:);
top = gpc(2);
bottom = gpc(3);

drawBBox(set,s,v,f,bbox,'r','-',1);
text(50,p_text,['RoIs Num: ' int2str(size(bbox,1))],'Color',[1,1,1],'FontSize',16,'FontWeight','bold');
[~,yc] = box2center(bbox);
outer = yc<top | yc>bottom;
filter_bbox = bbox(~outer,:);

drawBBox(set,s,v,f,filter_bbox,'r','-',1);
text(50,p_text,['RoIs Num: ' int2str(size(filter_bbox,1))],'Color',[1,1,1],'FontSize',16,'FontWeight','bold');

drawBBox(set,s,v,f,bbox(1:54,:),'r','-',1);
text(50,p_text,['RoIs Num: ' int2str(size(filter_bbox,1))],'Color',[1,1,1],'FontSize',16,'FontWeight','bold');
end