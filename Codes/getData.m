function [data] = getData(inputFile)

data = struct('X0',cell(1,1),'Y0',cell(1,1),'X',cell(1,1),'Y',cell(1,1),'F',cell(1,1),'mu_X',cell(1,1),'mu_Y',cell(1,1),'sig_X',cell(1,1),'sig_Y',cell(1,1));

path = ['Inputs/Training_Datasets/',inputFile,'/X.txt'];
data.X0 = load(path);

path = ['Inputs/Training_Datasets/',inputFile,'/Y.txt'];
data.Y0 = load(path);


end