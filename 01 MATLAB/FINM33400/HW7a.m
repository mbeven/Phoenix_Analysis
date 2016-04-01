% Michael Beven
% Statistical Risk Management Homework 7a
% 20151124

%% Set parameters
start_date = '05-Jan-2000';
end_date = datetime('today');

%% Fetch data
df = fetch(yahoo,'^GSPC','Close',start_date,end_date,'w');
df = mat2dataset(df, 'VarNames', {'Date','Close'});

%% Calc returns
LogRets = diff(log(df.Close));
PosLogRets = LogRets(LogRets>0);
NegLogRets = LogRets(LogRets<0);

%% Fit distribution
PosPD = gpfit(PosLogRets);
NegPD = gpfit(-1*NegLogRets);

%% Set number of points
np = 1000;
p = (0+1/(np-1):1/(np-1):1-1/(np-1))';

%% Calculate inverse values
InvPosPD = icdf('gp',p,PosPD(1),PosPD(2));
InvNegPD = icdf('gp',p,NegPD(1),NegPD(2));

%% Plots
figure(1)
hold on
qd = quantile(PosLogRets,p);
plot(InvPosPD,qd,'+b');
plot([min(InvPosPD) max(InvPosPD)],[min(InvPosPD) max(InvPosPD)],'r-.');
xlabel('Theoretical Quantiles'); 
ylabel('Quantiles of Input Sample');
title('QQ-Plot of Positive S&P500 Log Returns');

figure(2)
hold on
qd = quantile(-1*NegLogRets,p);
plot(InvNegPD,qd,'+b');
plot([min(InvNegPD) max(InvNegPD)],[min(InvNegPD) max(InvNegPD)],'r-.');
xlabel('Theoretical Quantiles'); 
ylabel('Quantiles of Input Sample');
title('QQ-Plot of Negative S&P500 Log Returns');