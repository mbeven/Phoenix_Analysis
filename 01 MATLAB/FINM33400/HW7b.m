% Michael Beven
% Statistical Risk Management Homework 7b
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


%% Set number of points
np = 1000;
p = (0+1/(np-1):1/(np-1):1-1/(np-1))';

%% Fit distribution
PosPD = fitdist(1./PosLogRets,'Gamma');
NegPD = fitdist(-1./NegLogRets,'Gamma');

%% Calculate inverse values
InvPosPD = gaminv(p,PosPD.a,1/PosPD.b);
InvNegPD = gaminv(p,NegPD.a,1/NegPD.b);

%% Plots
figure(1)
hold on
qd = quantile(PosLogRets,p);
plot(InvPosPD,qd,'+b');
%plot([min(InvPosPD) max(InvPosPD)],[min(InvPosPD) max(InvPosPD)],'r-.');
xlabel('Theoretical Quantiles'); 
ylabel('Quantiles of Input Sample');
title('QQ-Plot of Positive S&P500 Log Returns');

figure(2)
hold on
qd = quantile(-1*NegLogRets,p);
plot(InvNegPD,qd,'+b');
%plot([min(InvNegPD) max(InvNegPD)],[min(InvNegPD) max(InvNegPD)],'r-.');
xlabel('Theoretical Quantiles'); 
ylabel('Quantiles of Input Sample');
title('QQ-Plot of Negative S&P500 Log Returns');