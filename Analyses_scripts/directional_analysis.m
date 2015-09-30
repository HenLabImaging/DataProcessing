
% trans_ind_clockw=trans_ind_epm1;
% % 
% trans_ind_c_clockw=trans_ind_epm2;

newtrans_ind_c_clockw=trans_ind_c_clockw(find(diff(trans_ind_c_clockw)>5))
newtrans_ind_clockw=trans_ind_clockw(find(diff(trans_ind_clockw)>5))
xxyy_down=downsample(xxyy,Sampling_factor);
norm_transients=zscore_transients;

hold on;plot(xxyy_down(newtrans_ind_clockw,1),xxyy_down(newtrans_ind_clockw,2),'r.')
hold on;plot(xxyy_down(newtrans_ind_c_clockw,1),xxyy_down(newtrans_ind_c_clockw,2),'k.')

xydist1_down=downsample(xydist1,Sampling_factor);
new_trans_ind_cw2=find(xydist1_down(newtrans_ind_clockw)<dist_entered/2)
new_trans_ind_ccw2=find(xydist1_down(newtrans_ind_c_clockw)>dist_entered/2)


    TimeW=10;
    TimeWindow=TimeW*Fs_Im;
    discard_ind1=find(newtrans_ind_c_clockw(new_trans_ind_ccw2)<TimeWindow);
    new_trans_ind_ccw2(discard_ind1)=[];
    discard_ind2=find(newtrans_ind_c_clockw(new_trans_ind_ccw2)>(length(norm_transients)-TimeWindow));
    new_trans_ind_ccw2(discard_ind2)=[];
    
      discard_ind3=find((newtrans_ind_clockw(new_trans_ind_cw2))<TimeWindow);
      new_trans_ind_cw2(discard_ind3)=[];
    discard_ind4=find((newtrans_ind_clockw(new_trans_ind_cw2))>(length(norm_transients)-TimeWindow));
    new_trans_ind_cw2(discard_ind4)=[];
    

    dismiss1=[];
    for i=1:length(new_trans_ind_cw2)
figure(10);clf;plot(xxyy(:,1),xxyy(:,2));
hold on;plot(xxyy_down(newtrans_ind_clockw(new_trans_ind_cw2(i))-TimeW:newtrans_ind_clockw(new_trans_ind_cw2(i)),1),xxyy_down(newtrans_ind_clockw(new_trans_ind_cw2(i))-TimeW:newtrans_ind_clockw(new_trans_ind_cw2(i)),2),'kx')
plot(xxyy_down(newtrans_ind_clockw(new_trans_ind_cw2(i)):newtrans_ind_clockw(new_trans_ind_cw2(i))+TimeW,1),xxyy_down(newtrans_ind_clockw(new_trans_ind_cw2(i)):newtrans_ind_clockw(new_trans_ind_cw2(i))+TimeW,2),'rx')
 dlgTitle    = 'ZeroMaze Cell Selection';
 dlgQuestion = 'Do you wish to Save?';
 choice='Yes';
 choice = questdlg(dlgQuestion,dlgTitle,'Yes','Naa', 'Yes');
 if(choice=='Naa')
     dismiss1=[dismiss1 i];
 end
    end
    new_trans_ind_cw2(dismiss1)=[];
    
    dismiss2=[];
    for i=1:length(new_trans_ind_ccw2)
figure(11);clf;plot(xxyy(:,1),xxyy(:,2));
hold on;plot(xxyy_down(newtrans_ind_c_clockw(new_trans_ind_ccw2(i))-TimeW:newtrans_ind_c_clockw(new_trans_ind_ccw2(i)),1),xxyy_down(newtrans_ind_c_clockw(new_trans_ind_ccw2(i))-TimeW:newtrans_ind_c_clockw(new_trans_ind_ccw2(i)),2),'kx')
plot(xxyy_down(newtrans_ind_c_clockw(new_trans_ind_ccw2(i)):newtrans_ind_c_clockw(new_trans_ind_ccw2(i))+TimeW,1),xxyy_down(newtrans_ind_c_clockw(new_trans_ind_ccw2(i)):newtrans_ind_c_clockw(new_trans_ind_ccw2(i))+TimeW,2),'rx')
 newtrans_ind_c_clockw2=newtrans_ind_c_clockw(new_trans_ind_ccw2(i)) 
