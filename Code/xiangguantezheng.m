
I=imread('003.jpg');
template=imread('0033.jpg');
I=rgb2gray(I);
%计算相关系数
feature_surface_point = normxcorr2(template,I);
%把相关系数化成整数
feature_surface_point_integer= floor(feature_surface_point*10000);
figure;
mesh(feature_surface_point);
% axis([0 600 0 600 -1 1]);
%构建局部极大值索引矩阵
temp_row=zeros(size(feature_surface_point_integer));
temp_col=zeros(size(feature_surface_point_integer));
%使用findpeaks查找单行、列的局部极大值
for ii=1:size(feature_surface_point_integer,1);
   [pks_row,loc_col]=findpeaks(feature_surface_point_integer(ii,:));
   col_total=length(loc_col);
   for col_num=1:col_total;
      temp_row(ii,loc_col(col_num))=1; 
   end
end
 for jj=1:size(feature_surface_point_integer,2);
        [pks_col,loc_row]=findpeaks(feature_surface_point_integer(:,jj)); 
        row_total=length(loc_row);
        for row_num=1:row_total;
      temp_col(loc_row(row_num),jj)=1; 
   end
 end
 %行列局部极大值的索引相与得到互相垂直90度的梯度极值
 peak_logic=temp_row.*temp_col;
 peak_feature_surface=peak_logic.*feature_surface_point_integer;
 V= sort(peak_feature_surface(:),'descend');
 temp_i=2;
 while ( V(2)==V(1))
 V(2)=V(temp_i+1);
 end
 SMR=V(2)/V(1);
[row2,col2]=find(peak_feature_surface==V(1));
[t_row2,t_col2]=find(peak_feature_surface==V(2));
row2=[row2;t_row2];
col2=[col2;t_col2];
hold on
row2=double(row2);
col2=double(col2);
V(1:2)=double(V(1:2));
plot3(col2,row2,V(1:2)/10000,'k.','markersize',20)   %标记一个黑色的圆点
string={'1','2'};
text(col2,row2,V(1:2)/10000,string); 

[row,col,val]=find(feature_surface_point_integer==V(1));

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

N=sort(N,'descend');
NMR=N(1)*10000/V(1);