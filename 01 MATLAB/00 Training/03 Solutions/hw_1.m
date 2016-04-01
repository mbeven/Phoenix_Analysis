% application #1 - portfolio calculations
% sep 14, 2015 - finm matlab intro
% 
% warning: this solution is pretty terse--see lecture video for more detail


clear all
close all
clc


load '/Users/michaelbeven/Documents/01 MATLAB/00 Training/00 Data/dataPort'

threshGap = .0005;




%%

sp500 = prices(:,1);
oil = prices(:,2);
bonds = prices(:,3);


pNow = prices(end,:);

[Nt,Nk] = size(prices);


rets = (prices(2:end,:) ./ prices(1:end-1,:)) -1;
retsLog = log(prices(2:end,:)./prices(1:end-1,:));

% tedious issue of replicating Nt-1 rows---not Nt rows
p0 = repmat(prices(1,:),Nt-1,1);
retsCum = (prices(2:end,:) ./ p0) - 1;
retsCumLog = log(prices(2:end,:) ./ p0);





%%

%%% difference in log and levels
gap = abs(rets - retsLog);
indGap = gap(:,1) > threshGap;
numGap = sum(indGap);

gapCum = abs(retsCum(end,:) - retsCumLog(end,:));
% this max function is really useful---it gives two outputs
[maxVal,indMax] = max(gapCum);
disp('Max value is')
disp(maxVal)



%%% portfolio
wts = [.5;.3; .2];
retsPort = rets * wts;
% small issue with length of time-series now being Nt-1
sum(retsPort> 0)/(Nt-1);


retsCumPort = cumprod(1+retsPort)-1;



%%

figure
plot(prices(:,1))

figure
subplot(2,2,1)
plot(retsCum(:,1))
subplot(2,2,2)
plot(retsCum(:,2))
subplot(2,2,3)
plot(retsCum(:,3))
subplot(2,2,4)
plot(retsCumPort)

figure
plot([retsCum(:,1),retsCumPort])

