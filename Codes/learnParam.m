function [param,data] = learnParam(data,samples,reg,param)

beta1 = 0.9;
beta2 = 0.999;
epsilon = 1e-8;
gamma = 1e-3;

max_iters = 1000;
L = size(samples,2);

SCH = ceil(L*rand(max_iters,1));

K = size(data.F,2);

Mw = zeros(K+2,1);
Vw = zeros(K+2,1);

r = 0;
while r < max_iters
    r = r + 1;
    old_param = param;
    
    ll = SCH(r);
    
    index = samples(:,ll);
    HH = reg.H(index);
    index = index(HH==0);
    
    FF = data.F(index,:);
    YY = data.Y(index) - reg.mu0(index);
    RR = reg.lambda(index);
    
    PDEV = getPDEV_ML(YY,FF,RR,param);
    
    Mw = beta1*Mw - (1-beta1)*PDEV;
    Vw = beta2*Vw + (1-beta2)*PDEV.*PDEV;
 
    param.model.eta = abs(old_param.model.eta - (gamma*sqrt(1-beta2^r)/(1-beta1^r)).*Mw(1)./(sqrt(Vw(1))+epsilon));
    param.model.sig = abs(old_param.model.sig - (gamma*sqrt(1-beta2^r)/(1-beta1^r)).*Mw(2:end-1)./(sqrt(Vw(2:end-1))+epsilon));
    param.model.lambda = abs(old_param.model.lambda - (gamma*sqrt(1-beta2^r)/(1-beta1^r)).*Mw(end)./(sqrt(Vw(end))+epsilon));
end


end