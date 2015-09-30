sampling_rate=5;       %Imaging Fs=5Hz
samping_rate_Traj=10;
imaging_per=600; %10min sessions 
num_Context=3;

  data_dir=uigetdir('','Locate the data directory');
  
  Event_dir=([data_dir,'/Calcium Events']);
  Nevents=length(dir([Event_dir,'/*.txt']));
  Nevents=Nevents-1;

[xA]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextA_ethovision.xlsx','C:D');
[xB]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextB_ethovision.xlsx','C:D');
[xC]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextC_ethovision.xlsx','C:D');

figure;
subplot(331);scatter(xA(:,1),xA(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
subplot(334);scatter(xB(:,1),xB(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
subplot(337);scatter(xC(:,1),xC(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);

roundxA=round(xA);
shifted_roundxA=roundxA+[abs(min(min(roundxA)))+1];
borders_A=max(shifted_roundxA);
XX=zeros(borders_A);
for i=1:borders_A(1)
for k=1:borders_A(2)
XX(i,k)=length(find(shifted_roundxA(:,1)==i & shifted_roundxA(:,2)==k));
end
end
XX_rate=XX/samping_rate_Traj;
subplot(332);imagesc(XX_rate')
caxis([0 5])
axis xy;
subplot(333);mesh(XX_rate')

roundxB=round(xB);
shifted_roundxB=roundxB+[abs(min(min(roundxB)))+1];
borders_B=max(shifted_roundxB);
XX=zeros(borders_B);
for i=1:borders_B(1)
for k=1:borders_B(2)
XX(i,k)=length(find(shifted_roundxB(:,1)==i & shifted_roundxB(:,2)==k));
end
end
XX_rate=XX/samping_rate_Traj;
subplot(335);imagesc(XX_rate')
caxis([0 5])
axis xy;
subplot(336);mesh(XX_rate')

roundxC=round(xC);
shifted_roundxC=roundxC+[abs(min(min(roundxC)))+1];
borders_C=max(shifted_roundxC);
XX=zeros(borders_C);
for i=1:borders_C(1)
for k=1:borders_C(2)
XX(i,k)=length(find(shifted_roundxC(:,1)==i & shifted_roundxC(:,2)==k));
end
end

XX_rate=XX/samping_rate_Traj;
subplot(338);imagesc(XX_rate')
caxis([0 5])
axis xy;
subplot(339);mesh(XX_rate')

for i=1:Nevents
Raw_event=load([Event_dir,'/Event',num2str(i),'.txt']);
raw(:,i)=Raw_event(:,2);
end

for k=1:Nevents
raw(find(raw(:,k)>0),k)=k;
end

for i=1:imaging_per*sampling_rate

if(raw(i,[133])>0)
    subplot(331);hold on;scatter(xA(i,1),xA(i,2),'ro','LineWidth',5);axis([-30 30 -30 30]);
%     pause;
end
% hold on;subplot(235);plot(raw(3000+i,CellB(1)),'b^');
if(raw(i+3000,[133])>0)
    subplot(334);hold on;scatter(xB(i,1),xB(i,2),'ro','LineWidth',5);axis([-30 30 -30 30]);
%     pause;
end
% hold on;subplot(236);plot(raw(6001+i,CellC(1)),'b^');
if(raw(i+6000,[133])>0)
    subplot(337);hold on;scatter(xC(i,1),xC(i,2),'ro','LineWidth',5);axis([-30 30 -30 30]);
%     pause;
end

% pause(0.05);
end