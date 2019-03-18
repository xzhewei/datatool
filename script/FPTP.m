function fptp
caltech = 'E:\Work\Work_scut\论文\05.ROI\exp\caltech\S1-G0-7-frcnn_VGG16_C4\detectron-output\test\caltech_test_1x\generalized_rcnn\caltech_eval\UsaTest';
caltech_roadline = 'E:\Work\Work_scut\论文\05.ROI\exp\caltech\S1-G1-7-frcnn_VGG16_C4-roadline\detectron-output\test\caltech_test_1x_roadline\generalized_rcnn\caltech_eval\UsaTest';
method = 'ev-All-frcnn_VGG16_C4.mat';

scut = 'E:\Work\Work_scut\论文\05.ROI\exp\scut\S1-G1-7-frcnn_VGG16_C4-x1.5-180k-lr0.02\detectron-output\test\scut_test_1x\generalized_rcnn\scut_eval\scuttest';
scut_roadline = 'E:\Work\Work_scut\论文\05.ROI\exp\scut\S1-G1-4-frcnn_VGG16_C4-roadline-acr\detectron-output\test\scut_test_1x_roadline_bak\generalized_rcnn\scut_eval\scuttest';

scut_roadline2 = 'E:\Work\Work_scut\论文\05.ROI\exp\scut\S1-G1-7-frcnn_VGG16_C4-roadline\detectron-output\test\scut_test_1x_roadline\generalized_rcnn\scut_eval\scuttest';

[cS] = countTPFP(fullfile(caltech,method));
[cgS] = countTPFP(fullfile(caltech_roadline,method));
[sS] = countTPFP(fullfile(scut,method));
[sgS] = countTPFP(fullfile(scut_roadline,method));
[sgS2] = countTPFP(fullfile(scut_roadline2,method));
end

function [S] = countTPFP(file)
R = load(file);
gtr = R.R.gtr;
dtr = R.R.dtr;
dtrmat = cell2mat(dtr');
gtrmat = cell2mat(gtr');
tp_i = dtrmat(:,6)==1;
fp_i = dtrmat(:,6)==0;
tp = sum(tp_i);
fp = sum(fp_i);
gt_i = gtrmat(:,5)==0 | gtrmat(:,5)==1;
gt = (sum(gtrmat(:,5)==0)+sum(gtrmat(:,5)==1));
recall = tp/gt;
fp_near_i = dtrmat(fp_i,4) >=80;
fp_medium_i = dtrmat(fp_i,4) <80;
fp_medium_i = dtrmat(fp_i,4) >30 & fp_medium_i;
fp_far_i = dtrmat(fp_i,4) <=30;


S = cstruct(dtrmat,gtrmat,gt_i,tp_i,fp_i,tp,fp,recall,fp_near_i,fp_medium_i,...
    fp_far_i);
% S.dtrmat = dtrmat;
% S.gtrmat = gtrmat;
% S.tp_i = tp_i;
% S.fp_i = fp_i;
% S.tp = tp;
% S.fp = fp;
% S.recall = recall;

end

function S = cstruct(varargin)
    filed = cell(nargin,1);
    value = cell(nargin,1);
    for i = 1:nargin
        filed{i} = inputname(i);
        value{i} = varargin{i};
    end
    S = cell2struct(value,filed);
end
