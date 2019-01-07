function post_roadline_script
% get results
% R = load('./scut/results/scuttest/ev-All-FRCN-vanilla.mat');
R = load('E:\Code\Detectron\output\scut\S1_G0-3-S1_e2e_frcnn_VGG16-C5_roadline\detectron-output\test\scut_test_1x_roadline\generalized_rcnn\scut_eval\scuttest\ev-All-e2e-frcnn-VGG16-C5.mat');
load('E:\Code\Detectron\output\scut\S1_G0-3-S1_e2e_frcnn_VGG16-C5_roadline\detectron-output\test\scut_test_1x_roadline\generalized_rcnn\roadline.mat')
center = double(roadline');
gtr = R.R.gtr;
dtr = R.R.dtr;
% roadline = 215;
% comput center_line
% center = center_line(gtr);
% center(center == 0)=roadline;
% search best param
nD = 100:100:9000;
nA = 0.1:0.1:1;
nB = 0.1:0.1:1;
% nD = 2500;
% nA = 0.1;
% nB = 0.1;
[mr,D,A,B] = findparam(dtr,gtr,center,nD,nA,nB,'linear');
end

function todo()
% post_roadline
nD = 9310; % 路面系数
nA = 2.7; % 路面衰减系数
nB = 1; % 得分衰减系数
roadline = 215;
scores = 0:0.1:1;
yp = 0:10:576;

score = 0.8;
hold on;
figure(21);
rescore = post_roadline(score,yp,roadline,nD,nA,nB);
plot(yp,rescore);

plotRoc = 1;
samplesMR2 = 10.^(-2:.25:0); % samples for computing area under the curve FPPI=0.
samplesMR4 = 10.^(-4:.25:0); % samples for computing area under the curve
lims = [2e-4 50 .035 1];  % axis limits for ROC plots
R = load('./scut/results/scuttest/ev-All-FRCN-vanilla.mat');
% get results
gtr = R.R.gtr;
dtr = R.R.dtr;
[xs,ys,~,mr] = bbGt('compRoc',gtr,dtr,plotRoc,samplesMR4);
if(plotRoc), ys=1-ys; mr=1-mr; end
if(plotRoc), mr=exp(mean(log(mr))); else mr=mean(mr); end

center = center_line(gtr);
center(center == 0)=roadline;
if(0)
    % plot ROC Curve
    figure(22);
    plot(xs,ys);
    yt=[.05 .1:.1:.5 .64 .8]; ytStr=int2str2(yt*100,2);
    for i=1:length(yt), ytStr{i}=['.' ytStr{i}]; end
    set(gca,'XScale','log','YScale','log',...
        'YTick',[yt 1],'YTickLabel',[ytStr '1'],...
        'XMinorGrid','off','XMinorTic','off',...
        'YMinorGrid','off','YMinorTic','off');
    xlabel('false positives per image','FontSize',14);
    ylabel('miss rate','FontSize',14); axis(lims);
    
    
    nframe = numel(dtr);
    dtr_rd = cell(1,nframe);
    for i = 1:nframe
        if isempty(dtr{i})
            continue;
        end
        %     dtr_rd{i} = dtr{i};
        dtr_rd{i} = [rcwh2xywh(dtr{i}(:,1:4)), dtr{i}(:,5:end)];
        dtr_rd{i}(:,5) = max(0,post_roadline(dtr_rd{i}(:,5),dtr_rd{i}(:,2),center(i),nD,nA,nB));
    end
    [xs_re,ys_re,~,mr_re] = bbGt('compRoc',gtr,dtr_rd,plotRoc,samplesMR4);
    if(plotRoc), ys_re=1-ys_re; mr_re=1-mr_re; end
    if(plotRoc), mr_re=exp(mean(log(mr_re))); else mr_re=mean(mr_re); end
end

end

function [mr,D,A,B] = findparam(dtr,gtr,center,nD,nA,nB,type)
    % post_roadline
%     nD = 400:10:800; % 路面系数
%     nA = 2:0.1:5; % 路面衰减系数
%     nB = 1:0.1:1; % 得分衰减系数
plotRoc = 1;
samplesMR2 = 10.^(-2:.25:0); % samples for computing area under the curve FPPI=0.
% samplesMR4 = 10.^(-4:.25:0); % samples for computing area under the curve
ND = numel(nD);
NA = numel(nA);
NB = numel(nB);
re_mr = zeros(ND,NA,NB);
for i = 1:ND
    for j = 1:NA
        for k = 1:NB
            nframe = numel(dtr);
            dtr_rd = cell(1,nframe);
            for l = 1:nframe
                if isempty(dtr{l})
                    continue;
                end
                %     dtr_rd{i} = dtr{i};
                dtr_rd{l} = [rcwh2xywh(dtr{l}(:,1:4)), dtr{l}(:,5:end)];
                dtr_rd{l}(:,5) = max(0,post_roadline(type,dtr_rd{l}(:,5),dtr_rd{l}(:,2),center(i),nD(i),nA(j),nB(k)));
            end
            [xs_re,ys_re,~,mr_re] = bbGt('compRoc',gtr,dtr_rd,plotRoc,samplesMR2);
            if(plotRoc), ys_re=1-ys_re; mr_re=1-mr_re; end
            if(plotRoc), mr_re=exp(mean(log(mr_re))); else mr_re=mean(mr_re); end
            re_mr(i,j,k) = mr_re;
            outlog = sprintf('nD(%d):%d nA(%d):%f nB(%d):%f mr:%.2f',...
                i,nD(i),j,nA(j),k,nB(k),mr_re*100);
            disp(outlog);
        end
    end
end
[si,i] = min(re_mr);
[sj,j] = min(si);
[sk,k] = min(sj);
mr = sk;
D = nD(i(j(k)));
A = nA(j(k));
B = nB(k);
sprintf('best param:nD(%d):%d nA(%d):%.2f nB(%d):%.2f mr:%.2f',...
                i(j(k)),D,j(k),A,k,B,sk*100);
end
