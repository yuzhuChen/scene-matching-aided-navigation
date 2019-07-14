%threholds ɸѡ��ֵ
%M���ֵ���ƺ����÷�����
%w,h��Ŀ��
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
%�趨��ֵ��ǰM����ֵ����Ŀ�͸�
threholds=0.8*255;
M=5;
w=50;
h=50;
%������ת��Ϊ������
img_col=img_in(:);
%ȡ��������ֵ��Ԫ�ؽ��н�������
Max_img=sort(img_col(img_col>threholds),'descend');  %erro: sort(A(:))������Ԫ������
%ѡ���������к�ǰM������ȵ�Ԫ�أ����ҵ���ԭͼƬ�е�����
V_M=[];
i=1;
V_M=Max_img(1);
for j=2:size(Max_img) 
    if i==M, break; end
    if V_M(i)~=Max_img(j)
        V_M=[V_M;Max_img(j)];%������չ
        i=i+1;
    end
end
[row,col]=find(img_in>=V_M(M));%erro�����������ȷ
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
    mat='.mat'; %���ɵļ������ļ���׺
    T=num2str(clock); %clock��¼��ǰ����ʱ�䣬ת�����ַ�����ʽ
    T(find(isspace(T))) =[]; %ȥ��T�еĿո� 
    Tl=length(T); %����T�ĳ���
    Time=T(1:(Tl-6)); %ȥ��T�ж�������֣��õ����ں�ʱ��Ľ�����ʽ
    title ='Corner_box';
    dir='D:\Users\Daisy\Documents\GitHub\scene-matching-aided-navigation\result\'; %�����ļ���Ŀ¼��
    filename=strcat(dir,title,Time,mat); %���ɱ����ļ���·�����ļ���
  % dlmwrite(filename,XYR(:,:),'delimiter','\t','newline','pc');%���浽XYR.txt�ļ�:) 
    save( filename,'Corner_box');     
%end     

