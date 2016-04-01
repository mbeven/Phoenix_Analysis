clear all
close all
clc

load dataAssets
labels = {'SP500','USD','Oil','HighYield','TNotes'};

qtdVal = 0.05;

%% Data analysis

[Nt, Nk] = size(prices);

rets = [nan(1,Nk) ; (prices(2:end,:) ./ prices(1:end-1,:)) - 1];

%summary statistics
mu = nanmean(rets);
vol = nanstd(rets);
skew = skewness(rets);
indNeg = skew < 0;
disp('Skewness is negative for:')
disp(labels{indNeg});

Rho = corr(rets,'rows','pairwise');

qtd = quantile(rets,qtdVal);
[minQtd, indMin] = min(qtd);
fprintf('Smallest quantile is %s, at %2.4f\n',labels{indMin},minQtd);

%% Regression
indX = 1;
X = rets(:,indX);

%initialise loop output
beta0 = nan(1,Nk);
beta1 = nan(2,Nk);
r2 = nan(1,Nk);
tvals = nan(2,Nk);
resid = nan(Nt,Nk);
for i = 1:Nk
    
    Y = rets(:,i);
    regest = regstats(Y,X);
    beta1(:,i) = regest.beta;
    r2(:,i) = regest.rsquare;
    tvals(:,i) = regest.tstat.t;
    resid(:,i) = regest.r;

    beta0(:,i) = regress(Y,X);
    
end

%% Plots

figure
scatter(rets(:,1),rets(:,3),'.')

figure
NBins = 25;
hist(rets(:,2),NBins)

%time seires plot -- adjusted range
figure
plot(dates,rets(:,1),'linewidth',3)
xlim([dates(end-25),dates(end)])
datetick('x','keeplimits')

%time series with different scalings
figure
plot(dates,prices(:,[1,3]))
plotyy(dates,prices(:,1),dates,prices(:,3))