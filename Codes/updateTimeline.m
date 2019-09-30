function [timeline] = updateTimeline(reg,data,param,timeline,t)

timeline.mu(:,t+1) = reg.mu;
timeline.nu(:,t+1) = reg.nu + reg.lambda;
timeline.isoutlier(:,t+1) = (reg.H==1);
timeline.logliks(t+1) = getLoglik(reg,data);
timeline.nOutliers(t+1) = sum(reg.H==1);
timeline.K(t+1) = param.k;
timeline.corr(:,t+1) = getCorrelation(data,reg);


end