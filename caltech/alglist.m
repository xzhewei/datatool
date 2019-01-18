function algs = alglist()
n=1000; clrs=zeros(n,3);
for i=1:n, clrs(i,:)=max(.3,mod([78 121 42]*(i+1),255)/255); end
algs = {  
  'frcnn_VGG16_C4',       0, clrs(6,:),   '-'
};
end