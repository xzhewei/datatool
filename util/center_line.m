function center = center_line(gt)
    center = zeros(numel(gt),1);
    for i=1:numel(gt)
        if isempty(gt{i})
            continue;
        end
        if sum(gt{i}(:,5)~=-1)==0
            continue;
        end
        pos = rcwh2xywh(gt{i}(:,1:4));
        index = gt{i}(:,5)~=-1;
        center(i) = mean(pos(index,2));
    end
end