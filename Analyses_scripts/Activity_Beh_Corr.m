function Activity_Beh_Corr

sampling_rate_Ca=5;
sampling_rate_Ca=str2num(char(inputdlg('Enter the Imaging Sampling Rate:')));
sampling_rate_Video=30;
sampling_rate_Video=str2num(char(inputdlg('Enter the Tracking Sampling Rate:')));
imaging_per=10*60;
Resampling_ratio=sampling_rate_Video/sampling_rate_Ca;
sel_corr=0.2;
% sel_corr=str2num(char(inputdlg('Correlation level:')));

% axy=inputdlg('Enter the transition points in x-y:','enter',2)
% sel_corr=str2num(char(inputdlg('Set the correlation level')));
% xyref=str2num(char(axy));
[beh dir]=uigetfile('.xlsx','Behavior');
beh=xlsread([dir beh]);
beh=beh(1:sampling_rate_Video*imaging_per,:);
xxyy=beh(:,3:4); 
% vhpc18_transzone_behcorrected=a.vhpc18_transzone_behcorrected;

[cells dir]=uigetfile('','Transients');
a=load([dir cells],'-mat')
cells_transients=struct2array(a);
cells_transients=cells_transients(:,2:end);


%%
% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/zero_open_closedtransitions_forheatmap/vhpc18/vhpc18_trajectcorrected_beh/vhpc18_transzone_behcorrected')
% vhpc18_transzone_behcorrected=a.vhpc18_transzone_behcorrected;
% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/zero_open_closedtransitions_forheatmap/vhpc18/vhpc18_completelyraw/vhpc18_zero_cellSDs');
% cells_transients=a.vhpc18_zero_cellSDs;
% cells_transients=cells_transients(:,2:end);
% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/zero_open_closedtransitions_forheatmap/vhpc18/vhpc18_completelyraw/vhpc18_zero_cellevents');
% vhpc18_zero_cellevents=a.vhpc18_zero_cellevents;
% cells_events=vhpc18_zero_cellevents(:,2:end);
% beh=vhpc18_transzone_behcorrected(1:sampling_rate_Video*imaging_per*60,3:4);
%%
for i=1:min(size(cells_transients))
normevents(:,i)=cells_transients(:,i)./max(cells_transients(:,i));
end
norm_raw2=normevents;

for i=1:min(size(cells_transients))
normraw2(:,i)=cells_transients(:,i)+i-1;
end
xxyy=downsample(xxyy,Resampling_ratio);
figure;plot(xxyy(:,1),xxyy(:,2));title('mark the transition point!')
xyref=ginput(1)
hold on;plot(xyref(1),xyref(2),'rx','MarkerSize',15)
%%
% xydist1=sqrt((xxyy(:,1)-(-7)).^2+(xxyy(:,2)-22).^2)
% xydist2=sqrt((xxyy(:,1)-1).^2+(xxyy(:,2)-33).^2)
% xydist3=sqrt((xxyy(:,1)-26).^2+(xxyy(:,2)-(-6)).^2)
% xydist4=sqrt((xxyy(:,1)-35).^2+(xxyy(:,2)-2).^2)
% xydist1(find(isnan(xydist1)))=0;
% xydist2(find(isnan(xydist2)))=0;
% xydist3(find(isnan(xydist3)))=0;
% xydist4(find(isnan(xydist4)))=0;

xydist1=sqrt((xxyy(:,1)-(xyref(1))).^2+(xxyy(:,2)-xyref(2)).^2)
xydist1(find(isnan(xydist1)))=0;

% figure;plot(cells_transients);
for i=1:min(size(cells_transients))
normtrans(:,i)=cells_transients(:,i)./max(cells_transients(:,i));
end
norm_raw2=normtrans;

for i=1:min(size(normtrans))
norm_raw2(:,i)=normtrans(:,i)+i-1;
end
% figure;plot(norm_raw2)
Wn=0.5/(sampling_rate_Ca/2);
[b,a]=butter(2,Wn);
filtered_transients=filtfilt(b,a,normtrans);
% figure;plot(y)
 filtered_transients=filtered_transients(1:length(xydist1),:);
 
 user2=char(inputdlg('Interested in close or distance relationship to target?: (C/D)'));
 cc=[]
for i=1:min(size(filtered_transients))
c=corrcoef(filtered_transients(:,i),xydist1)
cc(i)=c(1,2)
end
if(user2=='C')
maxCorr=find(cc==min(cc));
else
   maxCorr=find(cc==max(cc)); 
end


figure;subplot(3,2,5:6);bar(cc);set(gcf,'Color','w')
subplot(3,2,[3:4]);plot(xydist1)
subplot(3,2,[3:4]);hold on;plot(filtered_transients(:,maxCorr)*50,'r');title(['cell# ',num2str(maxCorr)])
 

subplot(3,2,1);plot(xxyy(:,1),xxyy(:,2));title('mark the transition point!')
% xyref=ginput(1)
subplot(3,2,1);hold on;plot(xyref(1),xyref(2),'rx','MarkerSize',15)   

%   ycorrdist1=[filtered_transients -xydist1];
  subplot(3,2,2);imagesc(corrcoef(filtered_transients));colorbar;title('Cell-Cell Correlation');colormap jet;caxis([-0.5 0.5]);
%   subplot(212);imagesc(corrcoef(ycorrdist1));caxis([0 sel_corr]);axis([0 135 135.5 136.5]);colormap jet;title('Given XY Transition-AllCells Correlation')
  xlabel('cells')
end