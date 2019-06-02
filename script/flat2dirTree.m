% This code copies the video and annotation files into their respective
% subfolders.
ccc;
dir = '/mnt/RD/DataSet/SCUT_FIR_101/';
vdir = [dir 'videos'];
adir = [dir 'annotations'];
settingfilename = [dir 'analysis.xlsx'];
[~,~,raw] = xlsread(settingfilename,'vCount');
head = raw(1,:);
tree = cell2struct(raw(2:end,:)',head);

num = length(tree);
ticId = ticStatus('copy file:',0.2,1);
for i=1:num
    fname = tree(i).fname;
    vname = tree(i).vname;
    subname = tree(i).subname;
    vname = tree(i).vname;
    vtdir = fullfile(dir,'tree','videos',subname);
    atdir = fullfile(dir,'tree','annotations',subname);
    if(~exist(vtdir,'dir'))
        mkdir(vtdir);         
    end
    if(~exist(atdir,'dir'))
        mkdir(atdir);         
    end
    copyfile(fullfile(vdir,[fname '.seq']),fullfile(vtdir,[vname '.seq']));
    copyfile(fullfile(adir,[fname '.txt']),fullfile(atdir,[vname '.txt']));
    tocStatus(ticId,i/num);    
end

% load subtree;
