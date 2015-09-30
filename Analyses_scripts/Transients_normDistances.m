TimeWindow=10;
% TimeWindow=str2double(inputdlg('Enter the time window size (sec)'))
% ind=char(inputdlg('Would you like the cell by cell analysis?'));
Fs_tracking=30;
Fs_Im=5;
Sampling_factor=Fs_tracking/Fs_Im;

sampling_rate_Ca=5;
sampling_rate_Video=30;
imaging_per=10;
Resampling_ratio=sampling_rate_Video/sampling_rate_Ca;

trans1=[36 2];
trans2=[1 32];
trans3=[-7  13];
trans4=[13 -9];

%%
a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/zero_open_closedtransitions_forheatmap/vhpc18/vhpc18_trajectcorrected_beh/vhpc18_transzone_behcorrected')
vhpc18_transzone_behcorrected=a.vhpc18_transzone_behcorrected;
a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/zero_open_closedtransitions_forheatmap/vhpc18/vhpc18_completelyraw/vhpc18_zero_cellSDs');
cells_transients=a.vhpc18_zero_cellSDs;
cells_transients=cells_transients(:,2:end);
a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/zero_open_closedtransitions_forheatmap/vhpc18/vhpc18_completelyraw/vhpc18_zero_cellevents');
vhpc18_zero_cellevents=a.vhpc18_zero_cellevents;
cells_events=vhpc18_zero_cellevents(:,2:end);
beh=vhpc18_transzone_behcorrected(1:Fs_tracking*imaging_per*60,3:4);
%%
for i=1:min(size(cells_events))
normevents(:,i)=cells_events(:,i)./max(cells_events(:,i));
end
norm_raw2=normevents;

for i=1:min(size(cells_events))
normraw2(:,i)=cells_events(:,i)+i-1;
end
figure;plot(normraw2)
xxyy=downsample(beh,Resampling_ratio);
%%
xydist1=sqrt((xxyy(:,1)-(trans1(1))).^2+(xxyy(:,2)-trans1(2)).^2)
xydist2=sqrt((xxyy(:,1)-trans2(1)).^2+(xxyy(:,2)-trans2(2)).^2)
xydist3=sqrt((xxyy(:,1)-trans3(1)).^2+(xxyy(:,2)-trans3(2)).^2)
xydist4=sqrt((xxyy(:,1)-trans4(1)).^2+(xxyy(:,2)-trans4(2)).^2)

xxyydist1=zeros(length(xxyy),1);
temp=xydist1;
for i=1:length(xydist1)
    a=find(xydist1==max(xydist1));
    if(max(xydist1)>0)
    xxyydist1(i)=a;
    xydist1(a)=0;
    end
end

cell_transients_xydist1=zeros(size(cells_transients));
for i=1:length(xxyydist1)
    if(xxyydist1(i)>0)
    cell_transients_xydist1(i,:)=cells_transients(xxyydist1(i),:);
    end
end

figure;subplot(221);pcolor(cell_transients_xydist1');shading interp;colormap hsv
% caxis([1 10]);axis([2000 2800 0 135]);colormap parula

xxyydist2=zeros(length(xxyy),1);
temp=xydist2;
for i=1:length(xydist2)
    a=find(xydist2==max(xydist2));
    if(max(xydist2)>0)
    xxyydist2(i)=a;
    xydist2(a)=0;
    end
end

cell_transients_xydist2=zeros(size(cells_transients));
for i=1:length(xxyydist2)
    if(xxyydist2(i)>0)
    cell_transients_xydist2(i,:)=cells_transients(xxyydist2(i),:);
    end
end

subplot(222);pcolor(cell_transients_xydist2');shading interp;colormap hsv
% caxis([1 10]);axis([2000 2800 0 135]);colormap parula

xxyydist3=zeros(length(xxyy),1);
temp=xydist3;
for i=1:length(xydist3)
    a=find(xydist3==max(xydist3));
    if(max(xydist3)>0)
    xxyydist3(i)=a;
    xydist3(a)=0;
    end
end

cell_transients_xydist3=zeros(size(cells_transients));
for i=1:length(xxyydist3)
    if(xxyydist3(i)>0)
    cell_transients_xydist3(i,:)=cells_transients(xxyydist3(i),:);
    end
end

subplot(223);pcolor(cell_transients_xydist3');shading interp;colormap hsv
% caxis([1 10]);axis([2000 2800 0 135]);


xxyydist4=zeros(length(xxyy),1);
temp=xydist4;
for i=1:length(xydist4)
    a=find(xydist4==max(xydist4));
    if(max(xydist4)>0)
    xxyydist4(i)=a;
    xydist4(a)=0;
    end
end

cell_transients_xydist4=zeros(size(cells_transients));
for i=1:length(xxyydist4)
    if(xxyydist4(i)>0)
    cell_transients_xydist4(i,:)=cells_transients(xxyydist4(i),:);
    end
end

subplot(224);pcolor(cell_transients_xydist4');shading interp;colormap hsv
% caxis([1 10]);axis([2000 2800 0 135]);