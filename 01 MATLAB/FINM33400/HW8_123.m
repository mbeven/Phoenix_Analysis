% Michael Beven
% Statistical Risk Management Homework 8 Problem 12.3
% 20151203

close all;
clear all;

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

%% Likelihood ratio test - positive returns

Pos_dof = 1; % number of restrictions

Pos_pareto = fitdist(PosLogRets,'gp'); % fit generalised pareto

Pos_u_nlogL = gplike([Pos_pareto.k,Pos_pareto.sigma],PosLogRets); % use params from dist
Pos_ulogL = -1*Pos_u_nlogL;

Pos_r_nlogL = gplike([Pos_pareto.k,1],PosLogRets); % use shape from dist, 1 for scale
Pos_rlogL = -1*Pos_r_nlogL;

[Pos_h,Pos_pValue] = lratiotest(Pos_ulogL,Pos_rlogL,Pos_dof); % test restricted against unrestricted

%% Likelihood ratio test - negative returns

Neg_dof = 1;

Neg_pareto = fitdist(-1*NegLogRets,'gp');

Neg_u_nlogL = gplike([Neg_pareto.k,Neg_pareto.sigma],-1*NegLogRets);
Neg_ulogL = -1*Neg_u_nlogL;

Neg_r_nlogL = gplike([Neg_pareto.k,1],-1*NegLogRets);
Neg_rlogL = -1*Neg_r_nlogL;

[Neg_h,Neg_pValue] = lratiotest(Neg_ulogL,Neg_rlogL,Neg_dof);