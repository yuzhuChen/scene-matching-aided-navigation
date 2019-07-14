function [ED,EC]=edgeFeature(I,Corner_box)
I=rgb2gray(I);
I0=edge(I,'Sobel');
%边缘密度
Iedge=find(I0>0);
I_edge_num=size(Iedge);
num=size(Corner_box,1);
T_I_ED=cell(num,1);
ED=[num,1];
weight=Corner_box(:,2)-Corner_box(:,1)-1;
height=Corner_box(:,4)-Corner_box(:,3)-1;
rect=[Corner_box(:,1)';Corner_box(:,3)';weight';height']';%左上角点坐标和其宽和高
%连续度
[m,n]=size(I0);
I_EC=zeros(m,n);
%扩展边界
I0_0=[zeros(1,n);I0;zeros(1,n)];
I0_0=[zeros(1,m+2);I0_0';zeros(1,m+2)];
I0_0=I0_0';
for i=2:size(I0,1)+1;
    for j=2:size(I0,2)+1;
        sum_EC(i,j)=sum(sum(I0_0(i-1:i+1,j-1:j+1)));%计算的连续度图像中的连续边沿太少
        if I0_0(i,j)==1&&(sum(sum(I0_0(i-1:i+1,j-1:j+1)))>3) %I0_0(i-1,j-1)+I0_0(i-1,j)+I0_0(i-1,j+1)+I0_0(i,j-1)+I0_0(i,j)+I0_0(i,j+1)+I0_0(i+1,j-1)+I0_0(i+1,j)+I0_0(i+1,j+1)>3
           I_EC(i,j)=1;
       end
    end
end
imshow(I_EC);
for i=1:size(Corner_box,1)
%截取图片imcrop的weight和height应为实际参数减1.
T_I_ED{i}=imcrop(I0,rect(i,:));
T_I_EC{i}=imcrop(I_EC,rect(i,:));
%边缘密度和边缘连续度的数量级太低@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0516
%边缘密度
T_I{i}=find(T_I_ED{i});
ED(i)=size(T_I{i})/I_edge_num;
%边缘连续度
T_EC{i}=find(T_I_EC{i});
EC(i)=size(T_EC{i})/size(T_I{i});
end
    mat='.mat'; %生成的计算结果文件后缀
    T=num2str(clock); %clock记录当前日期时间，转换成字符串形式
    T(find(isspace(T))) =[]; %去除T中的空格 
    Tl=length(T); %计算T的长度
    Time=T(1:(Tl-6)); %去除T中多余的数字，得到日期和时间的紧凑形式
    title ='EDEC';
    dir='D:\Users\Daisy\Documents\GitHub\scene-matching-aided-navigation\result\'; %保持文件的目录名
    filename=strcat(dir,title,Time,mat); %生成保存文件的路径和文件名
  % dlmwrite(filename,XYR(:,:),'delimiter','\t','newline','pc');%保存到XYR.txt文件:) 
    save( filename,'ED','EC');    