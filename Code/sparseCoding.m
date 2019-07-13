%稀疏低秩分解
function Mat=sparseCoding(image_Origin,patchSize)
if(numel(size(image_Origin))==3)
    image_Gray = rgb2gray(image_Origin);
else
    image_Gray = image_Origin;
end
patch_Weight = patchSize;
patch_Height = patchSize;
%image_Gray=gpuArray(image_Origin);
for i = fix(1.5*patch_Weight)+1:size(image_Gray,2)-fix(1.5*patch_Weight)                 %图块的左上角x fix为向小取整
    for j = fix(1.5*patch_Height)+1:size(image_Gray,1)-fix(1.5*patch_Height)             %图块的左上角y
        patch = image_Gray(j-fix(patch_Height/2):j+fix(patch_Height/2),i-fix(patch_Weight/2):i+fix(patch_Weight/2));  %中心图块
        patch_Vector = patch2Vector(patch);    
        tt = 0;
        %获取斑块的环绕区块
        for s_i = i-patch_Weight:1:i+patch_Weight
            for s_j = j-patch_Height:1:j+patch_Height
                if (abs(s_i-i)<patch_Weight &&abs(s_j-j)<patch_Height)  %修改7为patch_Height和patch_Weight 
                    continue;
                end
                s_patch = image_Gray(s_j-fix(patch_Height/2):s_j+fix(patch_Height/2),s_i-fix(patch_Weight/2):s_i+fix(patch_Weight/2));
                s_patch_Vector = patch2Vector(s_patch);   %pixel valude to vector?????
                tt = tt + 1;
                s(:,tt)=s_patch_Vector;         %s(:,tt)=s_patch_Vector; ????row or column   
            end
        end
        %获取斑块的环绕区块
        B{j,i}=lasso(double(s),double(patch_Vector),'Lambda',0.2);        
    end
end
C = zeros(size(image_Origin));
for i =  fix(1.5*patch_Weight+1):size(image_Gray,2)-fix(1.5*patch_Weight)
    for j = fix(1.5*patch_Height)+1:size(image_Gray,1)-fix(1.5*patch_Height)
        temp = B{j,i};
        for k = 1:size(temp,1)
            %if(temp(k)~=0)
                C(j,i) = C(j,i) + abs(temp(k));
            %end
        end
    end
end
C= imgaussfilt(C, 2);
Mat= uint8(C*255/size(temp,1));