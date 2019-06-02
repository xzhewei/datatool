figure;
anchorMapC = ones(90,120);
centerC = round(197*1.5/8);
stepC = ones(90,1);
for i = 1:90
    if abs(i-centerC)>=10
        stepC(i)= ceil((abs(i-centerC)-10)/8)+1;
    end
end
sparseAnchorC = zeros(90,120);
for i = 1:90
    sparseAnchorC(i,stepC(i):stepC(i):end)=1;
end
numC = sum(sum(sparseAnchorC))*15;
imagesc(sparseAnchorC);
colormap('hot');
figure;

anchorMapS = ones(108,135);
centerS = round(216*1.5/8);
stepS = ones(108,1);
for i = 1:108
    if abs(i-centerS)>=10
        stepS(i)= ceil((abs(i-centerS)-10)/8)+1;
    end
end
sparseAnchorS = zeros(108,135);
for i = 1:108
    sparseAnchorS(i,stepS(i):stepS(i):end)=1;
end
numS = sum(sum(sparseAnchorS))*15;
imagesc(sparseAnchorS);
colormap('hot');