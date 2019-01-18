function gts = loadGT2cell( exps, subset, skip, aspectRatio, bnds )
% Load ground truth of all experiments for all frames.
fprintf('Loading ground truth: %s\n',subset);
nExp=length(exps); gts=cell(1,nExp);
[~,setIds,vidIds,~] = dbInfo;
for i=1:nExp
  gName = [subset int2str(skip) '/gt-' exps(i).name '.mat'];
  if(exist(gName,'file')), gt=load(gName); gts{i}=gt.gt; continue; end
  fprintf('\tExperiment #%d: %s\n', i, exps(i).name);
  gt=cell(1,100000); k=0; lbls={'walk_person','ride_person','people',...
      'person?','people?','squat_person'};
  filterGt = @(lbl,bb,occl) filterGtFun(lbl,bb,occl,...
    exps(i).hr,exps(i).occ,exps(i).ar,bnds,aspectRatio);
  for s=1:length(setIds)
    for v=1:length(vidIds{s})
      A = loadVbb(s,v);
      for f=skip-1:skip:A.nFrame-1
        bb = vbb('frameAnn_scut',A,f+1,lbls,filterGt); ids=bb(:,5)~=1;
        bb(ids,:)=bbApply('resize',bb(ids,:),1,0,aspectRatio);
        k=k+1; gt{k}=bb;
      end
    end
  end
  gt=gt(1:k); gts{i}=gt; save(gName,'gt','-v6');
end

  function p = filterGtFun( lbl, bb, occ, hr, vr, ar, bnds, aspectRatio )
    p=strcmp(lbl,'walk_person'); % for reasonable walk person
    p=p|strcmp(lbl,'ride_person'); % for reasonable all
%    p=strcmp(lbl,'ride_person'); % for reasonable ride person
    h=bb(4); 
    p=p & (h>=hr(1) & h<hr(2));
    % filter vRng
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
end