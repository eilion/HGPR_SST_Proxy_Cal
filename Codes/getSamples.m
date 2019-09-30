function [samples] = getSamples(data,setting)

N = size(data.Y,1);
L = 1000;
M = min(setting.bSize,N);

samples = zeros(M,L);

for ll = 1:L
    seed = datasample(1:N,M,'Replace',false);
    samples(:,ll) = seed';
end


end