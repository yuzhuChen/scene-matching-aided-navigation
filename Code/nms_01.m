%Corner角点
%Scores得分
%重叠区域的阈值
%可用的非极大值抑制法
function  keep=nms(Corner,Scores,threholds)
        %Corner=[]  
        Xmin=Corner(:,1);
        Xmax=Corner(:,2);
        Ymin=Corner(:,3);
        Ymax=Corner(:,4);
        Area=(Xmax-Xmin+1).*(Ymax-Ymin+1);
        %得分按从小到大排序，并获得序数I和对应的值v_s；
        [v_s I]=sort(Scores);
        keep=[];
        while ~isempty(I)
            last=length(I);
            %保留I目前最右值
            keep=[keep;I(last)]; 
            %取出I中的最右值
            i_f=I(last);
            %将I中元素序号last存入抑制矩阵
            suppression=[last];
            for pos=1:last-1  
                j_f=I(pos);
                xx_max=min(Xmax(j_f),Xmax(i_f));
                xx_min=max(Xmin(j_f),Xmin(i_f));
                yy_max=min(Ymax(j_f),Ymax(i_f));
                yy_min=max(Ymin(j_f),Ymin(i_f));
              
                w_f=xx_max-xx_min+1;
                h_f=yy_max-yy_min+1;
                covered=0;
                if w_f>0&&h_f>0
                covered=(w_f*h_f)/min(Area(j_f),Area(i_f));
                end
                if covered >threholds
                suppression=[suppression; pos];    
                end
            end
            I(suppression)=[];
                
        end
        
   end