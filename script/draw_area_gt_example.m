function draw_area_gt_example
% �����о���˵��area_gt����������
set = 'usa';
gt = load('E:\Datasets\caltech\mat\test30\gt-All.mat');
gt = gt.gt;

s = 6;
v = 2;
f = 780;
nframe = 148;
draw_area_gt(gt,set,s,v,f,nframe);

s = 7;
v = 0;
f = 1829;
nframe = 1216;
draw_area_gt(gt,set,s,v,f,nframe);

s = 9;
v = 3;
f = 1620;
nframe = 2797;
draw_area_gt(gt,set,s,v,f,nframe);

s = 7;
v = 3;
f = 780;
nframe = 1364;
draw_area_gt(gt,set,s,v,f,nframe);

% set = 'scut';
% gt = load('E:\Datasets\scut\mat\test25\gt-All.mat');
% gt = gt.gt;
% 
% s = 11;
% v = 0;
% f = 1100;
% nframe = 44;
% draw_area_gt(gt,set,s,v,f,nframe);
% 
% s = 11;
% v = 3;
% f = 125;
% nframe = 193;
% draw_area_gt(gt,set,s,v,f,nframe);
% 
% s = 11;
% v = 1;
% f = 2425;
% nframe = 155;
% draw_area_gt(gt,set,s,v,f,nframe);
% 
% s = 15;
% v = 7;
% f = 575;
% nframe = 1812;
% draw_area_gt(gt,set,s,v,f,nframe);

end
function draw_area_gt(gt,set,s,v,f,nframe)
col = 'g';
ls = '-';
lw = 2;
switch(set)
    case 'usa', width = 640;
    case 'scut', width = 720;
end

fig = drawBBox(set,s,v,f,gt{nframe}(:,1:4),col,ls,lw);
top = min(gt{nframe}(:,2));
bottom = max(gt{nframe}(:,2)+gt{nframe}(:,4));
[~,center] = box2center(gt{nframe}(:,1:4));
center = mean(center);
line([0 width],[top top],'Color',[0 1 0],'LineWidth',2);
line([0 width],[bottom bottom],'Color',[0 1 0],'LineWidth',2);
line([0 width],[center center],'Color',[0 1 0],'LineWidth',2,'LineStyle','--');
saveas(fig,[set '_' int2str(s) '_' int2str(v) '_' int2str(f) '.fig']);
end