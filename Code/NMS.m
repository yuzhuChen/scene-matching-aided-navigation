%threholds 筛选阈值
%M最大值抑制后所得峰数量
%w,h框的宽高
function   Corner_box=NMS(img_in,threholds,M,w,h)
  p = inputParser;
  default_threholds=0.6;
  defaultM=5;
  default_w=50;
  default_h=50;
  addRequired(p,'img_in');
  addOptional(p,'threholds',default_threholds,@isnumeric);
  addOptional(p,'M',defaultM,@isnumeric);
  addOptional(p,'w',default_w,@isnumeric);
  addOptional(p,'h',default_h,@isnumeric);
%设定阈值，前M个峰值，框的宽和高
threholds=0.8*255;
M=5;
w=50;
h=50;
%将矩阵转换为列向量
img_col=img_in(:);
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
  saved=nms_01(C,s,threholds);
  Corner_box=[];
  for i=1:size(saved)
     x= C(saved(i),:)
     Corner_box=[Corner_box;x]; 
  end
    mat='.mat'; %生成的计算结果文件后缀
    T=num2str(clock); %clock记录当前日期时间，转换成字符串形式
    T(find(isspace(T))) =[]; %去除T中的空格 
    Tl=length(T); %计算T的长度
    Time=T(1:(Tl-6)); %去除T中多余的数字，得到日期和时间的紧凑形式
    title ='Corner_box';
    dir='D:\Users\Daisy\Documents\GitHub\scene-matching-aided-navigation\result\'; %保持文件的目录名
    filename=strcat(dir,title,Time,mat); %生成保存文件的路径和文件名
  % dlmwrite(filename,XYR(:,:),'delimiter','\t','newline','pc');%保存到XYR.txt文件:) 
    save( filename,'Corner_box');     
%end     

