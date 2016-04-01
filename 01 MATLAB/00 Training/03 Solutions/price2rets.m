function [rets,retsLog] = price2rets(prices)
%
%
% Input is array of prices.  Output is array of level returns


[~,Nk] = size(prices);

rets = [nan(1,Nk); (prices(2:end,:) ./ prices(1:end-1,:))-1];
retsLog = [nan(1,Nk); log(prices(2:end,:) ./ prices(1:end-1,:))];


