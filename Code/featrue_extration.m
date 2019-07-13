
I=imread('001.jpg');
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
rect=[Corner_box(:,1)';Corner_box(:,3)';weight';height']';
%连续度
[m,n]=size(I0);
I_EC=zeros(m,n);
%扩展边界
I0_0=[zeros(1,n);I0;zeros(1,n)];
I0_0=[zeros(1,m+2);I0_0';zeros(1,m+2)];
I0_0=I0_0';
for i=2:size(I0,1)+1
    for j=2:size(I0,2)+1
        sum_EC(i,j)=sum(sum(I0_0(i-1:i+1,j-1:j+1)));%计算的连续度图像中的连续边沿太少
        if I0_0(i,j)==1&&(sum(sum(I0_0(i-1:i+1,j-1:j+1)))>3) %I0_0(i-1,j-1)+I0_0(i-1,j)+I0_0(i-1,j+1)+I0_0(i,j-1)+I0_0(i,j)+I0_0(i,j+1)+I0_0(i+1,j-1)+I0_0(i+1,j)+I0_0(i+1,j+1)>3
           I_EC(i,j)=1;
       end
    end
end

imshow(I_EC);
for i=1:size(Corner_box,1)
%截取图片imcrop的weight和height应为实际参数减1.
T_G{i}=imcrop(I,rect(i,:));
T_I_ED{i}=imcrop(I0,rect(i,:));
T_I_EC{i}=imcrop(I_EC,rect(i,:));
%边缘密度和边缘连续度的数量级太低@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0516
%边缘密度
T_I{i}=find(T_I_ED{i});
ED(i)=size(T_I{i})/I_edge_num;
%边缘连续度
T_EC{i}=find(T_I_EC{i});
EC(i)=size(T_EC{i})/size(T_I{i});
%相关面
T_G_mean{i}=sum(sum(T_G{i}))/(rect(i,3)*rect(i,4));
for i_G=1:(size(I0,2)-rect(i,3))
    for j_G=1:(size(I0,1)-rect(i,4))
        feature_surface=size(size(I0,2)-rect(i,3),size(I0,1)-rect(i,4));
        I_G_mean=sum(sum(I(i_G:i_G+rect(i,3),j_G:j_G+rect(i,4))))/(rect(i,3)*rect(i,4));
        substraction_T=double(T_G{i}-T_G_mean{i});
        substraction_I=double(I(i_G:i_G+rect(i,3),j_G:j_G+rect(i,4))-I_G_mean);
        feature_surface_point(j_G,i_G)=sum(sum(substraction_T.*substraction_I))/(sqrt(sum(sum(substraction_T.*substraction_T)))*sqrt(sum(sum(substraction_I.*substraction_I))));
    end
end
%把相关系数化成整数
feature_surface_point_integer= floor(feature_surface_point*10000);
figure
mesh(feature_surface_point_integer);
axis([0 174 0 174 0 10000]);
%构建局部极大值索引矩阵
temp_row=zeros(size(feature_surface_point_integer));
temp_col=zeros(size(feature_surface_point_integer));
%使用findpeaks查找单行、列的局部极大值
for ii=1:size(feature_surface_point_integer,1)
   [pks_row,loc_col]=findpeaks(feature_surface_point_integer(ii,:));
   col_total=length(loc_col);
   for col_num=1:col_total
      temp_row(ii,loc_col(col_num))=1; 
   end
end
 for jj=1:size(feature_surface_point_integer,2)
        [pks_col,loc_row]=findpeaks(feature_surface_point_integer(:,jj)); 
        row_total=length(loc_row);
        for row_num=1:row_total
      temp_col(loc_row(row_num),jj)=1; 
   end
 end
 %行列局部极大值的索引相与得到互相垂直90度的梯度极值
 peak_logic=temp_row.*temp_col;
 peak_feature_surface=peak_logic.*feature_surface_point_integer;
 V{i}= sort(peak_feature_surface(:),'descend')
SMR(i)=V{i}(2)/V{i}(1);
[row2{i},col2{i}]=find(peak_feature_surface>=V{i}(2));
hold on
row2{i}=double(row2{i});
col2{i}=double(col2{i});
V{i}(1:2)=double(V{i}(1:2));
plot3(col2{i},row2{i},V{i}(1:2),'k.','markersize',20)   %标记一个黑色的圆点
string={'1','2'};
text(col2{i},row2{i},V{i}(1:2),string); 

[row,col,val]=find(feature_surface_point_integer==V{i}(1));

max_point_i=col;
max_point_j=row;

N_logic=[max_point_i-5>0,max_point_j-5>0,max_point_i+5<n,max_point_j+5<m];
if(N_logic==[1 1 1 1])
N=[feature_surface_point(max_point_j-5,max_point_i),feature_surface_point(max_point_j,max_point_i-5),...
        feature_surface_point(max_point_j+5,max_point_i),feature_surface_point(max_point_j,max_point_i+5),...
        feature_surface_point(max_point_j-4,max_point_i-4),feature_surface_point(max_point_j-4,max_point_i+4),...
        feature_surface_point(max_point_j+4,max_point_i-4),feature_surface_point(max_point_j+4,max_point_i+4)];    
end
if(N_logic==[0 1 1 1])
N=[feature_surface_point(max_point_j-5,max_point_i),...
        feature_surface_point(max_point_j+5,max_point_i),feature_surface_point(max_point_j,max_point_i+5),...
        feature_surface_point(max_point_j-4,max_point_i+4),...
        feature_surface_point(max_point_j+4,max_point_i+4)];     
end
if(N_logic==[1 0 1 1])
N=[feature_surface_point(max_point_j,max_point_i-5),...
        feature_surface_point(max_point_j+5,max_point_i),feature_surface_point(max_point_j,max_point_i+5),...
        feature_surface_point(max_point_j+4,max_point_i-4),feature_surface_point(max_point_j+4,max_point_i+4)];    
end
if(N_logic==[1 0 1 1])
N=[feature_surface_point(max_point_j,max_point_i-5),...
        feature_surface_point(max_point_j+5,max_point_i),feature_surface_point(max_point_j,max_point_i+5),...
        feature_surface_point(max_point_j+4,max_point_i-4),feature_surface_point(max_point_j+4,max_point_i+4)];    
end
if(N_logic==[1 1 0 1])
N=[feature_surface_point(max_point_j-5,max_point_i),feature_surface_point(max_point_j,max_point_i-5),...
        feature_surface_point(max_point_j+5,max_point_i),...
        feature_surface_point(max_point_j-4,max_point_i-4),...
        feature_surface_point(max_point_j+4,max_point_i-4)];   
end
if(N_logic==[1 1 1 0])
N=[feature_surface_point(max_point_j-5,max_point_i),feature_surface_point(max_point_j,max_point_i-5),...
        feature_surface_point(max_point_j,max_point_i+5),...
        feature_surface_point(max_point_j-4,max_point_i-4),feature_surface_point(max_point_j-4,max_point_i+4)];    
end

N=sort(N,'descend')
NMR(i)=N(1)*10000/V{i}(1);
end

