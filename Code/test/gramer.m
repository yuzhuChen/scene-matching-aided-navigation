%%gramer 
%Hot map
mMapSaliencePure=double(mMapSaliencePure);
image_Origin=double(image_Origin);
cmap2=colormap(jet(256));
rgb2=ind2rgb(mMapSaliencePure,cmap2);
rgb2 = rgb2 * 255;
imwrite(uint8(image_Origin*0.6+rgb2*0.4),'223_5_72km_fieldXiangguangtezheng061701.jpg');
%%���������ĺ���
c = normxcorr2(onion,peppers);
figure, surf(c), shading flat
%%�ļ���ʱ���
    mat='.mat'; %���ɵļ������ļ���׺
    T=num2str(clock); %clock��¼��ǰ����ʱ�䣬ת�����ַ�����ʽ
    T(find(isspace(T))) =[]; %ȥ��T�еĿո� 
    Tl=length(T); %����T�ĳ���
    Time=T(1:(Tl-6)); %ȥ��T�ж�������֣��õ����ں�ʱ��Ľ�����ʽ
    title ='corner';
    dir='D:\Users\Daisy\Documents\GitHub\scene-matching-aided-navigation\result\'; %�����ļ���Ŀ¼��
    filename=strcat(dir,title,Time,mat); %���ɱ����ļ���·�����ļ���
  % dlmwrite(filename,XYR(:,:),'delimiter','\t','newline','pc');%���浽XYR.txt�ļ�:) 
    save( filename,'corner');    