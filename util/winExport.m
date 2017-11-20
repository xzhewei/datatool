function Is = winExport( detector, stage, positive )
% Load or sample windows for training detector.
opts=detector.opts; start=clock;
if( positive ), n=opts.nPos; else n=opts.nNeg; end %想要提取的样本数量
if( positive ), crDir=opts.posWinDir; else crDir=opts.negWinDir; end %样本存储文件夹
if( exist(crDir,'dir') && stage==0 ) 
    % if window directory is specified simply load windows
    % %如果样本文件夹存在则使用文件夹里的样本训练
    fs=xbbGt('getFiles',{crDir}); nImg=length(fs); assert(nImg>0);
    if(nImg>n), fs=fs(:,randSample(nImg,n)); end; n=nImg;%当nImg数量大于n时，从nImg从随机选取n个样本
    for i=1:n, fs{i}=[{opts.imreadf},fs(i),opts.imreadp]; end %opts.imreadp保存参数
    Is=cell(1,n); parfor i=1:n, Is{i}=feval(fs{i}{:}); end %并行feval运行imreadf函数
else
    % sample windows from full images using sampleWins1() %使用随机提取的方法
    fs={opts.negImgDir}; %先假设有负样本图像
    hasGt=positive||isempty(opts.negImgDir); %如果没有负样本图像或提取的是正样本 
    if(hasGt), fs={opts.posImgDir,opts.posGtDir}; end %则只能从正样本图像中提取正样本和负样本
    fs=xbbGt('getFiles',fs); nImg=size(fs,2); assert(nImg>0);
    if(~isinf(n)) %正样本可能是inf的，即有多少提取多少
        fs=fs(:,randperm(nImg)); 
    end; 
    Is=cell(nImg*1000,1);% nImg是帧数，先假设每帧的标注框不会超过1000个
    bbs=zeros(nImg*1000,5);
    diary('off'); tid=ticStatus('Sampling windows',1,30); 
    k=0; i=0; batch=64; %分批提取 i是帧数，n是样本数
    while( i<nImg && k<n )
        batch=min(batch,nImg-i); 
        Is1=cell(1,batch);
        bbs1=cell(1,batch);
        for j=1:batch, ij=i+j;%原来是parfor
            I = feval(opts.imreadf,fs{1,ij},opts.imreadp{:}); 
            [~,vname,~]=fileparts(fs{1,ij});
            opts.xWinSave.vname = vname;
            detector.opts = opts;
            gt=[]; if(hasGt), [~,gt]=xbbGt('bbLoad',fs{2,ij},opts.pLoad); end %opts.pLoad??
            [Is1{j},bbs1{j}] = winExtract( I, gt, detector, stage, positive ); %I是图像，gt是标注信息
        end 
        Is1=[Is1{:}]; 
        bbs1=cat(1,bbs1{:});
        k1=length(Is1); 
        Is(k+1:k+k1)=Is1;
        bbs(k+1:k+k1,:)=bbs1;
        k=k+k1;
        if(k>n)%如果k大于了n则用randSample从1~k中随机选n个
            ir = randSample(k,n);
            Is=Is(ir);bbs=bbs(ir,:);
            k=n; 
        end 
        i=i+batch; tocStatus(tid,max(i/nImg,k/n));
    end
    Is=Is(1:k);
    bbs=bbs(1:k,:);
    diary('on');
    fprintf('Sampled %i windows from %i images.\n',k,i);
end

% % optionally jitter positive windows %可选，轻微抖动正样本窗口%%？为什么要这么做
% if(length(Is)<2), Is={}; return; end
% nd=ndims(Is{1})+1; Is=cat(nd,Is{:}); IsOrig=Is;
% if( positive && isstruct(opts.pJitter) ) %这里看不太懂
%     opts.pJitter.hasChn=(nd==4); Is=jitterImage(Is,opts.pJitter);
%     ds=size(Is); ds(nd)=ds(nd)*ds(nd+1); Is=reshape(Is,ds(1:nd));
% end

% % make sure dims are divisible by shrink and not smaller than modelDsPad
% % 裁剪样本框
% ds=size(Is); cr=rem(ds(1:2),opts.pPyramid.pChns.shrink); s=floor(cr/2)+1;
% e=ceil(cr/2); Is=Is(s(1):end-e(1),s(2):end-e(2),:,:); ds=size(Is);
% if(any(ds(1:2)<opts.modelDsPad)), error('Windows too small.'); end

% % optionally save windows to disk and update log
% % 可选把截取的样本保存到变量mat文件
% nmIs=[opts.name 'Is' int2str(positive) 'Stage' int2str(stage)];
% nmbbs=[opts.name 'bbs' int2str(positive) 'Stage' int2str(stage)];
% if( opts.winsSave )
%     save(nmIs,'Is','-v7.3'); 
%     save(nmbbs,'bbs','-v7.3');
% end
%

