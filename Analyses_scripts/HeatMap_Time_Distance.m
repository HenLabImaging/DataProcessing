function HeatMap_Time_Distance

Fs_tracking=30;
Fs_Im=5;
Im_duration=10*60; %10min
Sampling_factor=Fs_tracking/Fs_Im;
TimeWindow=10;

[beh dir]=uigetfile('.xlsx','Behavior');
[transfile transdir]=uigetfile('','Transients');
[eventfile eventdir]=uigetfile('','Events');

beh=xlsread([dir beh]);
beh=beh(1:Fs_tracking*Im_duration,:);
xxyy=beh(:,5:6);        %head-nose position is processed
a=load([transdir transfile],'-mat')
cells_transients=struct2array(a);
cells_transients=cells_transients(:,2:end);
a=load([eventdir eventfile],'-mat')
cell_events=struct2array(a);
cell_events=cell_events(:,2:end);


%%
%Interpolate the tracking
ii=1;
while ii>0
  [xxnan yynan]=find(isnan(xxyy))
  for i=1:length(yynan)
      xxyy(xxnan(i),yynan(i))=xxyy(xxnan(i)+1,yynan(i));
  end
  ii=length(yynan);
end


%%
norm_transients=cells_transients;
for i=1:min(size(cells_transients))

mincell=abs(min(cells_transients(:,i)));
maxcell=abs(max(cells_transients(:,i)));
if(maxcell>mincell)
    ref_baseline=maxcell;
else
    ref_baseline=mincell;
end 
% norm_transients(:,i)=norm_transients(:,i)/mean(norm_transients(:,i));
norm_transients(:,i)=norm_transients(:,i)/ref_baseline;
% norm_transients(:,i)=norm_transients(:,i)./abs(min(norm_transients(:,i)));
end

zscore_transients=[]

for i=1:min(size(cells_transients))
    zscore_transients(i,:)=(cells_transients(:,i)-mean(cells_transients(:,i))/std(cells_transients(:,i)));
end
zscore_transients=zscore_transients';


for ii=1:min(size(cell_events))
timeind=find(cell_events(:,ii)>0);
if(timeind>0)
pdSix = fitdist(timeind,'Kernel','BandWidth',20,'Kernel','normal');
tt = 1:length(cell_events);
kernel_transients(:,ii)= pdf(pdSix,tt);
kernel_transients(:,ii)= kernel_transients(:,ii)/max(kernel_transients(:,ii)); %Add the normalization
conv_kernel_trans(:,ii)=kernel_transients(:,ii).*norm_transients(1:length(kernel_transients),ii); %Modified version Kernel Model
else
kernel_transients(:,ii)= zeros(length(cell_events),1);
kernel_transients(:,ii)= kernel_transients(:,ii)/max(kernel_transients(:,ii)); %Add the normalization
conv_kernel_trans(:,ii)=kernel_transients(:,ii).*norm_transients(1:length(kernel_transients),ii);
end
% conv_kernel_trans_norm=conv_kernel_trans;

end


%%
mask_transient =[-0.0498
    0.0978                      %A typical Ca transient response
    0.4770
    0.8883
    0.9147
    0.6574
    0.4876
    0.4186
    0.3511
    0.3705
    0.3139
    0.2983
    0.2579
    0.1901
    0.1641
    0.1048
    0.1435
    0.1677
    0.1641
    0.1574
    0.1693
    0.0910
    0.0729
    0.0661
    0.0123
   -0.0783
   -0.0770];

for i=1:min(size(norm_transients))
    masked_events=conv2(mask_transient,cell_events(:,i));
        masked_transients(:,i)=masked_events(1:length(norm_transients)).*norm_transients(:,i);
end


%%
figure;plot(xxyy(:,1),xxyy(:,2));
gginput=char(inputdlg('How many transition point like to add?'));
trans1=ginput(str2num(gginput))

gg2=char(inputdlg('Which data will you use, Raw_Transients ("R"), Norm_Transients("N") or Masked_events("M")'));
% working_transients=[];
if(gg2=='M')
working_transients=masked_transients;
elseif (gg2=='N')
    working_transients=norm_transients;
else
    working_transients=cells_transients;
end


if(min(size(trans1))>1)
for ii=1:length(trans1)
hold on;plot(trans1(ii,1),trans1(ii,2),'r*','MarkerSize',10)
end
des_trans=str2num(char(inputdlg('Which transition point do you like to analyze?')));
trans1=trans1(des_trans,:)
else
hold on;plot(trans1(1),trans1(2),'r*','MarkerSize',10)
end

