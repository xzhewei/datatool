function pos_grid = vbbPosition
pth = 'E:\Datasets\caltech\';
if ~exist('allbboxList', 'var')
    load([pth 'analysis.mat']);
end
center_x = [allbboxList(:).center_x];
center_y = [allbboxList(:).center_y];
%%
hpdist = figure();
hpaxes = axes('Parent',hpdist);
hold(hpaxes,'on');
h = center_y;
% Create histogram
hpdist = histogram(h,'Parent',hpaxes,'Normalization','probability',...
    'BinEdges',0:5:480);
set(hpaxes,'XMinorTick','on','XTick',[0 100 200 300 400 480],...
    'YGrid','on','XLim',[0 480]);
saveas(hpdist,[pth 'Position Distribution'],'png');

[N,~] = histcounts(h,'Normalization','probability',...
                   'BinEdges',[0 147 257 480]);
file = fopen(fullfile(pth,'poslog.txt'),'w');
fprintf(file,['Position Distribution\n']);
fprintf(file,[repmat('-',1,76) '\n']);
fprintf(file,'Min : %.2f\n', min(h));
fprintf(file,'Max : %.2f\n', max(h));
fprintf(file,'Median : %.2f\n', median(h));
fprintf(file,'Math Average : %.2f\n', sum(h)/length(h));
fprintf(file,'Log-Average : %.2f\n', exp(sum(log(h))/length(h)));
fprintf(file,[repmat('-',1,76) '\n']);
fprintf(file,'Position range:\n');
fprintf(file,'0-147:            %.2f%% \n', N(1)*100);
fprintf(file,'147-257:          %.2f%% \n', N(2)*100);
fprintf(file,'257-480:          %.2f%% \n', N(3)*100);
fclose(file);
%%
figure();
pos_grid = zeros(500,660);
for i=1:numel(center_x)
    x = round(center_x(i));
    y = round(center_y(i));
    temp = pos_grid(y,x);
    pos_grid(y,x) = temp + 1;
end
lg_pos_grid = log(pos_grid);
imagesc(lg_pos_grid);
colormap('jet');
K3 = filter2(fspecial('average',7),pos_grid)+1;
lg_K3 = log(K3);
fig = figure();
imagesc(lg_K3);
colormap('jet');
saveas(fig,fullfile(pth,'Position Distribution Heatmap'),'png');