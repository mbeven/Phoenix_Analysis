clear all
close all
clc

load dataAssets

%%

initCond = 1;
opt = optimset('tolX',1e-6,'tolFun',1e-10,'display','final');
xstar = fzero(@quadfun,initCond,opt);

%%

funH = @(x)(7 + x(1) + 3*x(2) + 5*x(1)^2 + x(2)^2);
initCond = [1;1];
xMin = fminunc(funH,initCond,opt);

%%

