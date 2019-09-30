function [cal_model] = LearnModel(inputFile)

disp('## Initialization:');
setting = getSetting(inputFile);
disp('#  Settings are loaded.');
data = getData(inputFile);
data = regularizeData(data);
disp('#  Data are loaded.');
[param,reg,timeline] = getParam(data,setting);
disp('#  Parameters are loaded.');
reg = getReg(reg,data,param);
disp('#  Regression is done.');
timeline = updateTimeline(reg,data,param,timeline,0);
disp('#  Timeline is updated.');
disp(['   Initial log-likelihood is ',num2str(timeline.logliks(1)),'.']);
disp(['   Initial correlation between SSTs and inlier residuals is ',num2str(timeline.corr(:,1)'),'.']);
disp('----------------------------------------------');
fig = getFigure(reg,data,timeline,0);

for t = 1:setting.max_iters
    disp(['## Iteration ',num2str(t),':']);
    reg = getOutliers(reg,data,setting);
    disp('#  Outliers are sampled.');
    if rem(t,10) == 0
        param = learnBandWidth(reg,data,param);
        disp(['#  Bandwidths are tuned. K is ',num2str(param.k),'.']);
    end
    param = getBandwidth(data,param,reg);
    disp('#  Bandwidths are obtained.');
    reg = learnVar_NW(reg,data,param);
    disp('#  Variances are updated.');
    samples = getSamples(data,setting);
    disp('#  Subsets are sampled.');
    [param,data] = learnParam(data,samples,reg,param);
    disp('#  Kernel and features are updated.');
    reg = getReg(reg,data,param);
    disp('#  Regression is done.');
    timeline = updateTimeline(reg,data,param,timeline,t);
    disp('#  Timeline is updated.');
    disp(['   Log-likelihood is ',num2str(timeline.logliks(t+1)),'.']);
    disp(['   Correlation between SSTs and inlier residuals is ',num2str(timeline.corr(:,t+1)'),'.']);
    disp('----------------------------------------------');
    if rem(t,10) ~= 1
        close(fig);
    end
    fig = getFigure(reg,data,timeline,t);
end


results = struct('data',cell(1,1),'reg',cell(1,1),'param',cell(1,1),'setting',cell(1,1),'timeline',cell(1,1));
results.data = data;
results.reg = reg;
results.param = param;
results.setting = setting;
results.timeline = timeline;

% Storing the results:
path = ['Outputs/Training_Datasets/',inputFile];
if exist(path,'dir') == 7
    n = 0;
    DET = 1;
    while DET == 1
        n = n + 1;
        path = ['Outputs/Training_Datasets/',inputFile,'(',num2str(n),')'];
        if exist(path,'dir') == 0
            DET = 0;
        end
    end
end
mkdir(path);

fileID = [path,'/results.mat'];
save(fileID,'results');

getGIF(path);

cal_model = getDist(reg,data,param);

fileID = [path,'/calibration_model.txt'];
fid = fopen(fileID,'wt');
fprintf(fid,'SST(°C) mean stdv');
fprintf(fid,'\n');
for i = 1:size(cal_model,1)
    fprintf(fid,'%f %f %f',[cal_model(i,1),cal_model(i,2),cal_model(i,3)]);
    fprintf(fid,'\n');
end
fclose(fid);

disp(['#  Results are stored in ',path,'.']);
disp('----------------------------------------------------------------------------');


end