xydist1=sqrt((xxyy(:,1)-(trans1(1))).^2+(xxyy(:,2)-trans1(2)).^2);
timeordist=char(inputdlg('Like to analyze time or distance relevance? (T/D)'));
if(timeordist=='D')
dist_entered=str2num(char(inputdlg('Enter the desired distance perimeter in cm?')));    
tempindbothways=find(xydist1<dist_entered); %just distance relation no direction selectivity
xxyy_temp=[xxyy(tempindbothways,1) xxyy(tempindbothways,2)];
hold on;
context_sel=char(inputdlg('EPM or Zero Maze: (E or Z)'));
if context_sel=='Z'

% plot(xxyy(tempindbothways,1),xxyy(tempindbothways,2),'k:','MarkerSize',10);
%Find the Ref Angle
trans1_angle=atan2(trans1(2),trans1(1))*180/pi;
%Points Angles
temp_angle=atan2(xxyy(tempindbothways,2),xxyy(tempindbothways,1))*180/pi;
if(trans1_angle<0)
   trans1_angle=(180-abs(trans1_angle))+180;
end

if(any(temp_angle<0))
temp_angle(find(temp_angle<0))=(180-abs(temp_angle(find(temp_angle<0))))+180;
end
if(trans1_angle<90)
    temp_angle((find(temp_angle>270)))=temp_angle((find(temp_angle>270)))*-1;
end
if(trans1_angle>270)
    temp_angle((find(temp_angle<90)))=temp_angle((find(temp_angle<90)))+360;
end

% if(max(temp_angle)>0&&min(temp_angle)<0)
%     tempindclockw=find(angle_diff<temp_angle);  % + direction
% tempind_c_clockw=find(angle_diff>temp_angle);    %-direction
% else

tempindclockw=find(temp_angle<trans1_angle);  % + direction
tempind_c_clockw=find(temp_angle>trans1_angle);    %-direction

plot(xxyy(tempindbothways(tempindclockw),1),xxyy(tempindbothways(tempindclockw),2),'c.','MarkerSize',10);
plot(xxyy(tempindbothways(tempind_c_clockw),1),xxyy(tempindbothways(tempind_c_clockw),2),'m.','MarkerSize',10);

dist_clockw=sqrt((trans1(1)-xxyy(tempindbothways(tempindclockw),1)).^2+(trans1(2)-xxyy(tempindbothways(tempindclockw),2)).^2)
dist_c_clockw=sqrt((trans1(1)-xxyy(tempindbothways(tempind_c_clockw),1)).^2+(trans1(2)-xxyy(tempindbothways(tempind_c_clockw),2)).^2)

trans_ind_clockw=ceil(tempindbothways(tempindclockw)/Sampling_factor)
trans_ind_c_clockw=ceil(tempindbothways(tempind_c_clockw)/Sampling_factor)

newTrans1=working_transients(trans_ind_clockw,:);
newTrans2=working_transients(trans_ind_c_clockw,:);

else
    
  direction_sel=char(inputdlg('Analysis direction in open or close arm? Enter: x or y'));
  if direction_sel=='x'
        tempind_ver1=find(xxyy_temp(:,1)<trans1(:,1));
        tempind_ver2=find(xxyy_temp(:,1)>trans1(:,1));
        trans_ind_epm1=ceil(tempindbothways(tempind_ver1)/Sampling_factor);
        trans_ind_epm2=ceil(tempindbothways(tempind_ver2)/Sampling_factor)   ;
  elseif direction_sel=='y'
        tempind_ver1=find(xxyy_temp(:,2)<trans1(:,2));
        tempind_ver2=find(xxyy_temp(:,2)>trans1(:,2));
        trans_ind_epm1=ceil(tempindbothways(tempind_ver1)/Sampling_factor);
        trans_ind_epm2=ceil(tempindbothways(tempind_ver2)/Sampling_factor)   ;
 else
           xandy_range= str2num(char(inputdlg('Enter the X and Y range:','222',2)))
      tempind_ver1=find(xxyy_temp(:,1)<xandy_range(1));
        tempind_ver2=find(xxyy_temp(:,1)>xandy_range(1));
        tempind_ver11=find(xxyy_temp(tempind_ver1,2)<xandy_range(2));
        tempind_ver22=find(xxyy_temp(tempind_ver2,2)>xandy_range(2));
        trans_ind_epm1=ceil(tempindbothways(tempind_ver1)/Sampling_factor);
        trans_ind_epm2=ceil(tempindbothways(tempind_ver2)/Sampling_factor)   ;
        
 end
 
  
    plot(xxyy_temp(tempind_ver1,1),xxyy_temp(tempind_ver1,2),'m.','MarkerSize',10);
    plot(xxyy_temp(tempind_ver2,1),xxyy_temp(tempind_ver2,2),'c.','MarkerSize',10);
  
    
        newTrans1=working_transients(trans_ind_epm1,:);
        newTrans2=working_transients(trans_ind_epm2,:);
        
        dist_clockw=sqrt((trans1(1)-xxyy(tempindbothways(tempind_ver1),1)).^2+(trans1(2)-xxyy(tempindbothways(tempind_ver1),2)).^2)
