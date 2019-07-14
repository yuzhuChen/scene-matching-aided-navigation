function [ED,EC]=edgeFeature(I,Corner_box)
I=rgb2gray(I);
I0=edge(I,'Sobel');
%��Ե�ܶ�
Iedge=find(I0>0);
I_edge_num=size(Iedge);
num=size(Corner_box,1);
T_I_ED=cell(num,1);
ED=[num,1];
weight=Corner_box(:,2)-Corner_box(:,1)-1;
height=Corner_box(:,4)-Corner_box(:,3)-1;
rect=[Corner_box(:,1)';Corner_box(:,3)';weight';height']';%���Ͻǵ���������͸�
%������
[m,n]=size(I0);
I_EC=zeros(m,n);
%��չ�߽�
I0_0=[zeros(1,n);I0;zeros(1,n)];
I0_0=[zeros(1,m+2);I0_0';zeros(1,m+2)];
I0_0=I0_0';
for i=2:size(I0,1)+1;
    for j=2:size(I0,2)+1;
        sum_EC(i,j)=sum(sum(I0_0(i-1:i+1,j-1:j+1)));%�����������ͼ���е���������̫��
        if I0_0(i,j)==1&&(sum(sum(I0_0(i-1:i+1,j-1:j+1)))>3) %I0_0(i-1,j-1)+I0_0(i-1,j)+I0_0(i-1,j+1)+I0_0(i,j-1)+I0_0(i,j)+I0_0(i,j+1)+I0_0(i+1,j-1)+I0_0(i+1,j)+I0_0(i+1,j+1)>3
           I_EC(i,j)=1;
       end
    end
end
imshow(I_EC);
for i=1:size(Corner_box,1)
%��ȡͼƬimcrop��weight��heightӦΪʵ�ʲ�����1.
T_I_ED{i}=imcrop(I0,rect(i,:));
T_I_EC{i}=imcrop(I_EC,rect(i,:));
%��Ե�ܶȺͱ�Ե�����ȵ�������̫��@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0516
%��Ե�ܶ�
T_I{i}=find(T_I_ED{i});
ED(i)=size(T_I{i})/I_edge_num;
%��Ե������
T_EC{i}=find(T_I_EC{i});
EC(i)=size(T_EC{i})/size(T_I{i});
end
    mat='.mat'; %���ɵļ������ļ���׺
    T=num2str(clock); %clock��¼��ǰ����ʱ�䣬ת�����ַ�����ʽ
    T(find(isspace(T))) =[]; %ȥ��T�еĿո� 
    Tl=length(T); %����T�ĳ���
    Time=T(1:(Tl-6)); %ȥ��T�ж�������֣��õ����ں�ʱ��Ľ�����ʽ
    title ='EDEC';
    dir='D:\Users\Daisy\Documents\GitHub\scene-matching-aided-navigation\result\'; %�����ļ���Ŀ¼��
    filename=strcat(dir,title,Time,mat); %���ɱ����ļ���·�����ļ���
  % dlmwrite(filename,XYR(:,:),'delimiter','\t','newline','pc');%���浽XYR.txt�ļ�:) 
    save( filename,'ED','EC');    