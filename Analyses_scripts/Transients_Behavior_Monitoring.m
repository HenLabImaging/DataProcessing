function Transients_Behavior_Monitoring

[beh dir]=uigetfile('.xlsx','Behavior');
[transfile transdir]=uigetfile('','Transients');


sampling_rate_Ca=5;
sampling_rate_Video=30;
imaging_per=10*60;
Resampling_ratio=sampling_rate_Video/sampling_rate_Ca;
TimeWin=2; %seconds
TimeWin=str2num(char(inputdlg('Enter the desired Running Time Window size: (sec)')));
TimeW=TimeWin*sampling_rate_Ca;


% [eventfile eventdir]=uigetfile('','Events');

beh=xlsread([dir beh]);
beh=beh(1:sampling_rate_Video*imaging_per,:);
xxyy=beh(:,5:6);        %head-nose position is processed
xxyy=downsample(xxyy,Resampling_ratio);
a=load([transdir transfile],'-mat')
cells_transients=struct2array(a);
cells_transients=cells_transients(:,2:end);

% a=load([eventdir eventfile],'-mat')
% cell_events=struct2array(a);
% cell_events=cell_events(:,2:end);
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

% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/open_closedtransitions_forheatmap/vhpc22/vhpc22_completelyraw/vhpc22_zero_cellSDs');
% cells_transients=a.vhpc22_zero_cellSDs;
% a=load('/Volumes/Research/Jessica/jessica_imaging/forGokhan/open_closedtransitions_forheatmap/vhpc22/vhpc22_trajectcorrected_beh/vhpc22_transzone_behcorrected');
% beh=a.vhpc22_transzone_behcorrected;

%%


writerObj = VideoWriter('Activity_Behavior_Monitoring.avi')
writerObj.FrameRate =5;
open(writerObj);
figure;subplot(1,9,1:3);plot(xxyy(:,1),xxyy(:,2),'bo','MarkerSize',1);axis tight;box off;set(gcf,'Color','w');
trans_zones=ginput(4)
hold on;subplot(1,9,1:3);plot(trans_zones(:,1),trans_zones(:,2),'c^','LineWidth',10);axis tight

for i=1+TimeW:length(xxyy)-TimeW
    subplot(1,9,4:7);pcolor(norm_transients(i-TimeW:i+TimeW,:)');shading flat;caxis([0 1]);colorbar;title(['Time: '  , ' ',  num2str(i/sampling_rate_Ca) 'sec'],'LineWidth',16);ylabel('cells','FontSize',16);xlabel(['Window = ' num2str(2*TimeWin) ' sec'],'FontSize',16)
if(i<200)
    subplot(1,9,1:3);hold on;plot(xxyy(i,1),xxyy(i,2),'ro','LineWidth',4);
elseif(i>200&&i<400)
     subplot(1,9,1:3);hold on;plot(xxyy(i,1),xxyy(i,2),'go','LineWidth',4);
else
     subplot(1,9,1:3);hold on;plot(xxyy(i,1),xxyy(i,2),'mo','LineWidth',4);
end
subplot(1,9,8:9);bar(mean(mean(norm_transients(i-TimeW:i+TimeW,:)')));axis([0.5 1 0 0.05]);axis off;ylabel('Mean Norm Transients','FontSize',16)
pause(0.1);

% subplot(1,8,1:3);hold on;plot(xxyy(i,1),xxyy(i,2),'bo','LineWidth',10);
frame= getframe(gcf);
writeVideo(writerObj,frame);
%  aviobj = addframe(aviobj,F);
end
close(writerObj);
end