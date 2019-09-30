function [param] = getBandwidth(data,param,reg)

X = data.X;
[N,D] = size(X);

K = ceil(param.k*N/100);

index = (reg.H==0);
XX = X(index,:);

M = size(XX,1);

Dist = zeros(N,M);
for m = 1:D
    Dist = Dist + (X(:,m)-XX(:,m)').^2;
end
Dist = sqrt(Dist);

AA = sort(Dist,2,'ascend');

param.bandwidth = AA(:,min(K,M));


end