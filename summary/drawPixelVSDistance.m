% draw the relationship of height(pixels) vs distances(m)
pth = '/mnt/RD/DataSet/SCUT_FIR_101/';
d = 1:100; % distance
H = 1.7;   % person high meter
f = 1553.909; % focus length (pixel)

h = H.*f./d;
fig = figure();
axes1 = axes('Parent',fig);
hold(axes1,'on');

plot(d,h);
% Create xlabel
xlabel({'distance from camera (m)'},'FontSize',14);

% Create title
title({'distance vs. height'},'FontSize',14);

% Create ylabel
ylabel({'height (pixels)'},'FontSize',14);

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 160]);
% Set the remaining axes properties

set(axes1,'XTick',[0 20 40 60 80 100],'YGrid','on','YTick',[0 30 80 160],'YLim',[0 160]);
savefig([pth 'distance vs height'], fig, 'pdf', '-r300', '-fonts');
% % Create textarrow
% farH = 80;
% farD = H * f / farH;
% 
% annotation('textarrow',[(farD/100 + 0.05) (farD/100)],...
%     [farH/160+0.05 farH/160],'String',{['Height:' num2str(farH) ' vs. Distance:' num2str(farD)]});
% 
% % Create textarrow
% midH = 30;
% midD = H * f / midH;
% 
% annotation('textarrow',[(midD/100 + 0.05) (midD/100)],...
%     [midH/160+0.05 midH/160],'String',{['Height:' num2str(midH) ' vs. Distance:' num2str(midD)]});
