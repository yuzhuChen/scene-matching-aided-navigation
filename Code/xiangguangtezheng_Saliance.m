%图像稀疏表示
clear all;
%histeq(I)  用于直方图均衡化
t1=clock;
image_Origin = imread('223_223_5_8km.png');
%判断图像的通道数，将三通道图像转为黑白
%image_Origin = imresize(image_Origin,0.5);

if(numel(size(image_Origin))==3)
    image_Gray = rgb2gray(image_Origin);
else
    image_Gray = image_Origin;
end
[rowI,colI]=size(image_Gray);
[A,E,iter] = exact_alm_rpca(double(image_Gray));

%块的边长，限制为odd；
patchSize = 7;
patchMid=fix(patchSize/2)+1;
%patch xiangguantezheng 
ratio=0.7;
sliencePixl=[];
for iPatch= patchSize+patchMid:colI-(patchSize+patchMid)+1
    for jPatch= patchSize+patchMid:rowI-(patchSize+patchMid)+1
        templatetimes9= image_Gray(jPatch-(patchSize+patchMid)+1:jPatch+(patchSize+patchMid)-1,iPatch-(patchSize+patchMid)+1:iPatch+(patchSize+patchMid)-1);
        template=A(jPatch-patchMid+1:jPatch+patchMid-1,iPatch-patchMid+1:iPatch+patchMid-1);
        mean_T=sum(sum(template))/(patchSize*patchSize);
        substraction_T=template - mean_T;
%       基于中心四周的相关面计算
        for iTemplate=patchMid:size(templatetimes9,2)-patchMid+1
            for jTemplate=patchMid:size(templatetimes9,1)-patchMid+1
                if(abs(iPatch-iTemplate)<patchSize&&abs(jPatch-jTemplate)<patchSize)
%        featureSurface(jTemplate-patchMid+1,iTemplate-patchMid+1)=0;
                    continue;
                end
                    I=templatetimes9(jTemplate-patchMid+1:jTemplate+patchMid-1,iTemplate-patchMid+1:iTemplate+patchMid-1);
                    mean_I=sum(sum(I))/(patchSize*patchSize);
                    substraction_I=double(I-mean_I);
                    if(substraction_I==0) substraction_I=1;end
                    featureSurface(jTemplate,iTemplate)=sum(sum(substraction_T.*substraction_I))/(sqrt(sum(sum(substraction_T.*substraction_T)))*sqrt(sum(sum(substraction_I.*substraction_I))));   
            end
        end
%       featureSurface= normxcorr2(template,templatetimes9);
        featureSurfaceInteger=fix(1000*featureSurface);
        featureMaxMatrix=imregionalmax(featureSurfaceInteger).*(featureSurfaceInteger);
        featureMax=sort(featureMaxMatrix(:),'descend');
        featureMaxExtendedMatrix = imextendedmax(featureMaxMatrix,ratio*featureMax(1),4);
        saliencePixl(jPatch,iPatch)=length(find(featureMaxExtendedMatrix));        
    end
end
salience=mat2gray(saliencePixl);
%减弱边缘效应
salience=[zeros(10,213);salience];
salience=[zeros(10,223);salience']';
%

%转为uint8
salienceImg=uint8(salience*255);
salienceImg=double(salienceImg);
image_Origin=double(image_Origin); 
cmap = colormap(jet(256));
rgb = ind2rgb(salienceImg,cmap);
rgb = rgb * 255;
figure(1);
% imshow(uint8(image_Origin*0.6+rgb*0.4),[]);

%保存生成的热图
imwrite(salience,'223_223_5_8km_Xiangguangtezheng0615.jpg');
imwrite(uint8(image_Origin*0.6+rgb*0.4),'223_223_5_8km_Xiangguangtezheng061502.jpg');
t2=clock;
etime(t2,t1);