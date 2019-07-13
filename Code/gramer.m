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