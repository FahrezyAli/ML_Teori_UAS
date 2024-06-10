function y2=ScatterHull(Data,ang_2)

y1=unique(Data,'rows');
% sort of scatters
cen=mean(y1);
ang=atan2(y1(:,1)-cen(1),y1(:,2)-cen(2)); 
y1=[y1,ang];
y1=sortrows(y1,3);
y1=y1(:,1:2);

y2=y1;
im=1;
[n , ~]=size(y1);

while ~isempty(im)

im=[];

for i=1:n
      if i==1 
            v1=y1(n,:)-y1(1,:);
            v2=y1(2,:)-y1(1,:); 
      elseif i==n 
            v1=y1(n-1,:)-y1(n,:); 
            v2=y1(1,:)-y1(n,:); 
      else 
	      v1=y1(i-1,:)-y1(i,:);
            v2=y1(i+1,:)-y1(i,:);
      end
      r=det([v1;v2]); 
	c=dot(v1,v2)/(norm(v1)*norm(v2));
      ang=rad2deg(acos(c));
	
      if r<=0&&(ang<ang_2||isnan(ang))%concave
            ang(ang<ang_2);
            im=[im;i]; %#ok<*AGROW>
      end
end
y2(im,:)=[];
y1=y2;
[n , ~]=size(y1);
end

y2=[y2;y2(1,:)];%result's curve is closed
end
