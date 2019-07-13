function imageCell= segmentation(I,numRow,numCol)
R1=(0:numRow-1)*fix(size(I,1)/numRow)+1;  %图块横向起始点
R2=(1:numRow)*fix(size(I,1)/numRow);      %图块横向截止点
C1=(0:numCol-1)*fix(size(I,2)/numCol)+1;  %图块纵向起始点
C2=(1:numCol)*fix(size(I,2)/numCol);      %图块纵向终止点
imageCell=cell(numRow,numCol);            %创建一个包含（横*纵）的元胞
figure;
%把图像分块
for i = 1:numRow
    for j = 1:numCol
        imageCell{i,j} = I(R1(i):R2(i),C1(j):C2(j),:);
    end
end
end

