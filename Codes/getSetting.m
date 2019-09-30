function [setting] = getSetting(inputFile)

setting = struct('q',cell(1,1),'d',cell(1,1),'max_iters',cell(1,1),'bSize',cell(1,1));

path = 'Defaults/setting.txt';
fileID = fopen(path);
INFO = textscan(fileID,'%s %s');
fclose(fileID);

setting.q = str2double(INFO{2}{strcmp(INFO{1},'q:')==1});
setting.d = str2double(INFO{2}{strcmp(INFO{1},'d:')==1});
setting.max_iters = str2double(INFO{2}{strcmp(INFO{1},'max_iters:')==1});
setting.bSize = str2double(INFO{2}{strcmp(INFO{1},'batch_size:')==1});


path = ['Inputs/',inputFile,'/setting.txt'];
if exist(path,'file') == 2
    fileID = fopen(path);
    INFO = textscan(fileID,'%s %s');
    fclose(fileID);
    
    if sum(strcmp(INFO{1},'q:')==1) == 1
        setting.q = str2double(INFO{2}{strcmp(INFO{1},'q:')==1});
    end
    
    if sum(strcmp(INFO{1},'d:')==1) == 1
        setting.d = str2double(INFO{2}{strcmp(INFO{1},'d:')==1});
    end
    
    if sum(strcmp(INFO{1},'nIters:')==1) == 1
        setting.max_iters = str2double(INFO{2}{strcmp(INFO{1},'max_iters:')==1});
    end
    
    if sum(strcmp(INFO{1},'batch_size:')==1) == 1
        setting.bSize = str2double(INFO{2}{strcmp(INFO{1},'batch_size:')==1});
    end
end


end