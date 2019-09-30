function [reg] = getReg(reg,data,param)

index = (reg.H==0);

FF = data.F(index,:);
YY = data.Y(index);

RR = reg.lambda(index);
QQ = reg.mu0(index);

N = length(YY);

K = getCov(FF,FF,param.model.eta,param.model.sig) + param.model.lambda^2*eye(N);

B0 = diag(RR) + K;
B2 = B0\eye(N);
B1 = B2*(YY-QQ);

K1 = getCov(data.F,FF,param.model.eta,param.model.sig);

SIG = diag(param.model.sig.^2);
CC = sum((data.F*SIG).*data.F,2);
K2 = param.model.eta^2*asin(2*CC./(1+2*CC)) + param.model.lambda^2;

reg.mu = reg.mu0 + K1*B1;
reg.nu = K2 - sum((K1*B2).*K1,2);


end