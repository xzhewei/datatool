function road_valid()
imgDir = 'E:\Datasets\scut\extract\test25\images\';
gt = load('E:\Datasets\scut\mat\test25\gt-All.mat');
output_dir = 'E:\road_line\scut\test25_gt_box';
gt = gt.gt;
% load('E:\Code\Detectron\output\scut\S1_G0-3-S1_e2e_frcnn_VGG16-C5_roadline\detectron-output\test\scut_test_1x_roadline\generalized_rcnn\roadline.mat')
% roadline = double(roadline');

gt_line = center_line(gt);
% D = center-roadline;
% D = D(center~=0);
gt_line(gt_line == 0)=216;
draw_ground_plane_lines(gt, gt_line, [], imgDir, output_dir)
% recordAvi(gt, gt_line, [], imgDir, output_dir);
end

function draw_ground_plane_lines(gt, gt_line, dt_line, imgDir, output_dir)
imglist = dir([imgDir '*.jpg']);
[~,name,~] = fileparts(imglist(1).name);
C = strsplit(name,'_');
fprintf('Drawing %s %s',C{1},C{2});
for i=1:numel(gt_line)
    [~,namet,~] = fileparts(imglist(i).name);
    Ct = strsplit(namet,'_');
    if ~strcmp(Ct{1},C{1}) || ~strcmp(Ct{2},C{2})
        fprintf('Drawing %s %s',C{1},C{2});
    end
    figure(1);
    fimg = fullfile(imgDir,imglist(i).name);
    if isempty(gt)
        drawRoadLine(fimg,gt_line(i),{});
    else
        drawRoadLine(fimg,gt_line(i),gt{i});
    end
    if ~isempty(dt_line)
        line([0 720],[dt_line(i) dt_line(i)],'Color',[1 0 0],'LineWidth',4);
    end
    saveas(1,fullfile(fullfile(output_dir,'images'),imglist(i).name));
end
end

function recordAvi(gt, gt_line, dt_line, imgDir, output_dir)
imglist = dir([imgDir '*.jpg']);
[~,name,~] = fileparts(imglist(1).name);
C = strsplit(name,'_');

sname = fullfile(output_dir, 'road_line');
vidObj = VideoWriter([sname '_' C{1} '_' C{2} '.avi']);
% vidObj.CompressionRatio = 1;
% vidObj.Height = 512;
% vidObj.Width = 640;
vidObj.FrameRate = 25;
open(vidObj);
fprintf('Recording %s %s',C{1},C{2});
for i=1:numel(gt_line)
    [~,namet,~] = fileparts(imglist(i).name);
    Ct = strsplit(namet,'_');
    if ~strcmp(Ct{1},C{1}) || ~strcmp(Ct{2},C{2})
        close(vidObj);
        fprintf('Done.\n');
        C = Ct;
        vidObj = VideoWriter([sname '_' C{1} '_' C{2} '.avi']);
        vidObj.FrameRate = 25;
        open(vidObj);
        fprintf('Recording %s %s',C{1},C{2});
    end
    figure(1);
    fimg = fullfile(imgDir,imglist(i).name);
    if isempty(gt)
        drawRoadLine(fimg,gt_line(i),{});
    else
        drawRoadLine(fimg,gt_line(i),gt{i});
    end
    if ~isempty(dt_line)
        line([0 720],[dt_line(i) dt_line(i)],'Color',[1 0 0],'LineWidth',4);
    end
    currFrame=getframe;
    writeVideo(vidObj,currFrame);
    saveas(1,fullfile(fullfile(output_dir,'images'),imglist(i).name));
    %     pause;
end
if (rec_avi)
    close(vidObj);
end
end

function drawRoadLine(fimg,center,boxes)
img = imread(fimg);
imshow(img);
[h,w,~] = size(img);
line([0 w],[center center],'Color',[0 1 0],'LineWidth',4);
[~,name,~] = fileparts(fimg);
label = sprintf('%s center:%d',name,round(center));
text(10,h-20,label,'Color',[1 1 1],'FontSize',12,'LineWidth',16,...
    'Interpreter','none');
if ~isempty(boxes)
    bbApply( 'draw', boxes);
end
end




function temp()
dt = load('./scut/results/scuttest_all/dt-Fast-EdgeBox-V-T-S.mat');
gt = load('./scut/results/scuttest_all/gt-ROI.mat');
R = load('./scut/results/scuttest_all/ev-ROI-RPN-vanilla.mat');

% get results
gtr = R.R.gtr;
dtr = R.R.dtr;

far_dtr = cell(1,4104);
med_dtr = cell(1,4104);
near_dtr= cell(1,4104);
dtr_iou = cell(1,4104);

box = [];
far_box = [];
med_box = [];
near_box = [];

far_gtr = cell(1,4104);
med_gtr = cell(1,4104);
near_gtr= cell(1,4104);

gtr_box = [];
gtr_near= [];
gtr_med = [];
gtr_far = [];
for i = 1:4104
    if isempty(gtr{i})
        continue;
    end
    gtr_box = [gtr_box;gtr{i}];
    far_gtr{i} = gtr{i}(gtr{i}(:,4)<=30,:);
    gtr_far = [gtr_far;far_gtr{i}];
    %     index = find(dtr{i}(:,4)>30 & dtr{i}(:,4)<=80);
    med_gtr{i} = gtr{i}(gtr{i}(:,4)>30 & gtr{i}(:,4)<=80,:);
    gtr_med = [gtr_med;med_gtr{i}];
    %     index = find(dtr{i}(:,4)>80);
    near_gtr{i} = gtr{i}(gtr{i}(:,4)>80,:);
    gtr_near = [gtr_near;near_gtr{i}];
end

% split results to FP/TP/IG
far_gt_tp = gtr_far(gtr_far(:,5)==1,:);
far_gt_fp = gtr_far(gtr_far(:,5)==0,:);
far_gt_ig = gtr_far(gtr_far(:,5)==-1,:);

med_gt_tp = gtr_med(gtr_med(:,5)==1,:);
med_gt_fp = gtr_med(gtr_med(:,5)==0,:);
med_gt_ig = gtr_med(gtr_med(:,5)==-1,:);

near_gt_tp = gtr_near(gtr_near(:,5)==1,:);
near_gt_fp = gtr_near(gtr_near(:,5)==0,:);
near_gt_ig = gtr_near(gtr_near(:,5)==-1,:);

% split results by scale
for i = 1:4104
    if isempty(dtr{i})
        continue;
    end
    oa = bbGt('compOas',dtr{1,i}(:,1:4),gtr{1,i}(:,1:4),gtr{1,i}(:,5)==-1);
    moa = max(oa');
    if isempty(gtr{i})
        moa = zeros(1,size(dtr{i},1));
    end
    dtr_iou{i} = dtr{i};
    dtr{i}(:,7) = moa';
    dtr_iou{i}(:,5) = moa';
    box = [box;dtr{i}];
    %     index = find(dtr{i}(:,4)<=30);
    far_dtr{i} = dtr{i}(dtr{i}(:,4)<=30,:);
    far_box = [far_box;far_dtr{i}];
    %     index = find(dtr{i}(:,4)>30 & dtr{i}(:,4)<=80);
    med_dtr{i} = dtr{i}(dtr{i}(:,4)>30 & dtr{i}(:,4)<=80,:);
    med_box = [med_box;med_dtr{i}];
    %     index = find(dtr{i}(:,4)>80);
    near_dtr{i} = dtr{i}(dtr{i}(:,4)>80,:);
    near_box = [near_box;near_dtr{i}];
end

% split results to FP/TP/IG
far_box_tp = far_box(far_box(:,6)==1,:);
far_box_fp = far_box(far_box(:,6)==0,:);
far_box_ig = far_box(far_box(:,6)==-1,:);

med_box_tp = med_box(med_box(:,6)==1,:);
med_box_fp = med_box(med_box(:,6)==0,:);
med_box_ig = med_box(med_box(:,6)==-1,:);

near_box_tp = near_box(near_box(:,6)==1,:);
near_box_fp = near_box(near_box(:,6)==0,:);
near_box_ig = near_box(near_box(:,6)==-1,:);



% score hist
figure(1);
subplot(3,2,1);
histogram(far_box_tp(:,5),'Normalization','probability');
title('far TP')
subplot(3,2,2);
histogram(far_box_fp(:,5),'Normalization','probability');
title('far FP')
subplot(3,2,3);
histogram(med_box_tp(:,5),'Normalization','probability');
title('med TP')
subplot(3,2,4);
histogram(med_box_fp(:,5),'Normalization','probability');
title('med FP')
subplot(3,2,5);
histogram(near_box_tp(:,5),'Normalization','probability');
title('near TP')
subplot(3,2,6);
histogram(near_box_fp(:,5),'Normalization','probability');
title('near FP')

% distance vs score
near_pos_tp = [rcwh2xywh(near_box_tp(:,1:4)), near_box_tp(:,5:end)];
near_pos_fp = [rcwh2xywh(near_box_fp(:,1:4)), near_box_fp(:,5:end)];
med_pos_tp = [rcwh2xywh(med_box_tp(:,1:4)), med_box_tp(:,5:end)];
med_pos_fp = [rcwh2xywh(med_box_fp(:,1:4)), med_box_fp(:,5:end)];
far_pos_tp = [rcwh2xywh(far_box_tp(:,1:4)), far_box_tp(:,5:end)];
far_pos_fp = [rcwh2xywh(far_box_fp(:,1:4)), far_box_fp(:,5:end)];
figure(2);
road_line = 215;
subplot(3,2,1);
scatter(road_line-near_pos_tp(:,2),near_pos_tp(:,5));
title('near TP')
subplot(3,2,2);
scatter(road_line-near_pos_fp(:,2),near_pos_fp(:,5));
title('near FP')
subplot(3,2,3);
scatter(road_line-med_pos_tp(:,2),med_pos_tp(:,5));
title('med TP')
subplot(3,2,4);
scatter(road_line-med_pos_fp(:,2),med_pos_fp(:,5));
title('med FP')
subplot(3,2,5);
scatter(road_line-far_pos_tp(:,2),far_pos_tp(:,5));
title('far TP')
subplot(3,2,6);
scatter(road_line-far_pos_fp(:,2),far_pos_fp(:,5));
title('far FP')

% IoU vs score
% oa = bbGt('compOas',dtr{1,26}(:,1:4),gtr{1,26}(:,1:4),gtr{1,26}(:,5)==-1)
figure(3);
subplot(3,2,1);
scatter(near_pos_tp(:,5),near_pos_tp(:,7));
title('near TP');
subplot(3,2,2);
scatter(near_pos_fp(:,5),near_pos_fp(:,7));
title('near FP')
subplot(3,2,3);
scatter(med_pos_tp(:,5),med_pos_tp(:,7));
title('med TP')
subplot(3,2,4);
scatter(med_pos_fp(:,5),med_pos_fp(:,7));
title('med FP')
subplot(3,2,5);
scatter(far_pos_tp(:,5),far_pos_tp(:,7));
title('far TP')
subplot(3,2,6);
scatter(far_pos_fp(:,5),far_pos_fp(:,7));
title('far FP')
% 统计IoU=0的数量

% IoU vs Distance
figure(4);
road_line = 215;
subplot(3,2,1);
scatter(road_line-near_pos_tp(:,2),near_pos_tp(:,7));
title('near TP')
subplot(3,2,2);
scatter(road_line-near_pos_fp(:,2),near_pos_fp(:,7));
title('near FP')
subplot(3,2,3);
scatter(road_line-med_pos_tp(:,2),med_pos_tp(:,7));
title('med TP')
subplot(3,2,4);
scatter(road_line-med_pos_fp(:,2),med_pos_fp(:,7));
title('med FP')
subplot(3,2,5);
scatter(road_line-far_pos_tp(:,2),far_pos_tp(:,7));
title('far TP')
subplot(3,2,6);
scatter(road_line-far_pos_fp(:,2),far_pos_fp(:,7));
title('far FP')

% IoU vs Distance vs Score
figure(5);
road_line = 215;
subplot(3,2,1);
scatter3(road_line-near_pos_tp(:,2),near_pos_tp(:,7),near_pos_tp(:,5));
title('near TP')
subplot(3,2,2);
scatter3(road_line-near_pos_fp(:,2),near_pos_fp(:,7),near_pos_fp(:,5));
title('near FP')
subplot(3,2,3);
scatter3(road_line-med_pos_tp(:,2),med_pos_tp(:,7),med_pos_tp(:,5));
title('med TP')
subplot(3,2,4);
scatter3(road_line-med_pos_fp(:,2),med_pos_fp(:,7),med_pos_fp(:,5));
title('med FP')
subplot(3,2,5);
scatter3(road_line-far_pos_tp(:,2),far_pos_tp(:,7),far_pos_tp(:,5));
title('far TP')
subplot(3,2,6);
scatter3(road_line-far_pos_fp(:,2),far_pos_fp(:,7),far_pos_fp(:,5));
title('far FP')

% tp/fp/fppi
dt_box = box(box(:,6)~=-1,:);
gt_box = gtr_box(gtr_box(:,5)~=-1,:);
[~,order]=sort(dt_box(:,5),'descend');
dt_box = dt_box(order,:);
tp = dt_box(:,6);
fp = double(tp~=1);
tp=cumsum(tp);
fp=cumsum(fp);
figure(6);
recall = tp/length(gt_box);
h(1) = plot(recall);
hold on;
fppw = fp/length(tp);
h(2) = plot(fppw);
hold on;
fppi = fp/length(gtr);
h(3) = plot(fppi);
h(4) = plot(dt_box(:,5));
lgd = {'recall','fppw','fppi','score'};
legend(h,lgd,'Location','se','FontSize',11);
% set(gca,'YScale','log');
xlabel('bbox count','FontSize',11);
ylabel('rate','FontSize',11);

% miss rate in fppi range
samplesMR2 = 10.^(-2:.25:0);
samplesMR4 = 10.^(-4:.25:0);
m = length(samplesMR2);
recall2=zeros(1,m);
index2 =zeros(1,m);
for i=1:m, j=find(fppi<=samplesMR2(i)); recall2(i)=recall(j(end));
    index2(i)=j(end);
end
hold on;
plot(index2,recall2,'*');

m = length(samplesMR4);
recall4=zeros(1,m);
index4 =zeros(1,m);
for i=1:m, j=find(fppi<=samplesMR4(i)); recall4(i)=recall(j(end));
    index4(i)=j(end);
end
hold on;
plot(index4,recall4,'o');

% hist IoU
figure(7);
subplot(3,2,1);
histogram(far_box_tp(:,7),'Normalization','probability');
title('far TP')
subplot(3,2,2);
histogram(far_box_fp(:,7),'Normalization','probability');
title('far FP')
subplot(3,2,3);
histogram(med_box_tp(:,7),'Normalization','probability');
title('med TP')
subplot(3,2,4);
histogram(med_box_fp(:,7),'Normalization','probability');
title('med FP')
subplot(3,2,5);
histogram(near_box_tp(:,7),'Normalization','probability');
title('near TP')
subplot(3,2,6);
histogram(near_box_fp(:,7),'Normalization','probability');
title('near FP')
end