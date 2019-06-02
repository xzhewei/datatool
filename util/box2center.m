function [xc,yc] = box2center(boxes)
    xc = boxes(:,1)+boxes(:,3)/2;
    yc = boxes(:,2)+boxes(:,4)/2;
end
