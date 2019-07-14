function [SMR,NMR]=featuresurface(I,Corner_box)
if size(I)
I=rgb2gray(I);
for i=1:size(Corner_box,1)
%��ȡͼƬimcrop��weight��heightӦΪʵ�ʲ�����1.
T_G{i}=imcrop(I,rect(i,:));
%�����
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
%�����ϵ����������
feature_surface_point_integer= floor(feature_surface_point*10000);
figure
mesh(feature_surface_point_integer);
axis([0 174 0 174 0 10000]);
%�����ֲ�����ֵ��������
temp_row=zeros(size(feature_surface_point_integer));
temp_col=zeros(size(feature_surface_point_integer));
%ʹ��findpeaks���ҵ��С��еľֲ�����ֵ
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
 %���оֲ�����ֵ����������õ����ഹֱ90�ȵ��ݶȼ�ֵ
 peak_logic=temp_row.*temp_col;
 peak_feature_surface=peak_logic.*feature_surface_point_integer;
 V{i}= sort(peak_feature_surface(:),'descend')
SMR(i)=V{i}(2)/V{i}(1);
[row2{i},col2{i}]=find(peak_feature_surface>=V{i}(2));
hold on
row2{i}=double(row2{i});
col2{i}=double(col2{i});
V{i}(1:2)=double(V{i}(1:2));
plot3(col2{i},row2{i},V{i}(1:2),'k.','markersize',20)   %���һ����ɫ��Բ��
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
    mat='.mat'; %���ɵļ������ļ���׺
    T=num2str(clock); %clock��¼��ǰ����ʱ�䣬ת�����ַ�����ʽ
    T(find(isspace(T))) =[]; %ȥ��T�еĿո� 
    Tl=length(T); %����T�ĳ���
    Time=T(1:(Tl-6)); %ȥ��T�ж�������֣��õ����ں�ʱ��Ľ�����ʽ
    title ='SMRNMR';
    dir='D:\Users\Daisy\Documents\GitHub\scene-matching-aided-navigation\result\'; %�����ļ���Ŀ¼��
    filename=strcat(dir,title,Time,mat); %���ɱ����ļ���·�����ļ���
  % dlmwrite(filename,XYR(:,:),'delimiter','\t','newline','pc');%���浽XYR.txt�ļ�:) 
    save( filename,'SMR','NMR');  