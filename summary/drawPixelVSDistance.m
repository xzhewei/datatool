% draw the relationship of height(pixels) vs distances(m)
pth = 'F:\DataSet\SCUT_FIR_101\datasets\';
d = 1:100; % distance
H = 1.7;   % person high meter
f = 1553.909; % focus length (pixel)
lgd={};


h = H.*f./d;
fig = figure();
axes1 = axes('Parent',fig);
hold(axes1,'on');

p(1) = plot(d,h,'b');
lgd{1} = 'SCUT';

% for caltech
f_caltech = 480/2/tan(pi*27/2/180); %1000
H_caltech = 1.8;
h_kaist = H_caltech.*f_caltech./d;

p(2) = plot(d,h_kaist,'g');
lgd{2} = 'Caltech';

% for kaist
f_kaist = 2*256/2/tan(pi*39/2/180); %772.9217
h_kaist = H.*f_kaist./d;

p(3) = plot(d,h_kaist,'r');
lgd{3} = 'KAIST';

legend(p,lgd,'Location','sw','FontSize',10);
% Create xlabel
xlabel({'distance from camera (m)'},'FontSize',14);

% Create title
% title({'distance vs. height'},'FontSize',14);

% Create ylabel
ylabel({'height (pixels)'},'FontSize',14);

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 160]);
% Set the remaining axes properties

set(axes1,'XTick',[0 20 40 60 80 100],'YGrid','on','YTick',[0 30 80 160],'YLim',[0 160]);

saveas(fig,[pth 'distance vs height'], 'png');
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
