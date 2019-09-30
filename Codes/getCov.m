function [K] = getCov(F1,F2,eta,sig)

SIG = diag(sig.^2);
AA = F1*SIG*F2';
BB = sum((F1*SIG).*F1,2);
CC = sum((F2*SIG).*F2,2);

K = eta^2*asin(2*AA./sqrt((1+2*BB).*(1+2*CC')));


end

