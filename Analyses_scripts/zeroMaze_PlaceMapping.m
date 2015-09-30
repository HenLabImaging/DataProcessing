sampling_rate_Ca=5;
sampling_rate_Video=30;
imaging_per=10*60;
Resampling_ratio=sampling_rate_Video/sampling_rate_Ca;
bin=str2num(char(inputdlg('Enter the bin number size: ')));

% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/open_closedtransitions_forheatmap/vhpc18/vhpc18_trajectcorrected_beh/vhpc18_transzone_behcorrected')
% vhpc18_transzone_behcorrected=a.vhpc18_transzone_behcorrected;
% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/open_closedtransitions_forheatmap/vhpc18/vhpc18_completelyraw/vhpc18_zero_cellSDs');
% cells_transients=a.vhpc18_zero_cellSDs;
% cells_transients=cells_transients(:,2:end);
% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/open_closedtransitions_forheatmap/vhpc18/vhpc18_completelyraw/vhpc18_zero_cellevents');
% vhpc18_zero_cellevents=a.vhpc18_zero_cellevents;
% Raw_event=vhpc18_zero_cellevents(:,2:end);
% beh=vhpc18_transzone_behcorrected(1:sampling_rate_Video*imaging_per*60,3:4);


[beh dir]=uigetfile('.xlsx','Behavior');
beh=xlsread([dir beh]);
beh=beh(1:sampling_rate_Video*imaging_per,:);
% vhpc18_transzone_behcorrected=a.vhpc18_transzone_behcorrected;

[cells dir]=uigetfile('','Transients');
a=load([dir cells],'-mat')
cells_transients=struct2array(a);
cells_transients=cells_transients(:,2:end);
xxyy=beh(:,3:4); 
Raw_event=cells_transients;
Raw_event=Raw_event(1:imaging_per*sampling_rate_Ca,:);

%%
xxyy=downsample(xxyy,Resampling_ratio);
% Nevents=lenght(Raw_event);
N=bin; % select your bin size (max size/N)

xymin=floor(min(xxyy))
xymax=ceil(max(xxyy))
x = linspace(xymin(1)-1,xymax(1)+1,N);        
y = linspace(xymin(2)-1,xymax(2)+1,N);
X=zeros(N);
binx=diff(x);
biny=diff(y);
bin_size=binx(1)*biny(1)

figure;
% Horizontal grid 
for k = 1:length(y)
  line([x(1) x(end)], [y(k) y(k)])
end

% Vertical grid
for k = 1:length(x)
  line([x(k) x(k)], [y(1) y(end)])
end

hold on;scatter(xxyy(:,1),xxyy(:,2),'bo','LineWidth',1);axis tight

Cell_dist=[1:min(size(Raw_event))];
%%
for kkk=1:length(Cell_dist)%Place fields for set of #N Cells
X=zeros(N);
    for i=1:length(Raw_event)  %%  Tracking the mouse's trajectory

   if(Raw_event(i,Cell_dist(kkk))>1)

    diffx=abs(x-floor(xxyy(i,1)));
    diffy=abs(y-floor(xxyy(i,2)));
    
    X(find(diffy==min(diffy)),find(diffx==min(diffx)))=X(find(diffy==min(diffy)), find(diffx==min(diffx)))+1;

    
   end
%     pause(0.1);
end
X_activity=X;
% figure(1);clf;pcolor(x,y,X_activity);axis xy;colormap(jet);colorbar;title('Activity Map','Fontsize',20);shading flat

X=zeros(N);
roundxxyy2=round(xxyy);
roundxxyy2(find(isnan(roundxxyy2)))=0;
% for i=1:6000
for i=1:length(roundxxyy2)
xxyy2(i,1)=min(find(abs(roundxxyy2(i,1)-x)==min(abs(roundxxyy2(i,1)-x))));
xxyy2(i,2)=min(find(abs(roundxxyy2(i,2)-y)==min(abs(roundxxyy2(i,2)-y))));
end

for k=1:length(X)
    for kk=1:length(X)
        X(kk,k)=length(find(xxyy2(:,1)==k & xxyy2(:,2)==kk));
    end
end
X_sampling=X;
figure(2);clf;pcolor(x,y,X_sampling);axis xy;colormap(jet);colorbar;title('Occupancy Map','Fontsize',20);shading interp


XplaceField=X_activity./X_sampling;
XplaceField(find(isinf(XplaceField)))=.001;     %Eliminate the NaN or Inf numbers 
XplaceField(find(isnan(XplaceField)))=0;
% figure;imagesc(x,y,XplaceField);axis xy,colormap(jet);colorbar;title('Place Field','Fontsize',20)

window_size=bin_size*5; %cm2
smoothing_window=round(window_size/bin_size);
H = fspecial('Gaussian',[smoothing_window smoothing_window],1);
smooth_map=imfilter(XplaceField,H,'same');
norm_map=smooth_map./max(max(smooth_map));

figure(12);clf;
subplot(211);imshow(im)
% subplot(12,12,kkk);
subplot(212);pcolor(smooth_map);axis xy,colormap(parula(10));title(['Cell',num2str(kkk)],'Fontsize',10);colorbar;view(0,70)
shading interp
axis off
 dlgTitle    = 'ZeroMaze Cell Selection';
 dlgQuestion = 'Do you wish to Save?';
 choice = questdlg(dlgQuestion,dlgTitle,'Yes','Naa', 'Yes');
choice='Yes';
 if(choice=='Yes') 
saveas(gcf,['/Volumes/Research/Results/Jess/EPM/SpatialMaps/vhpc22/Cell' num2str(kkk)],'jpg')
 end
% ylabel(['bin size:',num2str(bin_size),'cm'],'Fontsize',10) %
% 
% 
% %%Place Cell anatomical location
% %  cell=imread([Image_dir,'/ic',num2str(Cell_dist2(kkk)),'.tif']);
% %         Comb_cell=imadd(Comb_cell,cell);
% %         figure;subplot(211);imagesc(Comb_cell);view(-90,90);colormap(jet);title('Distinctive A Cells');caxis([0 50])
% %         Comb_cell(find(Comb_cell>0))=5;
%         
% pause(0.1)
end