dlgQuestion = 'Do you wish to Save?';
 choice='Yes';
 choice = questdlg(dlgQuestion,dlgTitle,'Yes','Naa', 'Yes');
 if(choice=='Naa')
     dismiss2=[dismiss2 i];
 end
    end
 
       new_trans_ind_ccw2(dismiss2)=[];

       
       newtrans_ind_clockw2= newtrans_ind_clockw(new_trans_ind_cw2)
              newtrans_ind_c_clockw2=newtrans_ind_c_clockw(new_trans_ind_ccw2)
%     hold on;plot(xxyy_down(newtrans_ind_c_clockw(new_trans_ind_ccw2),1),xxyy_down(newtrans_ind_c_clockw(new_trans_ind_ccw2),2),'y.')
% hold on;plot(xxyy_down(newtrans_ind_clockw(new_trans_ind_cw2),1),xxyy_down(newtrans_ind_clockw(new_trans_ind_cw2),2),'y.')
%%

              
%               newtrans_ind_clockw2=newtrans_ind_c_clockw2;

    timeind_samples=str2double(char(inputdlg(['Observed #Passes: ' num2str(length(newtrans_ind_clockw2)) '  ' 'Include# ?'])));
newtrans_ind_clockw2=newtrans_ind_clockw2(1:timeind_samples);
    
    meanTimeTransients=zeros(length(newtrans_ind_clockw2),2*TimeWindow);