fprintf('Done sampling windows (time=%.0fs).\n',etime(clock,start));
diary('off');

end

function [Is,bbs] = winExtract( I, gt, detector, stage, positive )
% Sample windows from I given its ground truth gt.
opts=detector.opts; 
% shrink=opts.pPyramid.pChns.shrink;
modelDs=opts.modelDs; 
% modelDsPad=opts.modelDsPad;
if( positive )% 提取正样本
    bbs=gt; bbs=bbs(bbs(:,5)==0,:); %第5位是是否忽略该bb的标签
else %提取负样本
    if( stage==0 )
        % generate candidate bounding boxes in a grid 
        %在图像上画网格提取负样本，预先设定了每张图提取的负样本数量
        n=opts.nPerNeg;
        bbs = randExtractROI(I,opts.imRng,modelDs,n);
    end
    if( stage==1 )
        % run detector to generate candidate bounding boxes
        % %非stage==0则使用检测器来提取困难负样本
        bbs=acfDetect(I,detector); [~,ord]=sort(bbs(:,5),'descend');
        bbs=bbs(ord(1:min(end,opts.nPerNeg)),1:4);
    end
    if( stage==-1 )
        bbs = extractROI(I,opts.roiOpts);
%         % 显示提取效果
%         figure(1);
%         hold on;
%         for i = 1:size(gt,1)            
%             rectangle('position',gt(i,1:4),'edgecolor','g');
%         end
%         hold off;
%         gt(:,1) = gt(:,1)-opts.imRng(1)+1;
%         gt(:,2) = gt(:,2)-opts.imRng(2)+1;
%         figure(2);
%         hold on;
%         for i = 1:size(gt,1)            
%             rectangle('position',gt(i,1:4),'edgecolor','g');
%         end
%         hold off;
%         %OK
    end
    if( ~isempty(gt) )
        % discard any candidate negative bb that matches the gt
        % 排除掉与gt重合的负样本
        n=size(bbs,1); keep=false(1,n);       
        for i=1:n,
            keep(i)=all(xbbGt('compOas',bbs(i,:),gt,gt(:,5))<1e-5); %几乎不能有交集            
        end
        bbs=bbs(keep,:);
    end
end
% %grow bbs to a large padded size and finally crop windows
% %放大bb，来获得不同尺度的裁剪样本
% modelDsBig=max(8*shrink,modelDsPad)+max(2,ceil(64/shrink))*shrink;
% %这里修改后的bb大小
% r=modelDs(2)/modelDs(1); 
% assert(all(abs(bbs(:,3)./bbs(:,4)-r)<1e-5)); %保证宽高比与预设的modelDs的一致
% r=modelDsBig./modelDs;  %padding的放大倍率
% bbs=bbApply('resize',bbs,r(1),r(2)); %修改bb的尺寸，增加padding
% %裁剪，并归一化，当bbs超过I的边缘时，采用复制边缘的形式
% Is=bbApply('crop',I,bbs,'replicate',modelDsBig([2 1])); %最后一个参数是固定宽高,即归一化
% bbs=bbApply('resize',bbs,1,0,0.5);
Is=bbApply('crop',I,bbs,'replicate');
if(opts.winsSave)
    saveImg2f(Is,opts.xWinSave);
end
end

function bbs = randExtractROI(I,imRng,winSize,n)
[h,w,~]=size(I);
h1=winSize(1); w1=winSize(2);
padt = imRng(2)-1;
padl = imRng(1)-1;
padb = h-imRng(4)-padt;
padr = w-imRng(3)-padl;

%ny=sqrt(n*h/w); nx=n/ny; ny=ceil(ny); nx=ceil(nx); %原始方法是就画n个格子
%[xs,ys]=meshgrid(linspace(1,w-w1,nx),linspace(1,h-h1,ny));
nh = floor((h-padt-padb)/h1);nw=floor((w-padl-padr)/w1);
%padh =floor(h-nh*h1)/2;padw = floor(w-nw*w1)/2;
yl = linspace(1+padt,h-padb-h1,nh);
xl = linspace(1+padl,w-padr-w1,nw);
[xs,ys]=meshgrid(xl,yl);
bbs=[xs(:) ys(:)];
bbs(:,3)=w1;
bbs(:,4)=h1;
bbs(:,5)=0;
bbs=bbs(randSample(nh*nw,n),:);%随机选择N个
end

function saveImg2f(img,xWinSave)
if(~exist(xWinSave.tDir,'dir')), mkdir(xWinSave.tDir); end
for i=1:numel(img)
    f = [xWinSave.tDir '/V' xWinSave.vname '_Win' int2str2(i,2) '.jpg'];
    imwrite(img{i},f);
end
end
