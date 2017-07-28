function oa = xcompOas( dt, gt, ig, den)
% Computes (modified) overlap area between pairs of bbs.
%
% Uses modified Pascal criteria with "ignore" regions. The overlap area
% (oa) of a ground truth (gt) and detected (dt) bb is defined as:
%  oa(gt,dt) = area(intersect(dt,dt)) / area(union(gt,dt))
% In the modified criteria, a gt bb may be marked as "ignore", in which
% case the dt bb can can match any subregion of the gt bb. Choosing gt' in
% gt that most closely matches dt can be done using gt'=intersect(dt,gt).
% Computing oa(gt',dt) is equivalent to:
%  oa'(gt,dt) = area(intersect(gt,dt)) / area(dt)
%
% USAGE
%  oa = bbGt( 'compOas', dt, gt, [ig] )
%
% INPUTS
%  dt       - [mx4] detected bbs
%  gt       - [nx4] gt bbs
%  ig       - [nx1] 0/1 ignore flags (0 by default) %忽略标注框的面积，即分母不考虑标注框
%  den      - [0]   0采用unio作为分母，1采用gt面积作为分母，2采用dt作为分母
%
% OUTPUTS
%  oas      - [m x n] overlap area between each gt and each dt bb
%
% EXAMPLE
%  dt=[0 0 10 10]; gt=[0 0 20 20];
%  oa0 = bbGt('compOas',dt,gt,0)
%  oa1 = bbGt('compOas',dt,gt,1)
%
% See also bbGt, bbGt>evalRes
m=size(dt,1); n=size(gt,1); oa=zeros(m,n);
if(nargin<3), ig=zeros(n,1); end
if(nargin<4), den=0; end
de=dt(:,[1 2])+dt(:,[3 4]); da=dt(:,3).*dt(:,4);%de是检测bb的右下角位置，da是检测框面积
ge=gt(:,[1 2])+gt(:,[3 4]); ga=gt(:,3).*gt(:,4);%ge是标注bb的有下角位置，ga是标注框面积
for i=1:m
  for j=1:n
    %w,h是相交框的宽和高，如果为负，则不相交
    w=min(de(i,1),ge(j,1))-max(dt(i,1),gt(j,1)); if(w<=0), continue; end
    h=min(de(i,2),ge(j,2))-max(dt(i,2),gt(j,2)); if(h<=0), continue; end
    t=w*h; 
    if(ig(j)||den==2) %u是分母，不考虑gt的面积
        u=da(i); 
    else 
        if(den==0)%dt和gt面积相加，减去相交区域
            u=da(i)+ga(j)-t;
        else %de==1
            u=ga(j);
        end
    end; 
    oa(i,j)=t/u;
  end
end
end