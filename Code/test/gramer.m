%%gramer 
%Hot map
mMapSaliencePure=double(mMapSaliencePure);
image_Origin=double(image_Origin);
cmap2=colormap(jet(256));
rgb2=ind2rgb(mMapSaliencePure,cmap2);
rgb2 = rgb2 * 255;
imwrite(uint8(image_Origin*0.6+rgb2*0.4),'223_5_72km_fieldXiangguangtezheng061701.jpg');
%%相关特征面的函数
c = normxcorr2(onion,peppers);
figure, surf(c), shading flat
%%文件名时间戳
    mat='.mat'; %生成的计算结果文件后缀
    T=num2str(clock); %clock记录当前日期时间，转换成字符串形式
    T(find(isspace(T))) =[]; %去除T中的空格 
    Tl=length(T); %计算T的长度
    Time=T(1:(Tl-6)); %去除T中多余的数字，得到日期和时间的紧凑形式
    title ='corner';
    dir='D:\Users\Daisy\Documents\GitHub\scene-matching-aided-navigation\result\'; %保持文件的目录名
    filename=strcat(dir,title,Time,mat); %生成保存文件的路径和文件名
  % dlmwrite(filename,XYR(:,:),'delimiter','\t','newline','pc');%保存到XYR.txt文件:) 
    save( filename,'corner');    