function [ roadline ] = generate_roadline(gt)
    roadline = mean(gt);
end

function roadline = mean(gt)
    roadline = center_line(gt);
end

