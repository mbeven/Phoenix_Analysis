% demo simulation

clear all
close all
clc

%%

% rand - uniform, (0,1)
% randn - standard normal
% randi(Nmax) - discrete uniform from [1,Nmax]
% normrnd(mu,vol,Nrows,Ncols)

%set randomizer
rng('shuffle')
data = randn(10,3);

fx = sin(data);