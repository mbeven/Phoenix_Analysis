% application #3: simulation
%
% FINM Intro - Matlab
% Sep 2015



close all 
clear all
clc




%% Parameters

% Assume annual stock returns are log-normal, iid, distribution
% annual mean (mu) 
% annual std.dev. (sigma) 

% simulation params
T = 10;
N = 1000;

% stock return
muS = .09;
sigmaS = .16;
muB = .06;
sigmaB = .04;





%% Simulate

% log returns
% logRetsS = muS + sigmaS * randn(T,N);
logRetsS = normrnd(muS,sigmaS,T,N);
cumLogRetsS = sum(logRetsS);
logRetsB = normrnd(muB,sigmaB,T,N);
cumLogRetsB = sum(logRetsB);


% stats of cumulative stock
muCum = mean(cumLogRetsS);
sigCum = std(cumLogRetsS);





%% Plots

Nbins = 10;
fsize = 14;
pwidth = 8;
pheight = 6;
figName = 'plots/simHist';

figure;
hist(logRetsS(:),Nbins);
title('Simulated log returns','fontsize',fsize)
ylabel('Count','fontsize',fsize)
% increase font size
set(gca,'fontsize',fsize)

% save as pdf
set(gcf,'PaperPosition',[0 0 pwidth pheight])
set(gcf,'PaperSize',[pwidth,pheight])
saveas(gcf,figName,'pdf')


figure
histfit(logRetsS(:),Nbins,'normal')


figure
plot(logRetsS(:,1:10))






%% Under-performance

isUnder = cumLogRetsS < cumLogRetsB;
countUnder = sum(isUnder);
simFreq = countUnder / N;

disp(' ')
disp('======================================')
fprintf('The simulated probab. of stock under-performance\n after %2.0f years is %2.2f%%.\n', T, simFreq * 100);






%% Analytical
% no need to worry about how this analytic solution is calculated
% you'll cover this plenty in your classes
% just want to display the true probability for comparison to the
% simulation

drift = muS - muB;
vol = sqrt(sigmaS^2 + sigmaB^2);
z = -((drift)/vol)*sqrt(T);
trueProb = normcdf(z,0,1);

disp(' ')
disp('=============================================================')
fprintf('The ANALYTIC probability of stock under-performance after \n%2.0f years is %2.2f%%.\n',...
    T, trueProb*100)
disp(' ')


