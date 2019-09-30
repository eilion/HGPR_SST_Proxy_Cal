function [param,reg,timeline] = getParam(data,setting)

reg = struct('mu',cell(1,1),'nu',cell(1,1),'mu0',cell(1,1),'lambda',cell(1,1),'H',cell(1,1),'PT',cell(1,1));

param = struct('model',cell(1,1),'bandwidth',cell(1,1),'k',cell(1,1));

[N,D] = size(data.F);

param.model = struct('eta',cell(1,1),'sig',cell(1,1),'lambda',cell(1,1));
param.k = 5;

param.model.eta = 5;
param.model.sig = 10*ones(D,1);
param.model.sig(1) = 1;
param.model.lambda = 1e-20;

reg.mu0 = zeros(N,1);
reg.lambda = 4*mean(data.Y.^2)*ones(N,1);
reg.H = zeros(N,1);
reg.PT = zeros(N,1);


timeline = struct('mu',cell(1,1),'nu',cell(1,1),'isoutlier',cell(1,1),'logliks',cell(1,1),'nOutliers',cell(1,1),'K',cell(1,1),'corr',cell(1,1));
timeline.mu = zeros(N,setting.max_iters+1);
timeline.nu = zeros(N,setting.max_iters+1);
timeline.isoutlier = zeros(N,setting.max_iters+1);
timeline.logliks = zeros(1,setting.max_iters+1);
timeline.nOutliers = zeros(1,setting.max_iters+1);
timeline.K = zeros(1,setting.max_iters+1);
timeline.corr = zeros(D-1,setting.max_iters+1);


end