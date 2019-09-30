function [Corr] = getCorrelation(data,reg)

D = size(data.X,2);

Corr = zeros(D,1);

res = (data.Y-reg.mu)./sqrt(reg.nu+reg.lambda);

index = (reg.H==0);

for m = 1:D
    AA = corrcoef(data.X(index,m),res(index));
    Corr(m) = AA(1,2);
end


end

