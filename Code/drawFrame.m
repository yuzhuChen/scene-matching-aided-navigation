function drawFrame(imgIn,corner)
 imshow(imgIn,'Border','tight');
 hold on;
 for i=1:size(corner,1)
      x=corner(i,:);
     rectx = [x(1) x(2) x(2) x(1) x(1)];
     recty = [x(3) x(3) x(4) x(4) x(3)];
     plot(rectx, recty, 'linewidth',2);%×ø±êÊÇÒÀ¾İÏñËØÂğ£¿
 end
  hold off.
  