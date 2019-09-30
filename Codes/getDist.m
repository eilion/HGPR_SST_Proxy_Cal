function [cal_model] = getDist(reg,data,param)

X0 = data.X0;
st = floor(min(X0)-0.5);
ed = ceil(max(X0)+0.5);

T0 = st:0.01:ed;
T0 = T0';
M = length(T0);

cal_model = zeros(M,3);

T = (T0-data.mu_X)/data.sig_X;
F = [ones(M,1),T];

index = (reg.H==0);

FF = data.F(index,:);
XX = data.X(index);
YY = data.Y(index);
RR = reg.lambda(index);

N = length(YY);

K = getCov(FF,FF,param.model.eta,param.model.sig) + param.model.lambda^2*eye(N);

B0 = diag(RR) + K;
B2 = B0\eye(N);
B1 = B2*YY;

K1 = getCov(F,FF,param.model.eta,param.model.sig);

SIG = diag(param.model.sig.^2);
CC = sum((F*SIG).*F,2);
K2 = param.model.eta^2*asin(2*CC./(1+2*CC)) + param.model.lambda^2;

cal_model(:,1) = T0;
cal_model(:,2) = K1*B1;
cal_model(:,3) = K2 - sum((K1*B2).*K1,2);


Dist = abs(T-XX');
AA = sort(Dist,2,'ascend');
BW = AA(:,ceil(param.k*length(YY)/100));

WW = - 0.5*Dist.^2./(BW.^2) - log(BW);
WW = WW - max(WW,[],2);
WW = exp(WW);
LL = WW./sum(WW,2);

mu = reg.mu(index)';
nu = reg.nu(index)';

LA = sum(((YY'-mu).^2+nu).*LL,2);

cal_model(:,2) = cal_model(:,2)*data.sig_Y + data.mu_Y;
cal_model(:,3) = sqrt(cal_model(:,3)+LA);
cal_model(:,3) = cal_model(:,3)*data.sig_Y;


end