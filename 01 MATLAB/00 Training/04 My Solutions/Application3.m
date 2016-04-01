% Application 3
% Michael Beven
% 20150916
% Data: None

clear all
close all
clc

%% Simulation

% We want to simulate the S&P 500 returns, assuming the following:
% - The log-returns are normally distributed, with mean of 0.09 and
% standard deviation of 0.16
% - Returns are independent across time.  That is, each period we just get
% a new log-return from the distribution described above

% parameters
T = 10; %periods of returns
N = 10000; %number of interations

%% 1.
% Simulate a time-series of the log-returns with length T = 10.  Check that
% your simulated vector of length T by 1 seems reasonable

muS = 0.09;
sigmaS = 0.16;
muB = 0.06;
sigmaB = 0.04;

simRetS = normrnd(muS,sigmaS,T,N);
cumSimRetS = sum(simRetS);
simRetB = normrnd(muB,sigmaB,T,N);
cumSimRetB = sum(simRetB);

% check that numbers are reasonable
checkMaxRetS = abs(max(simRetS) - muS)/sigmaS;
checkMinRetS = abs(min(simRetS) - muS)/sigmaS;
checkMaxRetB = abs(max(simRetB) - muB)/sigmaB;
checkMinRetB = abs(min(simRetB) - muB)/sigmaB;

%% 2.
% Expand this to now sumulate N = 100 paths - each of length T = 10.  (With
% randn, there is no need to use a loop here)

simRetMultiS = normrnd(muS,sigmaS,T,N);
cumSimRetMultiS = sum(simRetMultiS);
simRetMultiB = normrnd(muB,sigmaB,T,N);
cumSimRetMultiB = sum(simRetMultiB);

%% Plots

%% 1.
% Make a histogram of all the simulated returns.  (That is, include all
% paths and all time periods in the histogram)

% Plot metrics
Nbins = 100;
fsize = 14;
pwidth = 8;
pheight = 6;

figure;
histogram(cumSimRetMultiS,Nbins);
title('Histogram of Simulated Returns','fontsize',fsize);
ylabel('Frequency','fontsize',fsize);

%% 2.
% Try using the function, histfit to see a histogram along with an
% estimated distribution. Specifically, enter histfit(data,nbins,'normal').
% Note that nbins is sumply the number of bins you want in the histogram.
% Try using 100

figure;
histfit(cumSimRetMultiS,Nbins,'normal');

%% 3.
% Make a plot showing the first 10 time-series paths. (Hint: no need for a
% loop to plot multiple time-series all on the same plot)

figure;
plot(simRetMultiS(:,1:10));

%% Probability Distribution

%% 1.
% Calculate the total cumulative log return of each path.  (No need to
% calculate the history of cumulative returns-just the final cumulative
% return of each path

% ===== done above =====

%% 2.
% Using your simulated sample, what is the mean and standard deviation of
% the total cumulative log return?

meanCumRet = mean(cumSimRetMultiS);
stdCumRet = std(cumSimRetMultiS);

fprintf('The mean and standard deviation of the total cumulative return are\n %2.4f and %2.4f respectively\n\n', meanCumRet, stdCumRet);

%% 3.
% How does this distribution change if we use N = 1,000 paths.  What if we
% use T = 20?

% As N increases, the accuracy of the mean and standard deviation increase
% As T increases, the accuracy of the mean and standard deviation is the
% same

%% Underperformance

% Suppose a client is concerned about the probability that the stock index
% under-performs a bond index which has mean log-returns of 0.06 and
% standard deviation of 0.04

%% 1.
% Simulate N paths of length T for the bonds.  Assume that the bond returns
% are independent of the stock returns- so you can do this simulation
% completely separate from the stock simulation

% ===== done above =====

%% 2.
% Based on your simulations, what is the probability that the stock index
% under-performs the bond index?  Report this probability for T = 10,20,30

SUnderPerfB = sum(cumSimRetMultiS < cumSimRetMultiB) / N;

fprintf('The probabilty that the stock index under-performs the bond index is\n %0.4f for T = %.0f\n\n',SUnderPerfB, T);

%% Extra

%% 1. 
% Redo the section on under-performance, but this time assume that the bond
% and stock index are not independent. Rather, their log returns have a
% covariance of [0.0256, -0.0019; -0.0019, 0.0015].  To do this, try using
% mvnrnd(meanRowVen, sigmaMat, N).  This will give you only the first
% period of each simulated path- use a loop to fill out the rest of the
% path.

% set matrices
muSB = [muS, muB];
cov = [0.0256 -0.0019; -0.0019 0.0015];

% initialise loop output
retsSceCum = mvnrnd(muSB, cov, N);

for i = 1:T
    
    retsSceCum = (1 + retsSceCum) .* (1 + mvnrnd(muSB, cov, N)) - 1;
    
end

countBGreaterS = sum(retsSceCum(:,1) < retsSceCum(:,2));

probBGreaterS = countBGreaterS / N;

fprintf('The probabilty that the stock index under-performs the bond index is\n %0.4f for T = %.0f\n\n',probBGreaterS, T);
