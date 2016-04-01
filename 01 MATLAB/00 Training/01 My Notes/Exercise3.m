% application # 3: simulation
% sep 2015

close all
clear all
clc

%% Parameters

% simulation params
T = 30;
N = 10000;

% stock return
muS = 0.09;
sigmaS = 0.16;
muB = 0.06;
sigmaB = 0.04;

%% Simulate

% log returns
% logRetsS = muS + sigmaS * randn(T,N);
logRetsS = normrnd(muS,sigmaS,T,N);
cumLogRetsS = sum(logRetsS);
logRetsB = normrnd(muB,sigmaB,T,N);
cumLogRetsB = sum(logRetsB);

muCum = mean(cumLogRetsS);
sigCum = std(cumLogRetsS);

%% Plots

Nbins = 10;
fsize = 14;
pwidth = 8;
pheight = 6;
figName = 'simHist';

figure
hist(logRetsS(:),Nbins)
title('Simulated Log Returns','fontsize',fsize);
ylabel('Count','fontsize',fsize);
% increase font size
set(gca,'fontsize',20)

% save as pdf
set(gcf,'PaperPosition',[0, 0, pwidth, pheight])
set(gcf,'PaperSize',[pwidth, pheight])
saveas(gcf,figName,'pdf')

figure
histfit(logRetsS(:), Nbins, 'normal')

figure
plot(logRetsS(:,1:10))

%% Under-performance

isUnder = cumLogRetsS < cumLogRetsB;
countUnder = sum(isUnder);
simFreq = countUnder / N;

disp('  ')
disp('=====================================')
fprintf('The simulated probability of stock under-performance\n after %2.0f years is %2.2f%%,\n', T, simFreq * 100);
