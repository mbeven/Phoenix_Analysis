% Application 2
% Michael Beven
% 20150916
% Data: dataAssets.mat

clear all
close all
clc

% Change path to /Users/michaelbeven/Documents/MATLAB/Training/00 Data
load '/Users/michaelbeven/Documents/MATLAB/Training/00 Data/dataAssets'

[Nt, Nk] = size(prices);

labels = {'snp500','usd','oil','hyg','bonds'};


%% Summary Statistics

%% 1.
% Calculate the matrix of returns (in levels) for all securities

rets = [NaN(1,Nk); prices(2:end,:) ./ prices(1:end-1,:)];

%% 2.
% Calculate the correlation matrix of the returns.  Which pair has the
% largest correlation?  And the smallest?

retsCorr = corr(rets(2:end,:));

%% 3.
% Calculate the volatility of each return

retsVol = std(rets(2:end,:));

%% 4.
% Calculate the skewness of each return, and list any assets for which the
% skewness is negative

retsSkew = skewness(rets(2:end,:));
retsSkewNeg = retsSkew < 0;
isNegSkewRet = labels{retsSkewNeg};
fprintf('Asset(s) with a negative skewness:\n\n%s\n',isNegSkewRet);

%% 5.
% Which asset has the lowest 5th quintile return?

[minRets, minIdx] = min(quantile(rets(2:end,:),0.80))
fprintf('%s has the lowest 5th quintile return at %f2.4\n\n', ...
    labels{minIdx}, minRets);

%% Regression

%% 1.
% For each asset, calculate the regression beta when regressed on the S&P
% 500 - without a constant

% initialise output
beta0 = NaN(1,Nk); %without constant
indX = 1;
X = rets(:,indX);

% run loop
for i = 1:Nk
    
    Y = rets(:,i);
    beta0(1,i) = regress(X,Y);
    
end

%% 2.
% Repeat these regressions, this time including a constant

% initialise output
beta1 = NaN(2,Nk); %with constant

% run loop
for i = 1:Nk
    
    Y = rets(:,i);
    regest = regstats(Y,X,'linear');
    beta1(:,i) = regest.beta;
    
end

%% 3.
% Which regression has the highest R^2 statistic?

% initialise output
R2 = NaN(1,Nk);

%run loop
for i = 1:Nk
    
    Y = rets(:,i);
    regest = regstats(Y,X,'linear');
    R2(:,i) = regest.rsquare;
    
end

%% 4.
% Which regression (with a constant) has the most statistically significant
% beta?

% initialise output
t = NaN(2,Nk);

%run loop
for i = 1:Nk
    
    Y = rets(:,i);
    regest = regstats(Y,X,'linear');
    t(:,i) = regest.tstat.t;
    
end

%% Plots

%% 1.
% Make scatter plots of oil returns versus the S&P 500 returns

figure
plot(rets(:,3),rets(:,1),'.')
ylabel('Oil')
xlabel('S&P500')
title('Returns of Oil vs. S&P500')

%% 2.
% Make a histogram of the USD index returns

figure
histogram(rets(:,2))
title('USD Index Returns');

%% 3.
% Make a histogram of the USD-on-S&P regression residuals

regestUSD = regstats(rets(:,2),rets(:,1));
USDSnPResid = regestUSD.r;

figure
histogram(USDSnPResid)
title('USD on S&P500 Regression Residuals')