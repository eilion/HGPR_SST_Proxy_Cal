function getGIF(filepath)

path = [filepath,'/results.mat'];
results = load(path);
results = results.results;
timeline = results.timeline;
data = results.data;
X = data.X0;
Y = data.Y0;

MU = timeline.mu*data.sig_Y + data.mu_Y;
NU = timeline.nu*data.sig_Y^2;

logliks = timeline.logliks;
nOutliers = timeline.nOutliers;
isoutlier = timeline.isoutlier;

nImages = size(MU,2);
im = cell(nImages,1);

for idx = 1:nImages
    if rem(idx,2) == 1
        fig1 = figure;
    else
        fig2 = figure;
    end
    
    MIN_Y = min(logliks);
    MAX_Y = max(logliks);
    AA = MAX_Y - MIN_Y;
    MIN_Y = MIN_Y - 0.05*AA;
    MAX_Y = MAX_Y + 0.05*AA;
    subplot(2,3,1);
    hold on;
    title('Log-likelihoods and Outliers','FontSize',16);
    xlabel('iteration','FontSize',12);
    xlim([0,nImages-1]);
    ylim([MIN_Y,MAX_Y]);
    yyaxis left;
    plot(0:idx-1,logliks(1:idx),'-*','Color','b');
    ylabel('log-likelihood','FontSize',12);
    yyaxis right;
    plot(0:idx-1,nOutliers(1:idx)/length(Y),'-*','Color','r');
    ylim([0 0.1]);
    ylabel('proportion of outliers','FontSize',12);
    
    
    MIN_X = min(X(:,1));
    MAX_X = max(X(:,1));
    MIN_Y = min(Y);
    MAX_Y = max(Y);
    AA = MAX_Y - MIN_Y;
    MIN_Y = MIN_Y - 0.05*AA;
    MAX_Y = MAX_Y + 0.05*AA;
    subplot(2,3,2);
    hold on;
    title(['Regression over SSTs, Iter. ',num2str(idx-1)],'FontSize',16);
    index = (isoutlier(:,idx)==0);
    if size(X,2) == 1
        [~,order] = sort(X,'ascend');
        XX = X(order,1);
        MM = MU(order,idx);
        NN = NU(order,idx);
        xx = [XX;flipud(XX)];
        yy = [MM-1.96*sqrt(NN);flipud(MM+1.96*sqrt(NN))];
        patch(xx,yy,1,'FaceColor','k','FaceAlpha',0.1,'EdgeColor','none');
    else
        for n = 1:length(Y)
            plot([X(n,1),X(n,1)],[MU(n,idx)-1.96*sqrt(NU(n,idx)),MU(n,idx)+1.96*sqrt(NU(n,idx))],'Color',[0.7,0.7,0.7]);
        end
    end
    plot(X(index,1),Y(index),'.g');
    plot(X(~index,1),Y(~index),'.r');
    if size(X,2) == 1
        plot(XX,MM,'--k','LineWidth',2);
    end
    xlabel('SST (°C)','FontSize',12);
    xlim([MIN_X MAX_X]);
    ylim([MIN_Y MAX_Y]);
    
    
    TT = log(sqrt(sum(timeline.corr.^2,1)));
    subplot(2,3,3);
    hold on;
    title('Ks and Correlations','FontSize',16);
    xlabel('iteration','FontSize',12);
    xlim([0,nImages-1]);
    yyaxis left;
    plot(0:idx-1,timeline.K(1:idx),'-*','Color','b');
    ylim([0 10]);
    ylabel('K','FontSize',12);
    yyaxis right;
    plot(0:idx-1,TT(1:idx),'-*','Color','r');
    ylim([min(TT)-0.1 max(TT)+0.1]);
    ylabel('log norms of correlations','FontSize',12);
    
    
    NN_RES = (Y-MU(:,idx))./sqrt(NU(:,idx));
    
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
    xx = [[MIN_X;MAX_X];flipud([MIN_X;MAX_X])];
    yy = [-1.96*[1;1];flipud(1.96*[1;1])];
    patch(xx,yy,1,'FaceColor','k','FaceAlpha',0.1,'EdgeColor','none');
    index = (isoutlier(:,idx)==0);
    plot(X(index,1),NN_RES(index),'.g');
    plot(X(~index,1),NN_RES(~index),'.r');
    plot([MIN_X,MAX_X],[0,0],'--k','LineWidth',2);
    xlabel('SST (°C)','FontSize',12);
    xlim([MIN_X MAX_X]);
    ylim([-4 4]);
    
    
    subplot(2,3,6);
    hold on;
    title('STDVs over SSTs','FontSize',16);
    plot(data.X0(:,1),sqrt(NU(:,idx)),'.k');
    xlabel('SST (°C)','FontSize',12);
    xlim([MIN_X MAX_X]);
    ylim([0 max(max(sqrt(NU(:,10:end))))]);
    
    
    if rem(idx,2) == 1
        set(fig1,'Position',[20 20 2000 900]);
        movegui(fig1,'center');
    else
        set(fig2,'Position',[20 20 2000 900]);
        movegui(fig2,'center');
    end
    
    drawnow;
    if rem(idx,2) == 1
        frame = getframe(fig1);
    else
        frame = getframe(fig2);
    end
    im{idx} = frame2im(frame);
    
    if idx > 1
        if rem(idx,2) == 1
            close(fig2);
        else
            close(fig1);
        end
    end
end
close all;

filename = [filepath,'/learning_animation.gif'];
for idx = 1:nImages
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',1,'DelayTime',0.1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end


end