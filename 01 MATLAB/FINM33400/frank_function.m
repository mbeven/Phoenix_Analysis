%% Copula
function fn = frank(y)
global xt;
global n;
-(n*log(y)+n*log(1-exp(-y))-y*sum(xt(:,1)+xt(:,2))-2*sum(log((exp(-y)-1)+(exp((-y).*xt(:,1))-1).*(exp((-y).*xt(:,2))-1)))); 