meanTimeTransients2=zeros(min(size(cells_transients)),2*TimeWindow);
    figure;
    for iii=1:length(newtrans_ind_clockw2)
    imagesc(norm_transients(newtrans_ind_clockw2(iii)-TimeWindow+1:newtrans_ind_clockw2(iii)+TimeWindow,:)');colormap jet;colorbar;
    
     time_Transients=norm_transients(newtrans_ind_clockw2(iii)-TimeWindow+1:newtrans_ind_clockw2(iii)+TimeWindow,:);
   meanTimeTransients(iii,:)=mean(time_Transients');

       temp=norm_transients(newtrans_ind_clockw2(iii)-TimeWindow+1:newtrans_ind_clockw2(iii)+TimeWindow,:)';
   meanTimeTransients2=(meanTimeTransients2+temp);
   
    pause(0.1);
    end

         figure;set(gcf,'Color','w');subplot(231);imagesc(meanTimeTransients);colorbar;shading flat
        hold on;stem(TimeWindow+0.5,length(newtrans_ind_clockw2)+1,'w:','LineWidth',5);
        xlabel(['TimeWindow'  '  -/+' num2str(TimeWindow/Fs_Im) ' sec'],'Fontsize',14);ylabel('#Passes','Fontsize',14);title('All cells averaged','Fontsize',14)
        subplot(232);pcolor(meanTimeTransients2);colorbar;shading flat;colormap jet; xlabel(['TimeWindow'  '  -/+' num2str(TimeWindow/Fs_Im) ' sec'],'Fontsize',14);title('Individual Cells','Fontsize',14)
        ylabel('#Cells','Fontsize',14);
          hold on;stem(TimeWindow+0.5,min(size(cells_transients))+1,'w:','LineWidth',5);
           koeff=min(size((cells_transients)))/max(mean(meanTimeTransients2));
           plot(mean(meanTimeTransients2)*koeff,'k--','LineWidth',1)
           
           y=meanTimeTransients2';
% figure;plot(y)
for i=1:min(size(cells_transients))
ymax(i)=(find(y(:,i)==max(y(:,i))));
end           
           
           aa=zeros(min(size(cells_transients)),TimeWindow*2);
k=0;
for ii=1:(Fs_Im*TimeWindow*2)
temp=find(ymax==ii);
for i=1:length(temp)
    aa(k+i,:)=meanTimeTransients2(temp(i),:);
end
if(i>0)
k=k+i;
end
end
    subplot(233);pcolor(aa);shading flat;colormap jet;
       hold on;stem(TimeWindow+0.5,min(size(cells_transients))+1,'w:','LineWidth',5);title('Ranked Map','Fontsize',14);   
           plot(1:min(size(aa)),linspace(1,length(meanTimeTransients2),min(size(aa))),'k--')
        
       mean2TimeTransients2=mean(meanTimeTransients2);
           Wn=1/4;
[b,a]=butter(2,Wn);
y=filtfilt(b,a,mean(meanTimeTransients2));
            tt=linspace(0,2*TimeW,length(y));
           subplot(2,3,4:6);plot(tt,y,'b');hold on;line([TimeW TimeW],[min(y) max(y)]);xlabel('seconds','FontSize',16);box off
           [mean(mean2TimeTransients2(1:length(y)/2))/mean(mean2TimeTransients2(length(y)/2+1:length(y)))]
           
           
           %%
    
% figure;plot(xxyy(:,1),xxyy(:,2));
% hold on
% for i=1:length(newtrans_ind_clockw)
%     plot(xxyy_down(newtrans_ind_clockw(i),1),xxyy_down(newtrans_ind_clockw(i),2),'kx','LineWidth',2)
%     gg=input('true?')
%     if(gg==1)
%         newtrans_ind_clockw_close2open(i)=newtrans_ind_clockw(i)
%     end
%      plot(xxyy_down(newtrans_ind_clockw(i),1),xxyy_down(newtrans_ind_clockw(i),2),'bx','LineWidth',2)
% end
% 
% 
% for i=1:length(newtrans_ind_c_clockw)
%     plot(xxyy_down(newtrans_ind_c_clockw(i),1),xxyy_down(newtrans_ind_c_clockw(i),2),'kx','LineWidth',2)
%     gg=input('true?')
%     if(gg==1)
%         newtrans_ind_c_clockw_open2close(i)=newtrans_ind_c_clockw(i)
%     end
%      plot(xxyy_down(newtrans_ind_c_clockw(i),1),xxyy_down(newtrans_ind_c_clockw(i),2),'bx','LineWidth',2)
% end

% newtrans_ind_clockw=newtrans_ind_clockw_close2open(find(newtrans_ind_clockw_close2open>0))
% newtrans_ind_c_clockw=newtrans_ind_c_clockw_open2close(find(newtrans_ind_c_clockw_open2close>0))
%%

newtrans_ind_c_clockw=trans_ind_c_clockw(find(diff(trans_ind_c_clockw)>1))
newtrans_ind_clockw=trans_ind_clockw(find(diff(trans_ind_clockw)>1))
xxyy_down=downsample(xxyy,Sampling_factor);

l1=length(newtrans_ind_clockw)
l2=length(newtrans_ind_c_clockw)

if(l1<l2)
    ref_trans_ind=newtrans_ind_clockw;
     ref_trans_ind2=newtrans_ind_c_clockw;
else
    ref_trans_ind=newtrans_ind_c_clockw;
         ref_trans_ind2=newtrans_ind_clockw;
end
crossing_ind=[]
for i=1:length(ref_trans_ind)
    
    crossings_diff=ref_trans_ind(i)-ref_trans_ind2;
    abs_crossing_ind=abs(crossings_diff);
    temp=min(find(abs_crossing_ind==min(abs_crossing_ind)));
    crossing_ind(i)=crossings_diff(temp)
% pause;
end
    l3=length(ref_trans_ind);
    if(l3==l1)
        cw_direction=find(crossing_ind<0);
        ccw_direction=find(crossing_ind>0)  ; 
    else
        ccw_direction=find(crossing_ind<0);
        cw_direction=find(crossing_ind>0) ;
    end
    
        hold on;plot(xxyy_down(newtrans_ind_c_clockw(ccw_direction),1),xxyy_down(newtrans_ind_c_clockw(ccw_direction),2),'k.')
hold on;plot(xxyy_down(newtrans_ind_clockw(cw_direction),1),xxyy_down(newtrans_ind_clockw(cw_direction),2),'k.')
    
    %%
    TimeW=10;
    TimeWindow=TimeW*Fs_Im;
    discard_ind1=find((newtrans_ind_c_clockw(ccw_direction))<TimeWindow);
    discard_ind2=find((newtrans_ind_c_clockw(ccw_direction))>(length(norm_transients)-TimeWindow));
    ccw_direction(discard_ind1)=[];
    ccw_direction(discard_ind2)=[];
      discard_ind3=find((newtrans_ind_clockw(cw_direction))<TimeWindow);
    discard_ind4=find((newtrans_ind_clockw(cw_direction))>(length(norm_transients)-TimeWindow));
    cw_direction(discard_ind3)=[];
    cw_direction(discard_ind4)=[];
    
   
    
    timeind_samples=str2double(char(inputdlg(['Observed #Passes: ' num2str(length(cw_direction)) '  ' 'Include# ?'])));
cw_direction=cw_direction(1:timeind_samples);
    
    meanTimeTransients=zeros(length(cw_direction),2*TimeWindow);
meanTimeTransients2=zeros(min(size(cells_transients)),2*TimeWindow);
    figure;
    for iii=1:length(cw_direction)
    imagesc(norm_transients(newtrans_ind_clockw(cw_direction(iii))-TimeWindow+1:newtrans_ind_clockw(cw_direction(iii))+TimeWindow,:)');caxis([0 1]);colormap jet;colorbar;
    
     time_Transients=norm_transients(newtrans_ind_clockw(cw_direction(iii))-TimeWindow+1:newtrans_ind_clockw(cw_direction(iii))+TimeWindow,:);
   meanTimeTransients(iii,:)=mean(time_Transients');

       temp=norm_transients(newtrans_ind_clockw(cw_direction(iii))-TimeWindow+1:newtrans_ind_clockw(cw_direction(iii))+TimeWindow,:)';
   meanTimeTransients2=(meanTimeTransients2+temp);
   
%     pause(0.1);
    end
    
    
       figure;set(gcf,'Color','w');subplot(231);imagesc(meanTimeTransients);colorbar;shading flat
        hold on;stem(TimeWindow+0.5,length(cw_direction)+1,'w:','LineWidth',5);
        xlabel(['TimeWindow'  '  -/+' num2str(TimeWindow/Fs_Im) ' sec'],'Fontsize',14);ylabel('#Passes','Fontsize',14);title('All cells averaged','Fontsize',14)
        subplot(232);pcolor(meanTimeTransients2);colorbar;shading flat;colormap jet; xlabel(['TimeWindow'  '  -/+' num2str(TimeWindow/Fs_Im) ' sec'],'Fontsize',14);title('Individual Cells','Fontsize',14)
        ylabel('#Cells','Fontsize',14);
          hold on;stem(TimeWindow+0.5,min(size(cells_transients))+1,'w:','LineWidth',5);
           koeff=min(size((cells_transients)))/max(mean(meanTimeTransients2));
           plot(mean(meanTimeTransients2)*koeff,'k--','LineWidth',1)
           
           
%         Wn=1/5;
% [b,a]=butter(2,Wn);
% y=filtfilt(b,a,meanTimeTransients2);
% y=y';
y=meanTimeTransients2';
% figure;plot(y)
for i=1:min(size(cells_transients))
ymax(i)=(find(y(:,i)==max(y(:,i))));
end           
           
           aa=zeros(min(size(cells_transients)),TimeWindow*2);
k=0;
for ii=1:(Fs_Im*TimeWindow*2)
temp=find(ymax==ii);
for i=1:length(temp)
    aa(k+i,:)=meanTimeTransients2(temp(i),:);
end
if(i>0)
k=k+i;
end
end
    subplot(233);pcolor(aa);shading flat;colormap jet;
       hold on;stem(TimeWindow+0.5,min(size(cells_transients))+1,'w:','LineWidth',5);title('Ranked Map','Fontsize',14);   
           plot(1:min(size(aa)),linspace(1,length(meanTimeTransients2),min(size(aa))),'k--')
        
       mean2TimeTransients2=mean(meanTimeTransients2);
           Wn=1/5;
[b,a]=butter(2,Wn);
y=filtfilt(b,a,mean(meanTimeTransients2));
            tt=linspace(0,2*TimeW,length(y));
           subplot(2,3,4:6);plot(tt,y,'b');hold on;line([TimeW TimeW],[min(y) max(y)]);xlabel('seconds','FontSize',16);box off
           [mean(mean2TimeTransients2(1:length(y)/2))/mean(mean2TimeTransients2(length(y)/2+1:length(y)))]
           
     %%
              figure;
      meanTimeTransients=zeros(length(ccw_direction),2*TimeWindow);
meanTimeTransients2=zeros(min(size(cells_transients)),2*TimeWindow);  

timeind_samples=str2double(char(inputdlg(['Observed #Passes: ' num2str(length(ccw_direction)) '  ' 'Include# ?'])));
ccw_direction=ccw_direction(1:timeind_samples);

              
    for iii=1:length(ccw_direction)
    imagesc(norm_transients(newtrans_ind_c_clockw(ccw_direction(iii))-TimeWindow+1:newtrans_ind_c_clockw(ccw_direction(iii))+TimeWindow,:)');caxis([0 1]);colormap jet;colorbar;
    
     time_Transients=norm_transients(newtrans_ind_c_clockw(ccw_direction(iii))-TimeWindow+1:newtrans_ind_c_clockw(ccw_direction(iii))+TimeWindow,:);
   meanTimeTransients(iii,:)=mean(time_Transients');

       temp=norm_transients(newtrans_ind_c_clockw(ccw_direction(iii))-TimeWindow+1:newtrans_ind_c_clockw(ccw_direction(iii))+TimeWindow,:)';
   meanTimeTransients2=(meanTimeTransients2+temp);
   
%     pause(0.1);
    end
    
    
       figure;set(gcf,'Color','w');subplot(231);imagesc(meanTimeTransients);colorbar;shading flat
        hold on;stem(TimeWindow+0.5,length(cw_direction)+1,'w:','LineWidth',5);
        xlabel(['TimeWindow'  '  -/+' num2str(TimeWindow/Fs_Im) ' sec'],'Fontsize',14);ylabel('#Passes','Fontsize',14);title('All cells averaged','Fontsize',14)
        subplot(232);pcolor(meanTimeTransients2);colorbar;shading flat;colormap jet; xlabel(['TimeWindow'  '  -/+' num2str(TimeWindow/Fs_Im) ' sec'],'Fontsize',14);title('Individual Cells','Fontsize',14)
        ylabel('#Cells','Fontsize',14);
          hold on;stem(TimeWindow+0.5,min(size(cells_transients))+1,'w:','LineWidth',5);
           koeff=min(size((cells_transients)))/max(mean(meanTimeTransients2));
           plot(mean(meanTimeTransients2)*koeff,'k--','LineWidth',1)
           
           
        Wn=1/2;
[b,a]=butter(2,Wn);
y=filtfilt(b,a,zscore_transients);
% y=y';
y=meanTimeTransients2';
% figure;plot(y)
for i=1:min(size(cells_transients))
ymax(i)=(find(y(:,i)==max(y(:,i))));
end           
           
           aa=zeros(min(size(cells_transients)),TimeWindow*2);
k=0;
for ii=1:(Fs_Im*TimeWindow*2)
temp=find(ymax==ii);
for i=1:length(temp)
    aa(k+i,:)=meanTimeTransients2(temp(i),:);
end
if(i>0)
k=k+i;
end
end
    subplot(233);pcolor(aa);shading flat;colormap jet;
       hold on;stem(TimeWindow+0.5,min(size(cells_transients))+1,'w:','LineWidth',5);title('Ranked Map','Fontsize',14);   
           plot(1:min(size(aa)),linspace(1,length(meanTimeTransients2),min(size(aa))),'k--')
        
       mean2TimeTransients2=mean(meanTimeTransients2);
           Wn=1/5;
[b,a]=butter(2,Wn);
y=filtfilt(b,a,mean2TimeTransients2);
            tt=linspace(0,2*TimeW,length(y));
           subplot(2,3,4:6);plot(tt,y,'b');hold on;line([TimeW TimeW],[min(y) max(y)]);xlabel('seconds','FontSize',16);box off
           
           [mean(mean2TimeTransients2(1:length(y)/2))/ mean(mean2TimeTransients2(length(y)/2+1:length(y)))]
