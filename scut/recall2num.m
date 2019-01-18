function recall2num
    exp = 'ROI';
    method = {
%         'DTS'
%         'DTS-H'
%         'DTS-S'
        'EdgeBox'
        'Fast-EdgeBox'
        'Fast-EdgeBox-T'
        'Fast-EdgeBox-V'
        'Fast-EdgeBox-S'
        'Fast-EdgeBox-T-S'       
        'Fast-EdgeBox-V-S'
        'Fast-EdgeBox-V-T'
        'Fast-EdgeBox-V-T-S'
        % CNN
%         'FRCN-vanilla'
        'RPN-vanilla'
%         'MSCNN'
%         'RPN+BF'
%         'YOLOv2'
%         'YOLOv3'
    };
Methods2 = {'EdgeBox';'EB+CasFilter';'EB+CasFilter+T';'EB+CasFilter+V';'EB+CasFilter+S';'EB+CasFilter+T+S';...
           'EB+CasFilter+V+S';'EB+CasFilter+V+T';'EB+CasFilter+V+T+S';'RPN'};
plotDrawStyleAll={
    struct('dotStyle','o','color',[0,0,0],'lineStyle','-'),...
    struct('dotStyle','x','color',[0,0,0],'lineStyle','--'),...
    struct('dotStyle','<','color',[0,0,0],'lineStyle','-'),...
    struct('dotStyle','>','color',[0,0,0],'lineStyle','--'),...
    struct('dotStyle','+','color',[0,0,0],'lineStyle','-'),...
    struct('dotStyle','o','color',[0,0,0],'lineStyle','--'),...
    struct('dotStyle','x','color',[0,0,0],'lineStyle','-'),...
    struct('dotStyle','<','color',[0,0,0],'lineStyle',':'),...
    struct('dotStyle','>','color',[0,0,0],'lineStyle','-'),...
    struct('dotStyle','+','color',[0,0,0],'lineStyle','--'),...
    };

%     cumStep = 10;
%     cumRang = [1:cumStep*2-1 cumStep*2:cumStep:1000];
    cumRang = floor(logspace(0,3));
    recall = zeros(numel(method),size(cumRang,2));
    figure(11);
    for i=1:numel(method)
        evname = ['./scut/results/scuttest_all/ev-' exp '-' method{i} '.mat'];
        recall(i,:) = cumRecall(evname,cumRang);
        semilogx([0,cumRang],[0,recall(i,:)], plotDrawStyleAll{i}.dotStyle, 'MarkerSize', 5, 'color', plotDrawStyleAll{i}.color, 'lineStyle', plotDrawStyleAll{i}.lineStyle,'LineWidth',2);
%         plot([0,cumRang],[0,recall(i,:)]);
        hold on;
    end
    xlabel('Number of RoI per Image','Fontsize',18);
    ylabel('Recall rate','Fontsize',18);
    set(gca,'FontSize',13)
    Methods_legend = Methods2;
for m = 1:numel(method)
%     load([path '\' Methods{m} '\total_info.mat']);    
    p = floor(recall(m,end)*100);
    Methods_legend{m} = [num2str(p) '% ' Methods_legend{m}];
end
legend(Methods_legend, 'Location', 'southeast', 'Fontsize',16)
%     figure(12);
%     creatfigure(cumRang,recall)
%     plot([0,cumRang],[0,recall]);
end

function [recall] = cumRecall(name,cumRang)
    R = load(name);
    % get results
    gtr = R.R.gtr;
    dtr = R.R.dtr;
    
    gt_box = [];    

    tp_num = zeros(4104,numel(cumRang));
    
    for i = 1:4104
        if isempty(gtr{i})
            continue;
        end
        gt_box = [gt_box;gtr{i}];
    end
    for si = 1:numel(cumRang)
        for i = 1:4104
            if isempty(dtr{i})
                continue;
            end        
            iend = min(size(dtr{i},1),cumRang(si));
            tp_num(i,si) = sum(dtr{i}(1:iend,6)==1);
        end
    end
    gt_num = size(gt_box,1) - sum(gt_box(:,5)==-1);
    recall = sum(tp_num)./gt_num;
end