%图像稀疏表示
clear all;
close all;
image_Origin = imread("1.jpg");
%判断图像的通道数，将三通道图像转为黑白
if(numel(size(image_Origin))==3)
    image_Gray = rgb2gray(image_Origin);
else
    image_Gray = image_Origin;
end
%image_Origin = imresize(image_Origin,[160,256]);

patch_Weight = 5;
patch_Height = 5;
for i = fix(0.5*patch_Weight)+1:size(image_Gray,2)-fix(0.5*patch_Weight)                 %x方向 水平方向增加 fix为向小取整
    for j = fix(0.5*patch_Height)+1:size(image_Gray,1)-fix(0.5*patch_Height)             %y方向 竖直方向增加
        patch = image_Gray(j-fix(0.5*patch_Height):j+fix(0.5*patch_Height),i-fix(0.5*patch_Weight):i+fix(0.5*patch_Weight));
        patch_Vector = patch2Vector(patch);
        tt = 0;
        %获取斑块的环绕区块
        for s_i = i-patch_Weight:i+patch_Weight
            for s_j = j-patch_Height:j+patch_Height
                if (s_i<fix(0.5*patch_Weight+1)||s_j<fix(0.5*patch_Height+1)||s_i>size(image_Gray,2)-fix(0.5*patch_Weight)||s_j>size(image_Gray,1)-fix(0.5*patch_Height)||(abs(s_i-i)<7&&abs(s_j-j)<7))
                    continue;
                end
                s_patch = image_Gray(s_j-fix(0.5*patch_Height):s_j+fix(0.5*patch_Height),s_i-fix(0.5*patch_Weight):s_i+fix(0.5*patch_Weight));
                s_patch_Vector = patch2Vector(s_patch);
                tt = tt + 1;
                s(:,tt)=s_patch_Vector;         %环绕区块
            end
        end
        %获取斑块的环绕区块
        B{i,j}=lasso(double(s),double(patch_Vector),'Lambda',0.2);
        
    end
end
C = zeros(186,186);
for i = fix(0.5*patch_Weight+1):size(image_Gray,2)-fix(0.5*patch_Weight)        
    for j = fix(0.5*patch_Height+1):size(image_Gray,1)-fix(0.5*patch_Height)
        temp = B{j,i};
        for k = 1:size(temp,2)    %计算获得的稀疏系数中不为0的量
            if(temp(k)~=0)
                C(j,i) = C(j,i) + 1;
            end
        end
    end
end
Z = uint8(C);
imshow(Z);