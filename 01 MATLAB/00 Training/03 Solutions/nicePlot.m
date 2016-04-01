function nicePlot(dates,data)
%
% test function that plots
% does not return any output to workspace

figure
plot(dates,data)
datetick('x')
set(gca,'fontsize',18)
saveas(gcf,'myPlot','jpg')

