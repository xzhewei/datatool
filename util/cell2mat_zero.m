function mat = cell2mat_zero(ce)
% Convert cell to mat with default zeros. 
% The column may not same fill by 0.
    row = size(ce,2);
    col = zeros(row,1);
    for i=1:row
        if ~isempty(ce(i))
            col(i) = numel(ce{i});
        end
    end
    mat = zeros(row,max(col));
    for i=1:row
        if ~isempty(ce(i))
            mat(i,1:col(i)) = ce{i};
        end
    end
end