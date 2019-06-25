function [dtr,f_gt,f_fp,gt,fp] = filter_by_area(R,gpc)
dtr = R.dtr;
f_gt = zeros(numel(dtr),1);
f_fp = zeros(numel(dtr),1);
gt = zeros(numel(dtr),1);
fp = zeros(numel(dtr),1);
for i=1:numel(dtr)
    if isempty(dtr{i})
        continue;
    end
    [~,yc] = box2center(dtr{i});
    gti = dtr{i}(:,6)==1;
    fpi = dtr{i}(:,6)==0;
    outer = yc<gpc{i}(2) | yc>gpc{i}(3);
    dtr{i}(:,6) = [];
    dtr{i}(outer,:)=[];

    f_gt(i) = sum(outer(gti));
    f_fp(i) = sum(outer(fpi));
    gt(i) = sum(gti);
    fp(i) = sum(fpi);
end

end



