function RasterHeatMap
TimeWindow=10;

ind=char(inputdlg('Would you like the cell by cell analysis?'));
Fs_tracking=30;
Fs_Im=5;
Sampling_factor=Fs_tracking/Fs_Im;


%%
[beh dir]=uigetfile('.xlsx','Behavior');
beh=xlsread([dir beh]);
beh=beh(1:18000,:);
% vhpc18_transzone_behcorrected=a.vhpc18_transzone_behcorrected;
[cells dir]=uigetfile('','Transients');
a=load([dir cells],'-mat')
cells_transients=struct2array(a);
[events dir]=uigetfile('','Event_data');
a=load([dir events],'-mat')
cells_events=struct2array(a);

cells_events=cells_events(:,2:end);
cells_transients=cells_transients(:,2:end);

% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/zero_open_closedtransitions_forheatmap/vhpc18/vhpc18_completelyraw/vhpc18_zero_cellSDs');
% % cells_transients=a.vhpc18_zero_cellSDs;

% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/zero_open_closedtransitions_forheatmap/vhpc18/vhpc18_completelyraw/vhpc18_zero_cellevents');
% vhpc18_zero_cellevents=a.vhpc18_zero_cellevents;

% % figure;plot(cells_events)
% % rect_transients=abs(cells_transients);
%%
for i=1:min(size(cells_events))
normevents(:,i)=cells_events(:,i)./max(cells_events(:,i));
end
norm_transients=cells_transients;
for i=1:min(size(cells_events))
    norm_transients(:,i)=norm_transients(:,i)+abs(mean(norm_transients(:,i)));
norm_transients(:,i)=norm_transients(:,i)./max(norm_transients(:,i));
end
    
norm_raw2=normevents;

for i=1:min(size(cells_events))
normraw2(:,i)=cells_events(:,i)+i-1;
end
% figure;plot(normraw2)
xxyy=beh(:,3:4); 
figure;plot(xxyy(:,1),xxyy(:,2));title('Mark the transition border(s)','FontSize',20);
xyref=ginput(1);
xyrange=inputdlg('Enter desired distance to analyze:','enter')
xy_range=str2num(char(xyrange));
TimeWindow=str2double(inputdlg('Enter the time window size (sec)'))

%%
xydist1=sqrt((xxyy(:,1)-(xyref(1))).^2+(xxyy(:,2)-xyref(2)).^2);
tt=find(xydist1<2);
tt2=find(xydist1<xy_range);

trans_time1=tt(find(diff(tt)>3))
trans_time2=tt2;
% indexOpenClose=find(beh(:,18)>0);
% trans_time=indexOpenClose;
%corrected time stamps
%  trans_time=[796        1488        2758        3106        3416        3598        3625        3661 3938        4169        4719        5030        5032        5227        5619        5808 6052        6430        6650        7070        7471        8801        9256       10073 10432       10484       12605       15364       16652       17110       17112       17855];
trans_time=trans_time1;
 
trans_time_im=round(trans_time/Sampling_factor)
trans_time_im=trans_time_im(find(trans_time_im<length(cells_transients)-Fs_Im*10));
meanAve_cell_Transients=zeros(Fs_Im*TimeWindow*2,min(size(cells_transients))); %-5s +5sc time window
raster_meanAve=meanAve_cell_Transients;
ll=ceil(sqrt(min(size(cells_transients))));
for ii=1:min(size(cells_transients))
for i=1:length(trans_time_im)
    if(trans_time_im(i)<(3000-Fs_Im*TimeWindow)&&trans_time_im(i)>(Fs_Im*TimeWindow-1))
        average_cellsEvents(:,i)=cells_transients(trans_time_im(i)-(Fs_Im*TimeWindow-1):trans_time_im(i)+Fs_Im*TimeWindow,ii);
        average_cellsEvents2(:,i)=normraw2(trans_time_im(i)-(Fs_Im*TimeWindow-1):trans_time_im(i)+Fs_Im*TimeWindow,ii);
% average_norm_cellsEvents(:,i)=norm_transients(trans_time_im(i)-49:trans_time_im(i)+50,ii);
    end
end
if(ind=='y')
figure(2);
% subplot(ll,ll,ii);
clf;
pcolor(average_cellsEvents')
colormap jet;caxis([0 10])
% shading interp;
hold on
stem(TimeWindow*Fs_Im,length(trans_time_im),'w--','LineWidth',2)
pause(1)
end

% trans_time=trans_time2;
 temp=xydist1;
 cell_transients_Dist=zeros(min(size(cells_transients)),length(tt2));
for i=1:length(tt2)
    tempind1=find(temp==min(temp(tt2)));
    tempind2=round(tempind1/Sampling_factor)
    cells_transients_Dist(:,i)=cells_transients(tempind2,:);
    temp(tempind1)=xy_range;
end

meanAve_cell_Transients(:,ii)=mean(average_cellsEvents');
% meanAve_cell_Transients2(:,ii)=mean(average_norm_cellsEvents');
raster_meanAve(:,ii)=mean(average_cellsEvents')+ii;
end
% figure;subplot(121);pcolor(meanAve_cell_Transients')
% colormap jet;shading flat;hold on;
% stem(TimeWindow*Fs_Im,min(size(cells_transients)),'k--','LineWidth',2)

for i=1:min(size(cells_transients))
   meanAve_cell_Transients(:,i)=meanAve_cell_Transients(:,i)-min(meanAve_cell_Transients(:,i));
    meanAve_cell_Transients(:,i)=meanAve_cell_Transients(:,i)./max(meanAve_cell_Transients(:,i));
end

% subplot(122);pcolor(meanAve_cell_Transients')
% colormap jet;hold on;shading flat
% stem(TimeWindow*Fs_Im,min(size(cells_transients)),'w--','LineWidth',2)

    
% subplot(122);pcolor(meanAve_cell_Transients2')
% colormap jet;shading interp
% hold on
% stem(50,135,'w--','LineWidth',3)

%%

figure;subplot(131);pcolor(meanAve_cell_Transients');shading flat
hold on;stem(TimeWindow*Fs_Im,min(size(cells_transients)),'w--','LineWidth',2)
title('Raw Heat Map')
Wn=1/5;
[b,a]=butter(2,Wn);
y=filtfilt(b,a,meanAve_cell_Transients);
% figure;plot(y)


for i=1:min(size(cells_transients))
ymax(i)=(find(y(:,i)==max(y(:,i))));
end

aa=zeros(Fs_Im*TimeWindow*2,min(size(cells_transients)));
k=0;
for ii=1:(Fs_Im*TimeWindow*2)
temp=find(ymax==ii);
for i=1:length(temp)
    aa(:,k+i)=meanAve_cell_Transients(:,temp(i));
end
if(i>0)
k=k+i;
end
end
subplot(132);pcolor(aa');shading flat
hold on;stem(TimeWindow*Fs_Im,min(size(cells_transients)),'w--','LineWidth',2)
title('Ranked Heat Map')
yymax=ymax-(TimeWindow*Fs_Im);
subplot(133);hist(yymax,50);hold on;histfit(yymax,50,'rayleigh')
title('Hist of shifts')

figure;imagesc(cells_transients_Dist);caxis([0 5])
