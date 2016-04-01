% Michael Beven
% Statistical Risk Management Homework 8 Problem 13.2
% 20151203

%% Set parameters
start_date = '05-Jan-2000';
end_date = datetime('today');

%% Fetch data
df_SP = fetch(yahoo,'^GSPC','Close',start_date,end_date,'w');
df_SP = mat2dataset(df_SP, 'VarNames', {'Date','Close'});

df_N = fetch(yahoo,'^IXIC','Close',start_date,end_date,'w');
df_N = mat2dataset(df_N, 'VarNames', {'Date','Close'});

%% Calc returns
LogRets_SP = diff(log(df_SP.Close));
LogRets_N = diff(log(df_N.Close));

%% Frank Meta copula

% t-marginals
a1 = mle(LogRets_SP,'distribution','t');
y1 = (LogRets_SP-a1(1))/a1(2);
a2 = mle(LogRets_N,'distribution','t');
y2 = (LogRets_N-a1(1))/a2(2);
global xt n;
xt = [tcdf(y1,a1(3)),tcdf(y2,a2(3))]; % makes approx. uniform
n = length(LogRets_SP);

% Frank copula with t-marginals
z = fminbnd(@frank,1.1,100);
u=(1-z.*log(unifrnd(0,1,n,2))./(gamrnd(1/z,z,n,1)*ones(1,2))).^(-1/z);
y=[a1(1)+a1(2)*tinv(u(:,1),a2(3)),a2(1)+a2(2)*tinv(u(:,2),a2(3))];

% Plot
figure(1)
plot(y(:,1),y(:,2),'o')
axis([-0.25,0.25,-0.3,0.3])
title('S&P500 and NASDAQ Scatterplot of Simulated Log Returns using a Frank Copula with t-marginals')
xlabel('Simulated S&P losses')
ylabel('Simulated Nasdaq losses')

% Log returns
z = fminsearch(@frank,1.1,100);
u=(1-z.*log(unifrnd(0,1,n,2))./(gamrnd(1/z,z,n,1)*ones(1,2))).^(-1/z);
y=[a1(1)+a1(2)*tinv(u(:,1),a2(3)),a2(1)+a2(2)*tinv(u(:,2),a2(3))];

% Plot
figure(2)
plot(y(:,1),y(:,2),'o')
axis([-0.25,0.25,-0.3,0.3])
title('S&P500 and NASDAQ Scatterplot of Log Returns')
xlabel('Simulated S&P losses')
ylabel('Simulated Nasdaq losses')
      
        