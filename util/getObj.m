function obj = getObj( A, id, imgs, s, e )

assert( 0<id && id<=A.maxObj );
assert( A.objInit(id)==1 );

if(nargin<4); s=A.objStr(id); else assert(s>=A.objStr(id)); end;
if(nargin<5); e=A.objEnd(id); else assert(e<=A.objEnd(id)); end;

% get general object info
obj.id   = id;
obj.lbl  = A.objLbl{id};
obj.str  = s;
obj.end  = e;
obj.hide = A.objHide(id);

% get per-frame object info
len = obj.end-obj.str+1;
obj.pos  = zeros(len,4);
obj.posv = zeros(len,4);
obj.occl = zeros(len,1);
obj.lock = zeros(len,1);
obj.img  = {}; 
for i=1:len
  f = obj.str+i-1;
  objList = A.objLists{f};
  obj1 = objList([objList.id]==id);
  obj.pos(i,:)  = obj1.pos;
  obj.posv(i,:) = obj1.posv;
  obj.occl(i)   = obj1.occl;
  obj.lock(i)   = obj1.lock;
  img = imgs(:,:,:,f);
  cimg = imcrop(img,obj1.pos);
  obj.img{i} = cimg;
end