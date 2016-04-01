% demo bootstrapping
% 


clear all
close all
clc

%%

Nsim = 100;

muX = 0.09;
sigX = 0.16;
muY = 0.18;
sigY = 0.22;

trueBeta = 1.2;


%%

epsX = randn(Nsim,1);
epsY = randn(Nsim,1);

Xsim = muX + sigX * epsX;
Ysim = muY + trueBeta * Xsim + sigY * epsY;

%% Regression

regest = regstats(Ysim,Xsim);
estBeta = regest.beta;