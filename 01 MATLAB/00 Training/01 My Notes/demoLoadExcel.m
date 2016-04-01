% demo loadExcel
%

close all
clear all
clc


%% Load from .xls using xlsread function
% cvsread

%%% import data
filename = 'AssetClassExRets.xls';
sheetname = 'Sheet1';
[numData, txtData, allData] = xlsread(filename,sheetname);

labels = allData(1,2:end);
rets = cell2mat(allData(2:end,2:end));
dates = cell2mat(allData(2:end,1));
dates = dates + datenum('30dec1899');

retStats = [mean(rets); std(rets); skewness(rets)];

%% Build Table

outNumData = num2cell(retStats);
rowLabels = {' ';'mean';'std.dev';'skewness'};
outData = [rowLabels, [labels; outNumData]];


%% Save File

outFile = 'statData';
outSheet = 'summaryStats';

if exist(outFile,'file')
    delete(outFile);
end

xlswrite(outFile,retStats,outSheet);


