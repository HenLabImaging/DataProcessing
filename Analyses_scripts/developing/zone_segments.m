OPEN_zones=zeros(1,3000);

OPEN_zones=zeros(1,3000);
CLOSE_zones=zeros(1,3000);
CENTER_zones=zeros(1,3000);
all_zones=zeros(1,3000);
OPEN_zones(find(zoneXXYY==2))=1;
% OPEN_zones(find(zoneXXYY==12))=1;
CLOSE_zones(find(zoneXXYY==1))=1;
% CLOSE_zones(find(zoneXXYY==2))=1;
CENTER_zones(CenterPoints)=1;

% 
% clear OPEN_zones
% OPEN_zones=CLOSE_zones;


 des_data_norm=[];
des_data_norm=norm_transients;
% des_data_norm=[];
% % des_data=o2o_first5_7mice_trimmed;
% for i=1:min(size(des_data))
% %     des_data_norm(:,i)=des_data(:,i)-min(des_data(:,i));
% %     des_data_norm(:,i)=des_data_norm(:,i)./max(des_data_norm(:,i));
% end
% des_data_norm=des_data_norm/max(max(des_data_norm));
% figure;imagesc(des_data_norm');

ZONES=([OPEN_zones ;CLOSE_zones ;CENTER_zones])
clc
figure;area(ZONES')

close_arm_transient=zeros(1,3000);
open_arm_transient=zeros(1,3000);
center_arm_transient=zeros(1,3000);

% OPEN_zones=CLOSE_zones;


close_arm_transient(find(CLOSE_zones>0))=1;
open_arm_transient(find(OPEN_zones>0))=1;
%%
open_temp=find(OPEN_zones>0);
diff_open=diff(find(OPEN_zones>0));
matched_open_temp=[open_temp(2:end); diff_open]';
%  open_temp_trans=zeros(3000,1);
% figure;

ll=find((matched_open_temp(:,2))>10)
k=1;ii=1;
aa=zeros(1000,10);
if(matched_open_temp(ll(1))<50)
    ll(1)=[];
end
    

for i=1:length(matched_open_temp)
%     for k=1:50
if(matched_open_temp(i,2)<10)
ii=ii+1;
%         subplot(10,1,k);hold on;plot(i,mean(norm_transients(matched_open_temp(i,1),:)'),'r.','markersize',20);
aa(ii+500,k)=mean(des_data_norm(matched_open_temp(i,1),:)');

% aa(500-ii,k)=mean(norm_transients(matched_open_temp(i,1)-2*ii,:));
else
   aa(451:500,k)=mean(norm_transients(matched_open_temp(ll(k))-49:matched_open_temp(ll(k)),:)');
   if(k==length(ll))
       k=k;
   else
% subplot(10,1,k);hold on;plot(i-10:i,mean(norm_transients(matched_open_temp(i,1)-10:matched_open_temp(i,1),:)'),'b.','markersize',20);
        k=k+1;
   end
i=1;
ii=1;
%     pause(.1);
end
end




% 
% temp=matched_open_temp(find(diff_open>10),1);
% % temp=[matched_open_temp(1);temp];
% 
% for i=1:min(size(aa))-3
%    
%     aa(451:500,i)= mean(des_data_norm(temp(i)-49:temp(i),:)');
% end
%  
aa2=aa-min(min(aa));


figure;imagesc(aa2');shading flat;colormap jet(20)
hold on;plot([500 500],[0.5 122],'w--','LineWidth',4);axis([450 600 0.5 122])
set(gcf,'Color','w');set(gca,'FontSize',16);colorbar
xlabel('-10 sec / +Entire Open Arm visit Window')
%%


figure;set(gcf,'Color','w')
for i=1:min(size(aa))
subplot(min(size(aa)),1,i);plot(aa(:,i));box off
end


title(['#Crosses = ',num2str(i)],'FontSize',10)
for i=1:min(size(aa))
bb(i,1)=[sum(aa(1:500,i))-sum(aa(501:1000,i))]
bb(i,2)=length(find(aa(:,i)~=0))/2
end
% figure;
figure;set(gcf,'Color',[1 1 1]);set(gca,'FontSize',20)
subplot(1,3,1:2);scatter(bb(:,2)/5,bb(:,1),'LineWidth',2)

for i=1:min(size(aa))
bb(i,1)=sum(aa(:,i));
bb(i,2)=length(find(aa(:,i)~=0))
end
subplot(133);bar(bb(:,1));box off