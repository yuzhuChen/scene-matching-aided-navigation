

clear all;
temp_image = imread('1.jpg');
I = rgb2gray(temp_image);
figure()
subplot(2,3,1)
imshow(I),title('原图');
subplot(2,3,4)
imhist(I),title('原图直方图')%显示原始图像直方图
J = imnoise(I,'salt & pepper',0.02);%椒盐噪声
subplot(2,3,2)
imshow(J),title('椒盐噪声');
subplot(2,3,5)
imhist(J),title('椒盐直方图')%显示椒盐图像直方图
G = imnoise(I,'gaussian',0.02,0.02);%高斯噪声
subplot(2,3,3)
imshow(G);title('高斯噪声');
subplot(2,3,6)
imhist(G),title('高斯直方图')%显示高斯图像直方图

[A_hat,E_hat, iter] = exact_alm_rpca(double(I));
Img_A=mat2gray(uint8(A_hat));
Img_E=mat2gray(uint8(E_hat));

figure()
subplot(2,3,1)
imshow(Img_A),title('低秩项');   %只能去掉小噪点，并不能完全模糊；可能原因：处理的单张小图片看不出模糊的效果；
                                 %实验：采用大图分块处理，然后拼接的方式进行处理。
subplot(2,3,4)
imhist(Img_A),title('直方图')%显示原始图像直方图
subplot(2,3,2)
imshow(Img_E),title('稀疏项');
subplot(2,3,5)
imhist(Img_E),title('直方图')%显示椒盐图像直方图

save("dizhixiang.jpg",Img_A);