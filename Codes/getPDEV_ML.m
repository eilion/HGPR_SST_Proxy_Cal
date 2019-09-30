function [PDEV] = getPDEV_ML(Y,F,R,param)

LL = size(F,2);

PDEV = zeros(LL+2,1);

N = size(Y,1);

W = getCov(F,F,param.model.eta,param.model.sig) + param.model.lambda^2*eye(N) + diag(R);

W_inv = W\eye(N);
alpha = W_inv*Y;
ALPHA = alpha*alpha' - W_inv;


sig = param.model.sig;
SIG = diag(sig.^2);
BL1 = 2*F*SIG*F';
BL2 = 1./sqrt(1+diag(BL1));
BL3 = BL2';
L = BL1.*BL2.*BL3;

% eta:
WW = 2*param.model.eta*asin(L);
PDEV(1) = 0.5*trace(ALPHA*WW);

% sig:
for t = 2:LL
    BB1 = F(:,t).*F(:,t)'*2*param.model.sig(t);
    BB2 = diag(BB1);
    BB3 = BB2';
    
    AA = BB1.*BL2.*BL3 - 0.5*BL1.*(BL2.^3).*BB2.*BL3 - 0.5*BL1.*BL2.*(BL3.^3).*BB3;
    WW = param.model.eta^2./sqrt(1-L.^2).*AA;
    
    PDEV(1+t) = 0.5*trace(ALPHA*WW);
end

% lambda:
WW = 2*param.model.lambda*eye(N);
PDEV(end) = 0.5*trace(ALPHA*WW);


end