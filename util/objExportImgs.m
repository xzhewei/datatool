function out = objExportImgs(obj,tDir)
    id = obj.id;
    lbl = obj.lbl;
    s = obj.str;
    e = obj.end;
    sDir = [tDir '/s'];
    mDir = [tDir '/m'];
    lDir = [tDir '/r'];
    for dirs = {tDir,sDir,mDir,lDir}
        if(~exist(dirs{1},'dir'))
            mkdir(dirs{1}); 
        end;
    end
    for i = 1:e-s
        w = round(obj.pos(i,3));
        h = round(obj.pos(i,4));
        occl = obj.occl(i);
        if(lbl(end) == '?')
            lbl = [lbl(1:end-1) 'V']; %文件名不能有？，因此用vague替代
        end
        if h <= 20
            subDir = sDir;
        elseif h <= 48
            subDir = mDir;
        else
            subDir = lDir;
        end
        f = [subDir '/V' tDir '-ID' int2str2(id,3) '-' lbl  '-I' int2str2(i,5) '-W' int2str(w) '-H' int2str(h) '-OCCL' int2str(occl) '.jpg'];
        imwrite(obj.img{i},f);
        disp(['export img: ' f]);
    end
    out = 0;
end