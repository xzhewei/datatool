function vbbHist
pth = 'F:\DataSet\SCUT_FIR_101\datasets\';
if ~exist('allbboxList', 'var')
    load([pth 'analysis.mat']);
end

% RENAME
type = 'walk_person';
index = strcmp([allbboxList.label]',type);
h = [allbboxList(index).pos_h];
hmin = min(h);
hmax = max(h);
% log equal divid XTick
xmin = 16;
xmax = 256;
xlog = linspace(log(xmin),log(xmax),64);
xbin = exp(xlog);

hpdist = figure();
hpaxes = axes('Parent',hpdist);
hold(hpaxes,'on');

% Create histogram
hpdist = histogram(h,'Parent',hpaxes,'Normalization','probability',...
    'BinEdges',xbin);

% Create xlabel
xlabel('Height(pixel)','FontSize',14);

% Create ylabel
ylabel('Probability','FontSize',14);

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 256]); Set the remaining axes properties
set(hpaxes,'XMinorTick','on','XScale','log','XTick',[0 16 32 64 128 256],...
    'YGrid','on','XLim',[0 256]);

% Create title&save
switch(type)
    case 'ride_person'
        title('Ride\_Person Height Distribution','FontSize',14);
        saveas(hpdist,[pth 'Ride_Person Height Distribution(Probability)'],'pdf');
    case 'walk_person'
        title('Walk\_Person Height Distribution','FontSize',14);
        saveas(hpdist,[pth 'Walk_Person Height Distribution(Probability)'],'pdf');
end
% RENAME % Save figure to Dataset Directory 
% savefig([pth 'Ride_Person Height Distribution(Probability)'],hpdist,...
%     'pdf','-r300','-fonts'); 
% saveas(hpdist,[pth 'Ride_Person Height Distribution(Probability)'],'pdf');


% Summarize distribution parameters
file = fopen([pth type '_histlog.txt'],'w');

[N,~] = histcounts(h,'Normalization','probability',...
                   'BinEdges',[0 30 80 inf]);
fprintf(file,[type ' Height Distribution\n']);
fprintf(file,[repmat('-',1,76) '\n']);
fprintf(file,'Min : %.2f\n', hmin);
fprintf(file,'Max : %.2f\n', hmax);
fprintf(file,'Median : %.2f\n', median(h));
fprintf(file,'Math Average : %.2f\n', sum(h)/length(h));
fprintf(file,'Log-Average : %.2f\n', exp(sum(log(h))/length(h)));
fprintf(file,[repmat('-',1,76) '\n']);
fprintf(file,'Compare to caltech:\n');
fprintf(file,'Far    less 30 pixel:            %.2f%% \n', N(1)*100);
fprintf(file,'Medium range in 30 to 80 pixel:  %.2f%% \n', N(2)*100);
fprintf(file,'Near greater 80 pixel:           %.2f%% \n', N(3)*100);

[N,~] = histcounts(h,'Normalization','probability','BinEdges',[0 45 115 inf]);
fprintf(file,[repmat('-',1,76) '\n']);
fprintf(file,'Compare to kais:\n');
fprintf(file,'Far    less 45 pixel:            %.2f%% \n', N(1)*100);
fprintf(file,'Medium range in 45 to 115 pixel: %.2f%% \n', N(2)*100);
fprintf(file,'Near greater 115 pixel:          %.2f%% \n', N(3)*100);

fclose(file);

end