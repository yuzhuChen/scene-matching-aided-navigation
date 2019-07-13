%threholds 筛选阈值
%M最大值抑制后所得峰数量
%h,n框的大小
%function  NMS(img_in,threholds,M,w,h)
imgS=imread('223_5_72km_fieldSparse_analysis0413.jpg');
imgL=imread('223_5_72km_fieldLowRank_analysis0412.jpg');
%imgS=imread('223_223_5_8kmSparse.jpg');
%imgL=imread('223_223_5_8kmLowRank.jpg');
%稀疏项和低秩项的叠加点乘
img_p=double(imgS).*double(imgL); %matlab的数据转换
%叠加结果按列排序，求得最大值
img_p_sort=sort(img_p(:));
max=img_p_sort(length(img_p_sort)); 
%叠加后的元素归一化（以最大值为分母）
for i=1:size(img_p,1)
    for j=1:size(img_p,2)
        img_p(i,j)=img_p(i,j)/max; 
    end
end
%叠加后的数据转化为图片格式
img_in=uint8(img_p*255);
%设定阈值，前M个峰值，框的宽和高
threholds=0.8*255;
M=5;
w=50;
h=50;
%将矩阵转换为列向量
img_col=img_in(:);
%求出图像列项量的逻辑矩阵
%img_threholds=img_col>threholds;
%取出大于阈值的元素进行降序排列
Max_img=sort(img_col(img_col>threholds),'descend');  %erro: sort(A(:))对所有元素排序
%选出降序排列后，前M个不相等的元素，并找到在原图片中的坐标
V_M=[];
i=1;
V_M=Max_img(1);
for j=2:size(Max_img) 
    if i==M, break; end
    if V_M(i)~=Max_img(j)
        V_M=[V_M;Max_img(j)];%向量扩展
        i=i+1;
    end
end
[row,col]=find(img_in>=V_M(M));%erro：处理对象不明确
s=[];
C=[];
for i=1:size(row)
   ymin=(row(i)-h/2);
   ymax=(row(i)+h/2);
   xmin=(col(i)-w/2);
   xmax=(col(i)+w/2);
   s=[s;img_in(row(i),col(i))];
   if xmin<1
       xmin=1;
   end
   if xmax>size(img_in,2)
       xmax=size(img_in,2);
   end
   if ymin<1
       ymin=1;
   end
   if ymax>size(img_in,1)
       ymax=size(img_in,1);
   end
   C=[C;xmin xmax ymin ymax];  
end
  saved=nms_01(C,s,0.6);
  %img_show=imread('223_223_5_8km.png');
  img_show=imread('223_5_72km_field.png');
  imshow(img_show);
  hold on;
  Corner_box=[];
  for i=1:size(saved)
     x= C(saved(i),:)
     Corner_box=[Corner_box;x];
     rectx = [x(1) x(2) x(2) x(1) x(1)];
     recty = [x(3) x(3) x(4) x(4) x(3)];
     plot(rectx, recty, 'linewidth',2);%坐标是依据像素吗？
  end
  
  hold off;
       
%end     

