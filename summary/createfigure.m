function createfigure(X1, YMatrix1)
%CREATEFIGURE(X1, YMATRIX1)
%  X1:  x 数据的矢量
%  YMATRIX1:  y 数据的矩阵

%  由 MATLAB 于 30-Nov-2018 22:37:45 自动生成

% 创建 figure
figure1 = figure('InvertHardcopy','off','Color',[1 1 1]);

% 创建 axes
axes1 = axes('Parent',figure1,'XScale','log',...
    'Position',[0.13 0.11 0.666428571428571 0.815]);
%% 取消以下行的注释以保留坐标轴的 X 范围
% xlim(axes1,[2.07342823394495 11.6597438076369]);
%% 取消以下行的注释以保留坐标轴的 Y 范围
% ylim(axes1,[0.0448250728862973 0.294825072886297]);
%% 取消以下行的注释以保留坐标轴的 Z 范围
% zlim(axes1,[-1 1]);
box(axes1,'on');
hold(axes1,'on');

% 创建 ylabel
ylabel({'Recall Rate'},'FontSize',11);

% 创建 xlabel
xlabel({'Number of RoI per Image'},'FontSize',11);

% 使用 semilogx 的矩阵输入创建多行
semilogx1 = semilogx(X1,YMatrix1,'LineWidth',2,'MarkerSize',4,'Color',[0 0 0],'Parent',axes1);
% set(semilogx1(1),'DisplayName','DTS','Marker','v','LineStyle','--');
% set(semilogx1(2),'DisplayName','DTS-H','Marker','v','LineStyle','--');
% set(semilogx1(3),'DisplayName','DTS-S','Marker','v','LineStyle','--');
set(semilogx1(1),'DisplayName','EdgeBox','Marker','o','LineStyle','-');
set(semilogx1(2),'DisplayName','EB+CasFilter','Marker','x','LineStyle','--');
set(semilogx1(3),'DisplayName','EB+CasFilter+V','Marker','>','LineStyle','--');
set(semilogx1(4),'DisplayName','EB+CasFilter+T','Marker','<','LineStyle','-');
set(semilogx1(5),'DisplayName','EB+CasFilter+S','Marker','+','LineStyle','-');
set(semilogx1(6),'DisplayName','EB+CasFilter+V+T','Marker','<','LineStyle',':');
set(semilogx1(7),'DisplayName','EB+CasFilter+V+S','Marker','x','LineStyle','-');
set(semilogx1(8),'DisplayName','EB+CasFilter+T+S','Marker','o','LineStyle','--');
set(semilogx1(9),'DisplayName','EB+CasFilter+V+T+S','Marker','>','LineStyle','-');
set(semilogx1(10),'DisplayName','RPN','Marker','+','LineStyle','--');


% 创建 legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.745534553405453 0.10952380952381 0.300662661430501 0.818316740635393],...
    'FontSize',9);

