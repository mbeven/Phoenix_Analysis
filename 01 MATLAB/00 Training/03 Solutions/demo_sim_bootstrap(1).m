% demo bootstrapping
% Sep 2015
% 

clear all
close all
clc


%%

Nsim = 100;

muX = .09;
sigX = .16;
sigY = .22;


trueAlpha = .18;
trueBeta = 1.2;




%% Simulate Data

% construct Y data according to 
% Y = alpha + beta * X + sigY * eps
epsX = randn(Nsim,1);
epsY = randn(Nsim,1);

Xsim = muX + sigX * epsX;
%Xsim = normrnd(muX,sigX,Nsim);

Ysim = trueAlpha + trueBeta * Xsim + sigY * epsY;




%% Regression

regest = regstats(Ysim,Xsim);
% remember that first element of regest.beta is actually the alpha
% the second element of regest.beta is the beta estimate
estAlpha = regest.beta(1);
estBeta = regest.beta(2);


disp('============================================')
fprintf('Simulation Bootstrap using %2.0f points.\n',Nsim);
disp('============================================')
fprintf('BETA: True = %2.2f, Estimated = %2.2f\n',trueBeta,estBeta(1));
fprintf('ALPHA: True = %2.2f, Estimated = %2.2f\n',trueAlpha,estAlpha(1));
disp('============================================')






















