
%%%% Script determines the Activity Map + Sampling Map = Place Field Map 
%{
- This code is designed to run wo need of any other analysis so use clear.
- Place Field Maps can be extracted for the set of Cells!
- Assign the Cell_dist as your desired cells 
- Good idea to use spatial or statistical different set of cells here.
(clusters.m first or set the CellA,B,C)
- Enter the desired bin size (assigned by the setting arena size)
- Use bigger area grids for AandB and smaller for C contexts.

%}

% clear all

sampling_rate=5;       %Imaging Fs=5Hz
samping_rate_Traj=10;
imaging_per=600; %10min sessions 
num_Context=3;


%   data_dir=uigetdir('','Locate the data directory');
%   
%   Event_dir=([data_dir,'/Calcium Events']);
%   Nevents=length(dir([Event_dir,'/*.txt']));
%   Nevents=Nevents-1;
%   
%   Image_dir=([data_dir,'/ic']);
%   num_cell=length(dir([Image_dir,'/*.tif']));
%   num_cell=num_cell-2 %1.ic and average  baseimage r not saved with an integer!
  
%DG1
[xA]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextA_ethovision.xlsx','C:D');
[xB]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextB_ethovision.xlsx','C:D');
[xC]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextC_ethovision.xlsx','C:D');

%DG2
% [xA]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG2_contextA_ethovision.xlsx','C:D');
% [xB]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG2_contextB_ethovision.xlsx','C:D');
% [xC]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG2_contextC_ethovision.xlsx','C:D');

%DG4
% [xA]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextA_ethovision.xlsx','C:D');
% [xB]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextB_ethovision.xlsx','C:D');
% [xC]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextC_ethovision.xlsx','C:D');

xxyy=xA; % define the animal's arena (A-B-C)
% Cell_dist=[201:218]; % set of cells to be analyzed for place field's
Arena=1;

for i=1:Nevents
Raw_event=load([Event_dir,'/Event',num2str(i),'.txt']);         %Working with Events only
raw(:,i)=Raw_event(:,2);
end
%                                                                                 Raw Ca2+ data
%                                                                                
% raw_data=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG 4 Aug 28 Final Extracted Data/dg4_356CELLS_SD.xlsx');
% raw_data=raw_data(:,3:end); %discard the time information

% %%Trimmed B data
% xB2=xB(1:5000,:); % 1:5000
% raw_dataB=raw_data(3001:5500); %rawB is resized for trimmed XB

%%Finding Velocity
for i=1:length(xxyy)-1
x_disp(i)=sqrt((xxyy(i+1,1)-xxyy(i,1))^2+(xxyy(i+1,2)-xxyy(i,2))^2);
end
figure;plot(x_disp);

disp_threshold=3/samping_rate_Traj; %3cm/sec
x_movement=find(x_disp>disp_threshold);
x_stance=find(x_disp<disp_threshold);
x_event_movement=round(x_movement/2); %downsampled for Events
x_event_stance=round(x_stance/2); %downsampled for Events

%%Setting grids

N = 12^2; % select your bin size (max size/N)

% gridxy1=ceil(max(xC));
% gridxy2=floor(min(xC));

figure;
% 
% x = linspace(-24,20,sqrt(N)+1);         %smaller arena;C
% y = linspace(-8,20,sqrt(N)+1);

x = linspace(-30,30,sqrt(N)+1);       %bigger one;A
y = linspace(-30,30,sqrt(N)+1);

X=zeros(sqrt(N));
bin_size=max([x y])*2/sqrt(N);

% Horizontal grid 
for k = 1:length(y)
  line([x(1) x(end)], [y(k) y(k)])
end

% Vertical grid
for k = 1:length(x)
  line([x(k) x(k)], [y(1) y(end)])
end

hold on;scatter(xxyy(:,1),xxyy(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
%%
%% Place Field Code (ActivityMap+SamplingMap)
for kkk=1:length(Cell_dist)%Place fields for set of #N Cells
X=zeros(sqrt(N));
    for i=1:length(x_movement)  %%  Tracking the mouse's trajectory
% raw(i+6000,[CellC(1)])>0dif
%         k=i*2;
%    hold on;scatter(xC(i,1),xC(i,2),'bo','LineWidth',2);axis([-30 30 -30 30]);    title(['Time:',num2str(i),'samples'])
% figure;
   if(raw(imaging_per*sampling_rate*(Arena-1)+x_event_movement(i),Cell_dist(kkk))>1)
%  figure(30);
% figure(2);hold on;scatter((xxyy(x_movement(i),1)),(xxyy(x_movement(i),2)),'ro','LineWidth',2);axis([-30 30 -30 30]); %mark the Ca Events during trajectory
% 
    diffx=abs(x-floor(xxyy(x_movement(i),1)));
    diffy=abs(y-floor(xxyy(x_movement(i),2)));
    
    X(find(diffy==min(diffy)),find(diffx==min(diffx)))=X(find(diffy==min(diffy)), find(diffx==min(diffx)))+1;
   
%     pause;
    
   end
%     pause(0.1);
end
X_activity=X;
% figure;imagesc(x,y,X_activity);axis xy;colormap(jet);colorbar;title('Activity Map','Fontsize',20)

%%sampling map
X=zeros(sqrt(N));
roundxxyy2=round(xxyy);
roundxxyy2(find(isnan(roundxxyy2)))=0;
% for i=1:6000
for i=1:length(x_movement)
xxyy2(x_movement(i),1)=min(find(abs(roundxxyy2(x_movement(i),1)-x)==min(abs(roundxxyy2(x_movement(i),1)-x))));
xxyy2(x_movement(i),2)=min(find(abs(roundxxyy2(x_movement(i),2)-y)==min(abs(roundxxyy2(x_movement(i),2)-y))));
end

for k=1:length(X)
    for kk=1:length(X)
        X(kk,k)=length(find(xxyy2(:,1)==k & xxyy2(:,2)==kk));
    end
end
X_sampling=X;
% figure;imagesc(x,y,X_sampling);axis xy;colormap(jet);colorbar;title('Sampling Map','Fontsize',20)


XplaceField=X_activity./X_sampling;
XplaceField(find(isinf(XplaceField)))=.001;     %Eliminate the NaN or Inf numbers 
XplaceField(find(isnan(XplaceField)))=0;
% figure;imagesc(x,y,XplaceField);axis xy,colormap(jet);colorbar;title('Place Field','Fontsize',20)

window_size=bin_size*3; %cm2
smoothing_window=round(window_size/bin_size);
H = fspecial('Gaussian',[smoothing_window smoothing_window],1);
smooth_map=imfilter(XplaceField,H,'same')
norm_map=smooth_map./max(max(smooth_map))
figure(12);subplot(5,10,kkk);imagesc(x,y,smooth_map);axis xy,colormap(jet);caxis([0 0.05]);title(['Cell',num2str(kkk)],'Fontsize',10)
axis off
% ylabel(['bin size:',num2str(bin_size),'cm'],'Fontsize',10) %
% 
% 
% %%Place Cell anatomical location
% %  cell=imread([Image_dir,'/ic',num2str(Cell_dist2(kkk)),'.tif']);
% %         Comb_cell=imadd(Comb_cell,cell);
% %         figure;subplot(211);imagesc(Comb_cell);view(-90,90);colormap(jet);title('Distinctive A Cells');caxis([0 50])
% %         Comb_cell(find(Comb_cell>0))=5;
%         
pause(0.1)
end