function fptp

res_dir = './scut/results/scuttest/';

[GPCAnet_filter] = countTPFP([res_dir 'ev-All-GPCAnet-filter.mat']);
[FasterRCNN] = countTPFP([res_dir 'ev-All-FasterR-CNN.mat']);
[RetinaNet] = countTPFP([res_dir 'ev-All-RetinaNet.mat']);
[GPCAnet_RetinaNet] = countTPFP([res_dir 'ev-All-GPCAnet-RetinaNet.mat']);
end

function [S] = countTPFP(file)
R = load(file);
gtr = R.R.gtr;
dtr = R.R.dtr;
dtrmat = cell2mat(dtr');
gtrmat = cell2mat(gtr');
[~,idx] = sort(dtrmat(:,5),'descend');
dtrmat = dtrmat(idx,:);
dtrmat = dtrmat(dtrmat(:,5)>=0.3,:);

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
fp_near = sum(fp_near_i);
fp_medium = sum(fp_medium_i);
fp_far = sum(fp_far_i);

S = cstruct(dtrmat,gtrmat,gt_i,tp_i,fp_i,tp,fp,recall,fp_near_i,fp_medium_i,...
    fp_far_i,gt,fp_near,fp_medium,fp_far);
S.dtrmat = dtrmat;
S.gtrmat = gtrmat;
S.tp_i = tp_i;
S.fp_i = fp_i;
S.tp = tp;
S.fp = fp;
S.recall = recall;
S.gt = gt;
S.fp_near = sum(fp_near_i);
S.fp_medium = sum(fp_medium_i);
S.fp_far = sum(fp_far_i);

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
