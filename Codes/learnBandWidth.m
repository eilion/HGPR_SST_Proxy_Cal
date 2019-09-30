function [param] = learnBandWidth(reg,data,param)

index = (reg.H==0);

X = data.X(index,:);
Y = data.Y(index);
mu = reg.mu(index);
nu = reg.nu(index);

[N,D] = size(X);

LOGLIK = zeros(10,1);
old_param = param;
for k = 1:10
    old_param.k = k;
    old_param = getBandwidth(data,old_param,reg);
    BW = old_param.bandwidth(index);
    
    Dist2 = zeros(N);
    for m = 1:D
        Dist2 = Dist2 + (X(:,m)-X(:,m)').^2;
    end
    WW = - 0.5*Dist2./(BW.^2) - log(BW);
    WW = WW - diag(inf*ones(N,1));
    WW = WW - max(WW,[],2);
    WW = exp(WW);
    LL = WW./sum(WW,2);
    
    LA = sum(((Y'-mu').^2+nu').*LL,2);
    
    LOGLIK(k) = - 0.5*sum((Y-mu).^2.*(nu+LA).^(-1)) - 0.5*sum(log(nu+LA));
end

[~,K] = max(LOGLIK);

param.k = K;


end