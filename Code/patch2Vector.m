function [patch_Vector] = patch2Vector(patch)
%将patch的灰度矩阵转化为列向量
%patch_Vector = zeors(size(patch,1)*size(patch,2),1);
k = 1;
for i = 1:size(patch,2)   %水平方向增加
    for j = 1:size(patch,1)   %竖直方向增加
        patch_Vector(k,1) = patch(i,j);  %将图块一条条分开
        k = k + 1;
    end
end

end

