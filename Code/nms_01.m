%Corner�ǵ�
%Scores�÷�
%�ص��������ֵ
%���õķǼ���ֵ���Ʒ�
function  keep=nms(Corner,Scores,threholds)
        %Corner=[]  
        Xmin=Corner(:,1);
        Xmax=Corner(:,2);
        Ymin=Corner(:,3);
        Ymax=Corner(:,4);
        Area=(Xmax-Xmin+1).*(Ymax-Ymin+1);
        %�÷ְ���С�������򣬲��������I�Ͷ�Ӧ��ֵv_s��
        [v_s I]=sort(Scores);
        keep=[];
        while ~isempty(I)
            last=length(I);
            %����IĿǰ����ֵ
            keep=[keep;I(last)]; 
            %ȡ��I�е�����ֵ
            i_f=I(last);
            %��I��Ԫ�����last�������ƾ���
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