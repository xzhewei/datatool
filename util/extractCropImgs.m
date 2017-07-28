function extractCropImgs(fname,seqDir,annDir)
%     fname = '20131206-173911';
    A = vbb('vbbLoad',[annDir '/' fname '.txt']);
    Is = seqIo([seqDir '/' fname '.seq'],'toImgs');
    for i = 1:A.maxObj
        if(~A.objInit(i)==0)
            obj1 = getObj(A,i,Is);
            objExportImgs(obj1,fname);
        end
    end
end