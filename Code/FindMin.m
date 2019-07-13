% saliencePureÈ¥³ý±ßÔµºóµÄ´¿¾ØÕó
%
saliencePure=salience(20:223,20:223);
numberMinSalience=min(min(saliencePure));
[rowMin,colMin]=find(numberMinSalience);
mMapSaliencePure =zeros(size(saliencePure));
for iRowMin=1:length(rowMin)
        mMapSaliencePure(rowMin(iRowMin),colMin(iRowMin))=255;
end

 mMapSaliencePure=[zeros(20,203); mMapSaliencePure];
 mMapSaliencePure=[zeros(20,223); mMapSaliencePure']';
 
%Hot map
mMapSaliencePure=double(mMapSaliencePure);
cmap2=colormap(jet(256));
rgb2=ind2rgb(mMapSaliencePure,cmap2);
rgb2 = rgb2 * 255;
imwrite(uint8(image_Origin*0.6+rgb2*0.4),'223_5_72km_fieldXiangguangtezheng061701.jpg');

