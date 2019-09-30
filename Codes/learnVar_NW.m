function [reg] = learnVar_NW(reg,data,param)

X = data.X;
Y = data.Y;
[N,D] = size(X);

BW = param.bandwidth;

index = (reg.H==0);
XX = X(index,:);

M = size(XX,1);

Dist2 = zeros(N,M);
for m = 1:D
    Dist2 = Dist2 + (X(:,m)-XX(:,m)').^2;
end
WW = - 0.5*Dist2./(BW.^2) - log(BW);
WW = WW - max(WW,[],2);
WW = exp(WW);
LL = WW./sum(WW,2);

Y = Y(index)';
mu = reg.mu(index)';
nu = reg.nu(index)';

reg.lambda = sum(((Y-mu).^2+nu).*LL,2);


end