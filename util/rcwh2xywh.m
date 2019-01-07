function xywh = rcwh2xywh(rcwh)
    x = rcwh(:,1)+rcwh(:,3)/2;
    y = rcwh(:,2)+rcwh(:,4)/2;
    xywh = [x,y,rcwh(:,3:4)];
end