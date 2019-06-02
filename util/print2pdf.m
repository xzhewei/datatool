function print2pdf(f,fname)
% ������pdf
set(f,'Units','centimeters');
pos = get(f,'Position');
set(f,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)]);
print(f,fname,'-dpdf','-r0');
end