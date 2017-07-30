pth = 'F:\DataSet\SCUT_FIR_101\datasets\';
if (0)
[allCount,allbboxList,vCount,vbboxList,lCount] = vbbCount_datasets( pth );
save([pth 'analysis.mat']);
else
load([pth 'analysis.mat']);
end

vhead = {'road','fname','nFrame','lFrame','bbox','uobjs','occl',...
         'frame_per_obj','bbox_per_frame'};
fvCount = struct2cell(vCount)';
fvCount = [vhead; fvCount];
xlswrite([pth 'analysis.xlsx'],fvCount,'vCount');

lhead = {'fname','label','nFrame','lFrame','bbox','uobjs','occl',...
         'bbox_per_obj','bbox_per_frame'};
flCount = struct2cell(lCount)';
flCount = [lhead; flCount];
xlswrite([pth 'analysis.xlsx'],flCount,'lCount');    

allhead = {'Type','nFrame','lFrame','bbox','uobjs','occl','frame_per_obj','bbox_per_frame'};
fallCount = struct2cell(allCount)';
fallCount = [allhead; fallCount];
xlswrite([pth 'analysis.xlsx'],fallCount,'aCount'); 