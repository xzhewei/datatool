function center = center_line(gt)
    center = zeros(numel(gt),1);
    for i=1:numel(gt)
        if isempty(gt{i})
            continue;
        end
        pos = rcwh2xywh(gt{i}(:,1:4));
        center(i) = mean(pos(:,2));
    end
end