function algs = algsList
n=1000; clrs=zeros(n,3);
for i=1:n, clrs(i,:)=max(.3,mod([78 121 42]*(i+1),255)/255); end
algs_dataset_R1= {  
  %'ACF-T'                   0, clrs(6,:),   '--'
  %'ACF-T+TM+TO',            0, clrs(7,:),   '-'
  'ACF-T+THOG',             0, clrs(8,:),   '--'
  'FRCN-vanilla'            0, clrs(9,:),   '-'
  'RPN-vanilla',            0, clrs(10,:),  '--'
  'FRCN-our',                  0, clrs(12,:),  '-'
  'RPN',                    0, clrs(11,:),  '--'
  'RPN+BF',                 0, clrs(13,:),  '-'
  % mscnn experiment
  'MSCNN',                  0,clrs(14,:), '--'
  'YOLOv2',                 0,clrs(15,:), '-'
  'YOLOv3',                 0,clrs(16,:), '--'
};
algs_temp = {
  'stage1-rpn'                   0, clrs(6,:),   '--'
  'stage1-fast-rcnn',            0, clrs(7,:),   '-'
  'TFRCN',                       0, clrs(8,:),   '--'
  'e2e-frcnn-VGG16-C5d2-im1.5'            0, clrs(9,:),   '-'
  'scut_4s_480_20k_test_ped',            0, clrs(10,:),  '--'
};
algs = algs_temp;
end