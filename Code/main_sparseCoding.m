clear all;
%histeq(I)  用于直方图均衡化
t1=clock;
string
image_Origin = imread('example0710.png');
%判断图像的通道数，将三通道图像转为黑白
%image_Origin = imresize(image_Origin,0.5);
if(numel(size(image_Origin))==3)
    image_Gray = rgb2gray(image_Origin);
else
    image_Gray = image_Origin;
end
%sparse resolve
[A,E,iter] = exact_alm_rpca(double(image_Gray));
imwrite(uint8(A),'example0710_1sA0710.jpg');
imwrite(E,'example0710_1sE0710.jpg');
t2=clock;
 Mat_A=sparseCoding(uint8(A),7);
 imwrite(Mat_A,'example0710_1A0710.jpg');
t3=clock;
 Mat_E=sparseCoding(uint8(E),7);
 imwrite(Mat_E,'example0710_1E0710.jpg');
t4=clock;
%create hot map and save it
 Mat_A=double( Mat_A);
 Mat_E=double( Mat_E);
cmap2=colormap(jet(256));
rgbA=ind2rgb( Mat_A,cmap2);
rgbA = rgbA* 255;
rgbE=ind2rgb( Mat_E,cmap2);
rgbE = rgbE* 255;
image_Origin=double(image_Origin);
imwrite(uint8(image_Origin*0.6+rgbA*0.4),'example0710_1HotA0709.jpg');
imwrite(uint8(image_Origin*0.6+rgbE*0.4),'example0710_1HotE0709.jpg');
t5=clock;
%稀疏项和低秩项的叠加点乘
imgAE=Mat_A.*Mat_E; %matlab的数据转换
%叠加结果按列排序，求得最大值
imgAE_sort=sort(imgAE(:),'descend');
maxAE=imgAE_sort(1); 
%叠加后的元素归一化（以最大值为分母）
for i=1:size(imgAE,1)
    for j=1:size(imgAE,2)
        imgAE(i,j)=imgAE(i,j)/maxAE; 
    end
end
%叠加后的数据转化为图片格式
imgAE=uint8(imgAE*255);
rgbAE=ind2rgb(imgAE,cmap2);
rgbAE = rgbAE* 255;
imwrite(uint8(image_Origin*0.6+rgbAE*0.4),'example0710_1HotAE0709.jpg');
%time comsumption
time_SparseResolve=etime(t2,t1);
timeSA=etime(t3,t2);
timeSE=etime(t4,t3);
timeAll=etime(t5,t1);