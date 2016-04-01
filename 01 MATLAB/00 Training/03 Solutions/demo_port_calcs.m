% demo_port_calcs
%
% FINM Intro - Matlab
% Sep 14, 2015
% demonstration of basic statistical analysis and plotting


clear all
close all
clc




%% Load Data

load dataPort
labels = {'SP500'; 'Oil';'Bonds'};

threshGap = .0005;
qtdVal = .05;




%%

[Nt,Nk] = size(prices);


sp500 = prices(:,1);
oil = prices(:,2);
bonds = prices(:,3);


pNow = prices(end,:);

rets =  (prices(2:end,:) ./ prices(1:end-1,:)) -1;
retsLog = log(prices(2:end,:)./prices(1:end-1,:));


% for cum returns, must create matrix with every row the first date's price
% careful that only need Nt-1 rows, not Nt rows - so use size function
p0 = repmat(prices(1,:),size(rets,1),1);
retsCum = (prices(2:end,:) ./ p0) - 1;
retsCumLog = log(prices(2:end,:) ./ p0);


% fill out returns to keep number of time-series at Nt and match dates
rets = [nan(1,Nk); rets];
retsLog = [nan(1,Nk); retsLog];
retsCum = [nan(1,Nk); retsCum];
retsCumLog = [nan(1,Nk); retsCumLog];





%%

%%% difference in log and levels
gap = abs(rets - retsLog);
indGap = gap(:,1) > threshGap;
countGap = sum(indGap);
numGap = find(indGap);

gapCum = abs(retsCum(end,:) - retsCumLog(end,:));
% haven't yet shown them max function, so they can just inspect for max
[~,imax] = max(gapCum);


%%% portfolio
wts = [.5;.3; .2];
retsPort = rets * wts;
% CAREFUL: divide by number of returns.  May be Nt-1 or Nt if we padded nan
% so use size() function 
% divide by Nt if padded with NaN
sum(retsPort> 0)/Nt;

% look at use of cumprod
% if padded with nan, then need to start at first row without nan
retsCumPort = [nan; cumprod(1+retsPort(2:end))-1];





%%

% CAREFUL: if rets matrix is smaller than price, need to use rets dates
% if padded with NaN, no need
% datesR = dates(2:end);

figure
plot(dates,prices(:,1))
title(labels{1})
ylabel('price')
legend(labels{1})
datetick('x')

figure
subplot(2,2,1)
plot(dates,retsCum(:,1))
datetick('x')

subplot(2,2,2)
plot(dates,retsCum(:,2))
datetick('x')

subplot(2,2,3)
plot(dates,retsCum(:,3))
datetick('x')

subplot(2,2,4)
plot(dates,retsCumPort)
datetick('x')

figure
plot(dates,[retsCum(:,1),retsCumPort])
legend({labels{1};'portfolio'})




%% Summary stats


% if padded rets with NaN, these don't work!
%{
mu =  mean(rets);
vol = std(rets);
medRets = median(rets);
Sigma = cov(rets);
Rho = corr(rets);
%}

mu = nanmean(rets);
vol = nanstd(rets);
medRets = nanmedian(rets);
Sigma = nancov(rets);
Rho = corr(rets,'rows','pairwise');


% nans are ignored by min, max, quantile. 
maxRets = max(rets);
minRets = min(rets);
qtdRets = quantile(rets,qtdVal);


% disp results
disp('===========================================')
disp('Results')
fprintf('The average return on %s was %2.2f\n',labels{1},100*mu(1));
disp('The 5th quantile is:')
disp(qtdRets)
