dist_c_clockw=sqrt((trans1(1)-xxyy(tempindbothways(tempind_ver2),1)).^2+(trans1(2)-xxyy(tempindbothways(tempind_ver2),2)).^2)

        
    
  end

%%


Corr_level=0.3;
figure;subplot(121);
for i=1:min(size(working_transients))
hold on;scatter(newTrans1(:,i),dist_clockw,'b.');axis tight;
xxx=linspace(min(newTrans1(:,i)),max(newTrans1(:,i)),10);
[p,x]=polyfit(newTrans1(:,i),dist_clockw,1);
hold on;plot(xxx,p(1).*xxx+p(2),'r')
cc=corrcoef(newTrans1(:,i),dist_clockw);
corrTrans1_dist(i)=cc(2,1);
if(cc(2,1)>Corr_level ||cc(2,1)<-Corr_level)
    hold on;plot(xxx,p(1).*xxx+p(2),'g','LineWidth',4)
% pause(.5)
end
end
title('Regression-Corr in ClockW direction');ylabel('Distance(cm)','FontSize',14);xlabel('Ca2+ Strength','FontSize',14)
view(-90,90)
subplot(122)
for i=1:min(size(working_transients))
hold on;scatter(newTrans2(:,i),dist_c_clockw,'b.');axis tight;
xxx=linspace(min(newTrans2(:,i)),max(newTrans2(:,i)),10);
[p2,x]=polyfit(newTrans2(:,i),dist_c_clockw,1);
hold on;plot(xxx,p2(1).*xxx+p2(2),'r')
cc2=corrcoef(newTrans2(:,i),dist_c_clockw);
corrTrans1_dist(i)=cc2(2,1);
if(cc2(2,1)>Corr_level ||cc2(2,1)<-Corr_level)
    hold on;plot(xxx,p2(1).*xxx+p2(2),'g','LineWidth',4)
% pause(.5)
end
end
title('Regression-Corr in CounterClockW direction');ylabel('Distance(cm)','FontSize',14);xlabel('Ca2+ Strength','FontSize',14)
view(-90,90)

figure;subplot(121)
for i=1:min(size(working_transients))
hold on;plot(newTrans1(:,i)./dist_clockw)
% pause(.4)
end
title('Norm Ca2+ with distances in ClockW direction');ylabel('Norm Ca2+','FontSize',14);xlabel('samples','FontSize',14)
subplot(122);
for i=1:min(size(working_transients))
hold on;plot(newTrans2(:,i)./dist_c_clockw)
% pause(.4)
end
title('Norm Ca2+ with distances in CounterClockW direction');ylabel('Norm Ca2+','FontSize',14);xlabel('samples','FontSize',14)




bigMatrix1=zeros(length(dist_clockw),min(size(working_transients)));
bigMatrix2=zeros(length(dist_c_clockw),min(size(working_transients)));

temp1=dist_clockw;
for i=1:length(bigMatrix1)
    tempind1=find(temp1==min(temp1));
    bigMatrix1(i,:)=newTrans1(tempind1(1),:);
    temp1(tempind1)=max(dist_clockw);
