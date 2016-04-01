% Application 4
% Michael Beven
% 20150917
% data: dataAssets.mat

clear all
close all
clc

%% Data

% Change path to /Users/michaelbeven/Documents/MATLAB/Training/00 Data
load '/Users/michaelbeven/Documents/MATLAB/Training/00 Data/dataAssets'

% matrix dimensions
[Nt, Nk] = size(prices);

%% Portfolio

%% 1.

% level returns
rets = [NaN(1,Nk); prices(2:end,:) ./ prices(1:end-1,:) - 1];

%% 2.

retsPort = 0.5*rets(:,1) + 0.5*rets(:,3);

%% 3.

% 5th quantile of portfolio returns

rets5thQuant = quantile(retsPort,0.80);

fprintf('The 5th quantile of the portfolio returns is %2.4f\n\n',rets5thQuant);

%% Optimising Tail Risk

%% 1. 

% in-line portfolio function with weight w, 5th quantile
portFunc = @(w)quantile(w*rets(:,1) + (1-w)*rets(:,3),0.80) - 0.005555;

%% 2.

% portfolio optimiser using optimset and fzero
initCond = 1;
opt = optimset('tolX', 1e-6, 'tolFun', 1e-10, 'display', 'iter')
wstar = fzero(portFunc,initCond,opt);

%% 3.

% in-line portfolio absolute value function with weight w, 5th quantile
portFuncAbs = ... 
    @(w)abs(quantile(w*rets(:,1) + (1-w)*rets(:,3),0.80) - 0.0056);

%% 4.

% optimiser using fminunc
wmin = fminunc(portFuncAbs,initCond,opt);
