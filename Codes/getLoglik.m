function [LOGLIK] = getLoglik(reg,data)

Y = data.Y;
MU = reg.mu;
NU = reg.nu + reg.lambda;

index0 = (reg.H==0);
Y0 = Y(index0);
LL0 = - 0.5*(Y0-MU(index0)).^2./NU(index0) - 0.5*log(NU(index0)) - 0.5*log(2*pi);

LOGLIK = mean(LL0);


end