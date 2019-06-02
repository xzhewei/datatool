function drawGT
% Caltech
% set='usa';
% s=6;
% v=6;
% f=239;
% nf=370; % Ö¡Êý
% load('E:\Code\datatool\caltech\results\UsaTest\gt-All.mat');

% SCUT
set='scut';
s=15;
v=5;
f=2074;
nf=1634; % Ö¡Êý
load('E:\Code\datatool\scut\results\scuttest\gt-All.mat')

bbox = gt{nf}(:,1:4);

drawBBox(set,s,v,f,bbox,'g','-',2);
end