matched_open_temp=[zoneXXYY2(2:end) diffzoneXXYY2];
% Aligned_transients=aa;

 des_data_norm=[];
des_data=Aligned_transients;
% des_data_norm=[];
% des_data=o2o_first5_7mice_trimmed;
for i=1:min(size(des_data))
    des_data_norm(:,i)=des_data(:,i)-min(des_data(:,i));
    des_data_norm(:,i)=des_data_norm(:,i)./max(des_data_norm(:,i));
end

% figure;imagesc(des_data_norm');

ll=find(matched_open_temp(:,2)~=0);%diffzoneXXYY2
x2x=zeros(800,10);
% y2y=zeros(1000,10);
% x2y=zeros(1000,10);
% y2x=zeros(1000,10);

% Aligned_transients=des_data_norm;

ll(1)=[];

xx=[];yy=[];xy=[];yx=[];
for i=1:length(ll)-1
    if(diffzoneXXYY2(ll(i))==1)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
        
        xx=[xx i];
    elseif(diffzoneXXYY2(ll(i))==-1)
       x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');
       x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
       xx=[xx i];
    elseif(diffzoneXXYY2(ll(i))==4)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
        yy=[yy i];
    elseif(diffzoneXXYY2(ll(i))==-4)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
        yy=[yy i];
    elseif(diffzoneXXYY2(ll(i))==6)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
        yx=[yx i];
    elseif(diffzoneXXYY2(ll(i))==7)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');  
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
         yx=[yx i];
    elseif(diffzoneXXYY2(ll(i))==10)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');      
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
         yx=[yx i];
    elseif(diffzoneXXYY2(ll(i))==11)
       x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)'); 
       x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
        yx=[yx i];
     elseif(diffzoneXXYY2(ll(i))==-6)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
        xy=[xy i];
    elseif(diffzoneXXYY2(ll(i))==-7)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)');   
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
        xy=[xy i];
    elseif(diffzoneXXYY2(ll(i))==-10)
        x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)'); 
        x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
        xy=[xy i];
    elseif(diffzoneXXYY2(ll(i))==-11)
       x2x(501:500+(ll(i+1)-ll(i)+1),i)=mean(Aligned_transients(ll(i):ll(i+1),:)'); 
       x2x(451:500,i)=mean(Aligned_transients(ll(i)-49:ll(i),:)');
       xy=[xy i];
             
    end
end

%%BUG REPORT: X Y directional calculation reversed!! FIND THE REASON!!!!
%%


x2x_norm=[];
for i=1:min(size(x2x))
    temp=find(x2x(:,i)==0);
    x2x_norm(:,i)=x2x(:,i)-min(x2x(:,i));
    x2x_norm(:,i)=x2x_norm(:,i)./max(x2x_norm(:,i));
    x2x_norm(temp,i)=0;
end

% figure;imagesc(x2x_norm')

figure;subplot(121);imagesc((x2x_norm'));axis([450 800 0.5 length(ll)-1]);axis xy
xlabel('Time (samples) -10sec/+Entire Occupancy in the context)','FontSize',16)
ylabel('All directional crosses in order')
set(gcf,'Color','w')
set(gca,'FontSize',16)
hold on;plot([550 550],[0.5 length(ll)],'w:','LineWidth',1)
hold on;plot([600 600],[0.5 length(ll)],'w:','LineWidth',1)
hold on;plot([650 650],[0.5 length(ll)],'w:','LineWidth',1)
hold on;plot([500 500],[0.5 length(ll)],'r:','LineWidth',2)

for i=1:length(xx)
    hold on;plot([499 500],[xx(i) xx(i)],'k^','MarkerSize',8)
end
for i=1:length(yy)
    hold on;plot([499 500],[yy(i) yy(i)],'g^','MarkerSize',8)
end
for i=1:length(yx)
    hold on;plot([499 500],[yx(i) yx(i)],'r>','MarkerSize',8)
end
for i=1:length(xy)
    hold on;plot([499 500],[xy(i) xy(i)],'r<','MarkerSize',8)
end
% title('Black (?): Open to Close; Green (?):Open to Open; Red(<)=Open to Close ;Red(>)=Close to Open')
tit=sprintf('Black (?): Open to Close; %s\nRed(<)=Open to Close ;Red(>)=Close to Open',' Green (?):Open to Open')
title(tit)
caxis([0 1]);
colorbar;
subplot(122);hold on;
barh([xx],ll(xx)/5/60,0.2,'k')
barh([yy],ll(yy)/5/60,0.2,'g')
barh([yx],ll(yx)/5/60,0.2,'r')
barh([xy],ll(xy)/5/60,0.2,'r');axis tight
xlabel('Real time Point of matching behavior (min)','FontSize',20)

