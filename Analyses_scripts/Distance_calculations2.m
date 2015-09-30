Fs_tracking=30;
Fs_Im=5;
Im_duration=10*60; %10min
Sampling_factor=Fs_tracking/Fs_Im;


[beh dir]=uigetfile('.xlsx','Behavior');
beh=xlsread([dir beh]);
beh=beh(1:Fs_tracking*Im_duration,:);
% vhpc18_transzone_behcorrected=a.vhpc18_transzone_behcorrected;

[cells dir]=uigetfile('','Transients');
a=load([dir cells],'-mat')
cells_transients=struct2array(a);
cells_transients=cells_transients(:,2:end);
xxyy=beh(:,3:4); 
%%
%Interpolate the tracking
ii=1;
while ii>0
  [xxnan yynan]=find(isnan(xxyy))
  for i=1:length(yynan)
      xxyy(xxnan(i),yynan(i))=xxyy(xxnan(i)+1,yynan(i));
  end
  ii=length(yynan)
end


%%
norm_transients=cells_transients;
for i=1:min(size(cells_transients))
    norm_transients(:,i)=norm_transients(:,i)+abs(mean(norm_transients(:,i)));
norm_transients(:,i)=norm_transients(:,i)./max(norm_transients(:,i));
end
%%
figure;plot(xxyy(:,1),xxyy(:,2));
gginput=char(inputdlg('How many transition point like to add?'));
dist_entered=str2num(char(inputdlg('Enter the desired distance perimeter in cm?')));
trans1=ginput(str2num(gginput))
for ii=1:length(trans1)
hold on;plot(trans1(ii,1),trans1(ii,2),'r*','MarkerSize',10)
end
des_trans=str2num(char(inputdlg('Which one do you like to analyze?')));
trans1=trans1(des_trans,:)
%%
xydist1=sqrt((xxyy(:,1)-(trans1(1))).^2+(xxyy(:,2)-trans1(2)).^2);
tempindbothways=find(xydist1<dist_entered); %just distance relation no direction selectivity
xxyy_temp=[xxyy(tempindbothways,1) xxyy(tempindbothways,2)];
hold on;
% plot(xxyy(tempindbothways,1),xxyy(tempindbothways,2),'k:','MarkerSize',10);
%Find the Ref Angle
trans1_angle=abs(atan2(trans1(2),trans1(1))*180/pi);
%Points Angles
temp_angle=abs(atan2(xxyy(tempindbothways,2),xxyy(tempindbothways,1))*180/pi);
angle_diff=trans1_angle-temp_angle; %Finding the directional movement
tempindclockw=find(angle_diff>0);  % + direction
tempind_c_clockw=find(angle_diff<0);    %-direction
plot(xxyy(tempindbothways(tempindclockw),1),xxyy(tempindbothways(tempindclockw),2),'c','MarkerSize',10);
plot(xxyy(tempindbothways(tempind_c_clockw),1),xxyy(tempindbothways(tempind_c_clockw),2),'m','MarkerSize',10);
%%
dist_clockw=sqrt((trans1(1)-xxyy(tempindbothways(tempindclockw),1)).^2+(trans1(2)-xxyy(tempindbothways(tempindclockw),2)).^2)
dist_c_clockw=sqrt((trans1(1)-xxyy(tempindbothways(tempind_c_clockw),1)).^2+(trans1(2)-xxyy(tempindbothways(tempind_c_clockw),2)).^2)

trans_ind_clockw=ceil(tempindbothways(tempindclockw)/Sampling_factor)
trans_ind_c_clockw=ceil(tempindbothways(tempind_c_clockw)/Sampling_factor)

newTrans1=norm_transients(trans_ind_clockw,:);
newTrans2=norm_transients(trans_ind_c_clockw,:);
for i=1:min(size(cells_transients))
figure(1);hold on;scatter(newTrans1(:,i),dist_clockw);axis tight;
xxx=linspace(min(newTrans1(:,i)),max(newTrans1(:,i)),10);
[p,x]=polyfit(newTrans1(:,i),dist_clockw,1);
hold on;plot(p(1).*xxx+p(2),'r');
cc=corrcoef(newTrans1(:,i),dist_clockw);
corrTrans1_dist(i)=cc(2,1);
% pause(.5)
end

figure;
for i=1:min(size(cells_transients))
hold on;plot(newTrans1(:,i)./trans_ind_clockw)
% pause(.4)
end




bigMatrix1=zeros(length(dist_clockw),min(size(cells_transients)));
bigMatrix2=zeros(length(dist_c_clockw),min(size(cells_transients)));

temp1=dist_clockw;
for i=1:length(bigMatrix1)-1
    tempind1=find(temp1==min(temp1));
    bigMatrix1(i,:)=newTrans1(tempind1(1),:);
    temp1(tempind1)=max(dist_clockw);
end
figure;imagesc(bigMatrix1');colormap jet;colorbar

   temp2=dist_c_clockw;
for i=1:length(bigMatrix2)-1
    tempind2=find(temp2==min(temp2));
    bigMatrix2(i,:)=newTrans2(tempind2(1),:);
    temp2(tempind2)=max(dist_c_clockw);
end
figure;imagesc(bigMatrix2');colormap jet;colorbar
figure;imagesc([bigMatrix2; bigMatrix1]');caxis([0 1]);colormap jet;colorbar
hold on;stem(length(bigMatrix2),min(size(cells_transients)),'w:','LineWidth',5)
xlabel('-->  Dist-Nearby CounterClockWise <--> ClockWise Nearby-Distant   <---','Fontsize',14)


        