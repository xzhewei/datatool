function [hs] = showRes(gt, dt, varargin )
% Display evaluation results for given image.
%
% USAGE
%  [hs,hImg] = bbGt( 'showRes', I, gt, dt, varargin )
%
% INPUTS
%  I          - image to display, image filename, or []
%  gt         - first output of evalRes()
%  dt         - second output of evalRes()
%  varargin   - additional parameters (struct or name/value pairs)
%   .evShow     - [1] if true show results of evaluation
%   .gtShow     - [1] if true show ground truth
%   .dtShow     - [1] if true show detections
%   .cols       - ['krg'] colors for ignore/mistake/correct
%   .gtLs       - ['-'] line style for gt bbs
%   .dtLs       - ['--'] line style for dt bbs
%   .lw         - [3] line width
%
% OUTPUTS
%  hs         - handles to bbs and text labels
%  hImg       - handle for image graphics object
%
% EXAMPLE
%
% See also bbGt, bbGt>evalRes
dfs={'evShow',1,'gtShow',1,'dtShow',1,'cols','krg',...
  'gtLs','-','dtLs','--','lw',3};
[evShow,gtShow,dtShow,cols,gtLs,dtLs,lw]=getPrmDflt(varargin,dfs,1);
% display bbs with or w/o color coding based on output of evalRes
hs=cell(1,1000); k=0;
if( evShow )
  if(gtShow), for i=1:size(gt,1), k=k+1;
      hs{k}=bbApply('draw',gt(i,1:4),cols(gt(i,5)+2),lw,gtLs); end; end
  if(dtShow), for i=1:size(dt,1), k=k+1;
      hs{k}=bbApply('draw',dt(i,1:4),cols(dt(i,6)+2),lw,dtLs); end; end
else
  if(gtShow), k=k+1; hs{k}=bbApply('draw',gt(:,1:4),cols(3),lw,gtLs); end
  if(dtShow), k=k+1; hs{k}=bbApply('draw',dt(:,1:5),cols(3),lw,dtLs); end
end
% show Labels
% ht=text(pos(1),pos(2)-10, [socc lbl]); hs=[hs ht];           
% set(ht,'color','w','FontSize',10,'FontWeight','bold');
hs=[hs{:}];
end