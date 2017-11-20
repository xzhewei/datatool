function xdbExport( list, tDir, flatten, skip )
%
% USAGE
%  dbExtract( list, tDir, flatten, skip )
%
% INPUTS
%  list     - 1xN cell
%  tDir     - [] target dir for image data (defaults to dataset dir)
%  flatten  - [0] if true output all images to single directory
%  skip     - [] specify frames to extract (defaults to skip in dbInfo)
%
% OUTPUTS
%
% EXAMPLE
%  see testdbExport
%
% See also vbb testdbExport dbExtract
%
% Zavier's Computer Vision Matlab Toolbox      Version 0.0.1
% Copyright 2016 Zhewei Xu.         [xzhewei-at-gmail.com]
%

if(nargin<2 || isempty(tDir)), tDir='.'; end
if(nargin<3 || isempty(flatten)), flatten=0; end
if(nargin<4 || isempty(skip)), skip=4; end
pth = tDir;
for cname = list
    % load ground truth
    [~,name,~] = fileparts(cname{1});
    A=vbb('vbbLoad',[pth '/annotations/' name '.txt']); n=A.nFrame;
    if(flatten), post=''; else post=[name '/']; end
    if(flatten), f=[name '_']; else f=''; end
    fs=cell(1,n); for i=1:n, fs{i}=[f 'I' int2str2(i-1,5)]; end
    
    % extract images
    td=[tDir '/export/images/' post]; if(~exist(td,'dir')), mkdir(td); end
    sr=seqIo([pth '/videos/' name '.seq'],'reader'); info=sr.getinfo();
    for i=skip-1:skip:n-1 
        f=[td fs{i+1} '.' info.ext]; if(exist(f,'file')), continue; end
        sr.seek(i); I=sr.getframeb(); f=fopen(f,'w'); fwrite(f,I); fclose(f);
        fprintf('Export frame %d image: %s.\n',i,f );
    end; sr.close();
    
    % extract ground truth
    td=[tDir '/export/annotations/' post];
    for i=1:n, fs{i}=[fs{i} '.txt']; end
    vbb('vbbToFiles',A,td,fs,skip,skip);
end


end

