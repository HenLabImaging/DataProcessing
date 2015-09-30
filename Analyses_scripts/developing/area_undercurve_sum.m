

redcells=find(sum(cell_events)<2);
Active_cells_kernel=conv_kernel_trans;
Active_cells_kernel(:,redcells)=[];


% Active_cells=find(sum(abs(conv_kernel_trans))>0);

% Active_cells_kernel=conv_kernel_trans(:,Active_cells);
Active_cells_kernel_Area_UCurve=[];
Meanstd_Area_UCurve=[];temp2=[];
for ii=1:min(size(Active_cells_kernel))
    temp_kernel=abs(Active_cells_kernel(:,ii));
temp_kernel(find(temp_kernel<1e-4))=0;

temp=find(temp_kernel>0);
temp2=diff(temp);
count2=[];count=0;indx1=[];indx2=[];
for i=1:length(temp2)
   
    if(temp2(i)<5)
        count=count+1;
    else
       
        count2=[count2 count];
         count=0;
           indx2=[indx2 temp(i)];
           indx1=[indx1 (indx2(end)-count2(end))];
    end
%     pause(0.1);

end
  if(temp2(end)<5)
      count2=[count2 count];
      indx2=[indx2 temp(end)];
      indx1=[indx1 (indx2(end)-count2(end))];
  end
  X1_2=[indx1;indx2];
  len=count2;

  if(length(len)>1)
  for k=1:length(X1_2)
    AreaCurve(k,1)=sum(temp_kernel(X1_2(1,k):X1_2(2,k)));
   AreaCurve(k,2)=len(k)/Fs_Im;
  end
  else
      AreaCurve(1)=sum(temp_kernel(X1_2(1):X1_2(2)));
      AreaCurve(2)=len;
  end
    AreaCurve(AreaCurve(:,2)<5,:)=[];
%   AreaCurve
%   pause(1)

    Area_wrt_len=AreaCurve(:,1)./AreaCurve(:,2);
    Meanstd_Area_UCurve(ii,:)=[mean(Area_wrt_len) std(Area_wrt_len)]; 
end
figure;bar(Meanstd_Area_UCurve(:,1));hold on;bar(Meanstd_Area_UCurve(:,2),'r')
figure(2);hold on;errorbar(10,median(Meanstd_Area_UCurve(:,1)),median(Meanstd_Area_UCurve(:,2)));bar(10,median(Meanstd_Area_UCurve(:,1)),0.4)


%%


k=0;temp=0;
for i=1:3000
if(temp_kernel(i)~=0)
k=k+1;
temp=temp_kernel(i)+temp;
temp2=k;
else
k=0;
mag(i)=temp;
len(i)=temp2;
temp=0;temp2=0;
end
end
magg(ii,:)=mag;
lenn(ii,:)=len;

end

asas=[];
for ii=1:612
as=[];
for i=1:2999
as(i)=cos_sim([conv_kernel_trans(i,285) conv_kernel_trans(i,ii) ],[conv_kernel_trans(i+1,285) conv_kernel_trans(i+1,ii)]);
% pause(1)
end
asas(ii)=mean(as);
end

figure(1);
%%
for jk=1:length(opencells)
    
for kk=1:length(closecells)
%  clf;
figure;

open=[];close=[];
for i=1:min(size(close2open_5cross_mouse3))

open(:,i)=[mean(abs(close2open_5cross_mouse3(285,51:100,i))); mean(abs(close2open_5cross_mouse3(432,51:100,i)))];
close(:,i)=[mean(abs(close2open_5cross_mouse3(285,1:50,i))); mean(abs(close2open_5cross_mouse3(432,1:50,i)))];

end
subplot(122)
compass(open(2,:),close(2,:),'r')
hold on; compass(open(1,:),close(1,:),'b')
% end
pause(1)
% end

aa=[];
for jj=1:length(open)
    a=[];
 for j=1:length(open)
a(j)=cos_sim(open(:,jj)',open(:,j)')
 end
 aa(jj)=(sum(a)-1)/(length(a)-1);
end

Cos_rates(kk,1)=mean(aa);
aa=[];
for jj=1:length(close)
    a=[];
 for j=1:length(close)
a(j)=cos_sim(close(:,jj)',close(:,j)');
 end
 aa(jj)=(sum(a)-1)/(length(a)-1);
end
Cos_rates(kk,2)=mean(aa);

aa=[];
for jj=1:length(close)
    a=[];
 for j=1:length(close)
a(j)=cos_sim(close(:,jj)',open(:,j)');
 end
 aa(jj)=mean(a);
end

Cos_rates(kk,3)=mean(aa);
% 
% 
% 
% 
% 

% 
% 
% 
% 
% 
% sim_close(kk)=cos_sim(close(2,:),close(1,:));
% sim_open(kk)=cos_sim(open(2,:),open(1,:));
% sim_open_close(kk)=cos_sim(open(2,:),close(1,:));
% 
% pause(.1)
end
end