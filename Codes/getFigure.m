function [fig] = getFigure(reg,data,timeline,t)

NN_RES = (data.Y-reg.mu)./sqrt(reg.nu+reg.lambda);

MU = reg.mu*data.sig_Y + data.mu_Y;
NU = (reg.nu+reg.lambda)*data.sig_Y^2;

MIN_X = min(data.X0(:,1));
MAX_X = max(data.X0(:,1));

MIN_Y = min(data.Y0);
MAX_Y = max(data.Y0);
AA = MAX_Y - MIN_Y;
MIN_Y = MIN_Y - 0.05*AA;
MAX_Y = MAX_Y + 0.05*AA;

fig = figure;

subplot(2,3,1);
hold on;
title('Log-likelihoods and Outliers','FontSize',16);
xlabel('iteration','FontSize',12);
xlim([0,5+5*floor(t/5)]);
yyaxis left;
plot(0:t,timeline.logliks(1:t+1),'-*','Color','b');
ylabel('log-likelihood','FontSize',12);
yyaxis right;
plot(0:t,timeline.nOutliers(1:t+1)/length(data.Y),'-*','Color','r');
ylim([0 0.1]);
ylabel('proportion of outliers','FontSize',12);

subplot(2,3,2);
hold on;
title(['Regression over SSTs, Iter. ',num2str(t)],'FontSize',16);
index = (reg.PT<=0.5);
plot(data.X0(:,1),MU-1.96*sqrt(NU),'.','Color',[0.7,0.7,0.7]);
plot(data.X0(:,1),MU+1.96*sqrt(NU),'.','Color',[0.7,0.7,0.7]);
plot(data.X0(index,1),data.Y0(index),'.g');
plot(data.X0(~index,1),data.Y0(~index),'.r');
plot(data.X0(:,1),MU,'.k');
xlabel('SST (°C)','FontSize',12);
xlim([MIN_X MAX_X]);
ylim([MIN_Y MAX_Y]);

subplot(2,3,3);
hold on;
title('Ks and Correlations','FontSize',16);
xlabel('iteration','FontSize',12);
xlim([0,5+5*floor(t/5)]);
yyaxis left;
plot(0:t,timeline.K(1:t+1),'-*','Color','b');
ylim([0 10]);
ylabel('K','FontSize',12);
yyaxis right;
plot(0:t,log(sqrt(sum(timeline.corr(:,1:t+1).^2,1))),'-*','Color','r');
ylabel('log norms of correlations','FontSize',12);

subplot(2,3,4);
hold on;
title('Histogram of Normalized Residuals','FontSize',16);
MIN = min(NN_RES);
MAX = max(NN_RES);
TT = ceil(max([abs(MIN),abs(MAX)]));
bins = -TT:0.25:TT;
x = -6:0.01:6;
y = normpdf(x,0,1);
plot(x,y,'g','LineWidth',2);
hh = histogram(NN_RES,bins);
hh.Normalization = 'pdf';
xlim([-6 6]);
ylim([0 0.5]);

subplot(2,3,5);
hold on;
title('Normalized Residuals','FontSize',16);
plot([MIN_X,MAX_X],-1.96*[1,1],'--','Color',[0.7,0.7,0.7]);
plot([MIN_X,MAX_X],1.96*[1,1],'--','Color',[0.7,0.7,0.7]);
index = (reg.PT<=0.5);
plot(data.X0(index,1),NN_RES(index),'.g');
plot(data.X0(~index,1),NN_RES(~index),'.r');
xlabel('SST (°C)','FontSize',12);
xlim([MIN_X MAX_X]);
ylim([-4 4]);

subplot(2,3,6);
hold on;
title('STDVs over SSTs','FontSize',16);
plot(data.X0(:,1),sqrt(NU),'.k');
xlabel('SST (°C)','FontSize',12);
xlim([MIN_X MAX_X]);

set(fig,'Position',[20 20 2000 900]);
movegui(fig,'center');
drawnow;


end