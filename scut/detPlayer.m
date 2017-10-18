function detPlayer(vPth,gPth,dPth,varargin)
dfs={'hr',[50 inf],'occ',{'none','partial'},'ar',0,...
     'bnds',[10 10 700 570],'aspectRatio',.46,...
     'lbls',{'walk_person','ride_person','people',...
      'person?','people?','squat_person'},'sthr',0.3};
[conf.hr,conf.occ,conf.ar,conf.bnds,conf.aspectRatio,conf.lbls,conf.sthr]=...
    getPrmDflt(varargin,dfs,1);

G = vbb('vbbLoad', gPth);
D = load(dPth,'-ascii');

dispFunc=@(f) drawToFrame(conf,G,D,f+1);
seqPlayer(vPth,dispFunc);
end

function hs = drawToFrame(conf,G,D,frame )
filterGt = @(lbl,bb,occl) filterGtFun(lbl,bb,occl,...
    conf.hr,conf.occ,conf.ar,conf.bnds,conf.aspectRatio);
gts = vbb('frameAnn_scut',G,frame,conf.lbls,filterGt);
ind = D(:,1)==frame & D(:,end) >= conf.sthr;
rois = D(ind,2:end);
[gt,dt] = bbGt('evalRes', gts, rois);
hs = showRes(gt, dt);
end

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
      hs{k}=bbApply('draw',dt(i,1:5),cols(dt(i,6)+2),lw,dtLs); end; end
else
  if(gtShow), k=k+1; hs{k}=bbApply('draw',gt(:,1:4),cols(3),lw,gtLs); end
  if(dtShow), k=k+1; hs{k}=bbApply('draw',dt(:,1:5),cols(3),lw,dtLs); end
end
hs=[hs{:}];
end

function p = filterGtFun( lbl, bb, occ, hr, vr, ar, bnds, aspectRatio )
    p=strcmp(lbl,'walk_person'); 
    p=p|strcmp(lbl,'ride_person'); h=bb(4); 
    p=p & (h>=hr(1) & h<hr(2));
    %filter vRng
    % For SCUT
    vVal=0;
    if any( ismember( vr, {'none'} ) ),        vVal=vVal+1;  end
    if any( ismember( vr, {'partial'}) ),      vVal=vVal+2;  end
    occ = 2^occ;
		%if      objs(i).occ == 0,    objs(i).occ = 1;
        %elseif  objs(i).occ == 1,    objs(i).occ = 2;
        %end
    p=p & bitand( occ, vVal );   
    if(ar~=0), p=p & sign(ar)*abs(bb(3)./bb(4)-aspectRatio)<ar; end
    p = p & bb(1)>=bnds(1) & (bb(1)+bb(3)<=bnds(3));
    p = p & bb(2)>=bnds(2) & (bb(2)+bb(4)<=bnds(4));
  end