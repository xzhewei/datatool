function A = annSplit( filepath,objStr,splitFrame,label1,label2 )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    A = vbb('vbbLoadTxt',filepath);
    id = find(A.objStr==objStr);
    obj1 = vbb( 'get', A, id, objStr,splitFrame-1);
    obj2 = vbb( 'get', A, id, splitFrame);
    if nargin == 4
        obj1.lbl = label1;
    elseif nargin == 5
        obj1.lbl = label1;
        obj2.lbl = label2;
    end
    A = vbb( 'del', A, id);
    obj1.id = -1;
    obj2.id = -1;
    A = vbb( 'add', A, obj1 );
    A = vbb( 'add', A, obj2 );
end

