% Application #1
% Portfolio Calculations
% Michael Beven
% 2015/09/16
% dataset(s): dataPort.mat
% ====================================================================

clear all
close all
clc

% Change path to /Users/michaelbeven/Documents/MATLAB/Training/00 Data
load '/Users/michaelbeven/Documents/MATLAB/Training/00 Data/dataPort'

%% Data Manipulation

%% 1. 
% Create 3 column vectors, each containing the price history of one 
% of the asset classes.  Name the vectors sp500, oil, and bonds

sp500 = prices(:,1);
oil = prices(:,1);
bonds = prices(:,3);

%% 2.
% Create a row vector, pNow with the latest price of each security

pNow = prices(end,:);

%% 3.
% Calculate the number of days (Nt) and number of assets, (Nk)

[Nt, Nk] = size(prices);

%% 4.
% Calculate the matrix of the history of returns for the three assets. 
% Calculate both the log-return (retsLog) and the level-return (rets).
% The log and level returns are defined as:

% log-return, r~(t) = log(P(t+1)/P(t))
% level-return, r(t) = P(t+1)/P(t) - 1

retsLog = [NaN(1,Nk); log(prices(2:end,:) ./ prices(1:end-1,:))];
rets = [NaN(1,Nk); prices(2:end,:) ./ prices(1:end-1,:) - 1];

%% 5.
% Calculate a matrix of cumulative returns of the assets, named retsCumLog
% and retsCum.  Recall that the cumulative return is simply:

% log-return, r~(t,t+h) = log(P(t+1)/P(t))
% level-return, r(t,t+h) = P(t+1)/P(t) - 1

% Note that you may find the Matlab function repmat helpful here.  It
% allows you to build an array where every row corresponds to P(t). You
% can then use this array in the denominator of array arithmetic and skip
% any need for coding loops

repPrices = repmat(prices(1,:),Nt,1);
retsCumLog = log(prices(:,:) ./ repPrices(:,:));
retsCum = prices(:,:) ./ repPrices(:,:) - 1;

%% Calculations

%% 1.
% For how many days does the S&P500 log-return and level-return differ by
% more than 5 basis points? That is, |r~(t) - r(t)| > 0.0005

retsDiff = sum(abs(retsLog(:,1) - rets(:,1)) > 0.0005);

%% 2.
% For which asset is there the biggest difference in the total cumulative
% level-return versus the total cumulative log-return?

maxCumDiff = abs(retsCumLog(end,:) - retsCum(end,:));

%% 3.
% Suppose an investor puts weights of 50%, 30%, and 20% in the S&P500, oil,
% and bonds.  Calculate the history of portfolio returns, (level-returns).
% Call this vector retsPort

retsPort = rets(:,1)*0.50 + rets(:,2)*0.30 + rets(:,3)*0.20;

%% 4.
% What percentage of days does the portfolio have a positive return?

propPos = sum(retsPort > 0)/(Nt - 1);

%% 5.
% Calculate the history of cumulative returns of the portfolio.  Call this
% retsCumPort.  Feel free to do this as the cumulative log or cumulative
% level return.  (In either case, try calculating the cumulative portfolio
% return by starting with the portfolio return series and using cumsum or
% cumprod)

retsCumPort = [NaN(1,1); cumprod(1 + retsPort(2:end)) - 1];

%% Plots

%% 1.
% Create a plot of the price history of S&P500

figure
plot(prices(:,1))
datetick('x')
title('S&P500 Prices')
ylabel('Index')

%% 2.
% In a separate figure, create 4 sub-plots of cumulative returns.  That is,
% plot the history of cumulative returns for each of the 3 assets as well
% as the portfolio

figure
subplot(2,2,1)
plot(retsCum(:,1))
datetick('x')
title('S&P500 Cumulative Returns')
ylabel('% Returns')
subplot(2,2,2)
plot(retsCum(:,2))
datetick('x')
title('Oil Cumulative Returns')
ylabel('% Returns')
subplot(2,2,3)
plot(retsCum(:,3))
datetick('x')
title('Bonds Cumulative Returns')
ylabel('% Returns')
subplot(2,2,4)
plot(retsCumPort(:))
datetick('x')
title('Portfolio Cumulative Returns')
ylabel('% Returns')

%% 3.
% Finally, create another figure where you plot both the S&P500 cumulative
% return history as well as the portfolio cumulative return history in the
% same figure

figure
hold on
plot(retsCum(:,1))
plot(retsCumPort)
datetick('x')
title('Cumulative Returns')
ylabel('% Returns')
legend('S&P500','Portfolio')
hold off