end
figure;imagesc(bigMatrix1');colormap jet;colorbar

   temp2=dist_c_clockw;
for i=1:length(bigMatrix2)
    tempind2=find(temp2==min(temp2));
    bigMatrix2(i,:)=newTrans2(tempind2(1),:);
    temp2(tempind2)=max(dist_c_clockw);
end
% figure;imagesc(bigMatrix2');colormap jet;colorbar
figure;subplot(211);imagesc([bigMatrix2; bigMatrix1]');colormap jet;colorbar
hold on;stem(length(bigMatrix1),min(size(working_transients)),'w:','LineWidth',5);set(gcf,'Color','w')
% axis off;
xlabel([num2str(-dist_entered) 'cm' '<--   ' 'Dist-Nearby CounterClockWise -- ClockWise Nearby-Distant' '   -->' num2str(dist_entered) 'cm'],'Fontsize',14)

meanbigMatrix1=mean(bigMatrix1');
meanbigMatrix2=mean(bigMatrix2');

Wn=1/50;
[b,a]=butter(2,Wn);
y1=filtfilt(b,a,meanbigMatrix1);
y2=filtfilt(b,a,meanbigMatrix2);
subplot(212);plot(1:length(y2)+length(y1), [y1 y2],'b','LineWidth',5);box off
% hold on;plot([length(dist_c_clockw) length(dist_c_clockw)],[mean(meanbigMatrix1) max(meanbigMatrix1)],'k--')
else
    TimeWindowsec=str2double(inputdlg('Enter the time window size (sec)'))
    TimeWindow=TimeWindowsec*Fs_Im;
time_indices=find(xydist1<0.5);
time_indices=[time_indices(1);time_indices(find(diff(time_indices)>2))];
xxyy_down=downsample(xxyy,Sampling_factor);

meanTimeTransients=zeros(length(time_indices),2*TimeWindow);
meanTimeTransients2=zeros(min(size(working_transients)),2*TimeWindow);
time_ind_im=round(time_indices/Sampling_factor);
time_ind_im(find(time_ind_im<(TimeWindow+1)))=[];
time_ind_im(find(time_ind_im>(length(working_transients)-TimeWindow)))=[];
time_ind_im=time_ind_im(find(diff(time_ind_im)>TimeWindow))
timeind_samples=str2double(char(inputdlg(['Observed #Passes: ' num2str(length(time_ind_im)) '  ' 'Include# ?'])));
time_ind_im=time_ind_im(1:timeind_samples);

figure;subplot(211);plot(xxyy(:,1),xxyy(:,2));

for iii=1:length(time_ind_im)
   subplot(211);hold on;plot(xxyy_down(time_ind_im(iii)-TimeWindow:time_ind_im(iii)+TimeWindow,1),xxyy_down(time_ind_im(iii)-TimeWindow:time_ind_im(iii)+TimeWindow,2),'x');
    subplot(212);imagesc(working_transients(time_ind_im(iii)-TimeWindow+1:time_ind_im(iii)+TimeWindow,:)');caxis([0 1]);colormap jet;colorbar
    subplot(212);hold on;stem(TimeWindow,min(size(cells_transients)),'w:','LineWidth',5) 
    xlabel(['TimeWindow'  '  -/+' num2str(TimeWindowsec) ' sec']);ylabel('#Channels')
    
    time_Transients=working_transients(time_ind_im(iii)-TimeWindow+1:time_ind_im(iii)+TimeWindow,:);
   meanTimeTransients(iii,:)=mean(time_Transients');
   pause(1);
     temp=working_transients(time_ind_im(iii)-TimeWindow+1:time_ind_im(iii)+TimeWindow,:)';
   meanTimeTransients2=(meanTimeTransients2+temp)/iii;
end

        figure;subplot(131);imagesc(meanTimeTransients);colorbar;shading flat
        hold on;stem(TimeWindow+0.5,length(time_indices)+1,'w:','LineWidth',5);
        xlabel(['TimeWindow'  '  -/+' num2str(TimeWindow/Fs_Im) ' sec'],'Fontsize',14);ylabel('#Passes','Fontsize',14);title('All cells averaged','Fontsize',14)
        subplot(132);pcolor(meanTimeTransients2);colorbar;shading flat;colormap jet; xlabel(['TimeWindow'  '  -/+' num2str(TimeWindow/Fs_Im) ' sec'],'Fontsize',14);title('Individual Cells','Fontsize',14)
        ylabel('#Cells','Fontsize',14);
                hold on;stem(TimeWindow+0.5,min(size(cells_transients))+1,'w:','LineWidth',5);
           koeff=min(size((working_transients)))/max(mean(meanTimeTransients2));
           plot(mean(meanTimeTransients2)*koeff,'k--','LineWidth',1)
           
           %%
Wn=1/4;
[b,a]=butter(2,Wn);
y=filtfilt(b,a,mean(meanTimeTransients2));
% y2=filtfilt(b,a,std(sorted_norm_crosses)/sqrt(70))
y=y';
% figure;plot(y)
for i=1:min(size(working_transients))
ymax(i)=(find(y(:,i)==max(y(:,i))));
end           
           
           aa=zeros(min(size(working_transients)),TimeWindow*2);
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
    subplot(133);pcolor(aa);shading flat;colormap jet;
       hold on;stem(TimeWindow+0.5,min(size(working_transients))+1,'w:','LineWidth',5);title('Ranked Map','Fontsize',14);
                

end    
        
end