% Simulating AR(1) with autocorrelated errors
% Michael Beven
% 20150928
% Datasource: None

%% Initial Conditions

T = 10000;
alpha = 0;
beta = 0.9;
sigma = 1;
gamma = 0.1;
y = NaN*ones(T,1);
y(1) = 0;
e = NaN*ones(T,1);
e(1) = 0;

%% Error simulation

for t = 1:T
    e(t+1) = gamma * e(t) + sigma * randn(1);
end

%% AR simulation

for t = 1:T
    y(t+1) = alpha + beta*y(t) + e(t);
end

%% Plot 1 - *Run Separately*

figure
subplot(2,2,1);
histfit(y,100,'kernel')
title('T = 100')


%% Plot 2 - *Run Separately*
subplot(2,2,2);
histfit(y,100,'kernel')
title('T = 1000')


%% Plot 3 - *Run Separately*
subplot(2,2,3);
histfit(y,100,'kernel')
title('T = 10000')


%% Plot 4 - *Run Separately*
subplot(2,2,4);
histfit(y,100,'kernel')
title('T = 100000')


