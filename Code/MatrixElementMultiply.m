function img=MatrixElementMultiply(img1,img2)

[m,n]=size(img1);
img=zeros(m,n);
img1=double(img1);
img2=double(img2);
img_p=img1.*img2;
img_p_sort=sort(img_p(:));
max=img_p_sort(length(img_p_sort));
for i=1:size(img_p,1)
    for j=1:size(img_p,2)
        img_p(i,j)=img_p(i,j)/max;
    end
end
img=uint8(img*255);