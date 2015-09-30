% Load the ABC trajectories and Mark Activation XY
%{
   - Use this if you have already one or few interested cell and like to
   compare their firing places across ABC
   -Load the ABC XY data for single animal
   -Load the Event or  raw Ca data..
   -Select the cell will be analyzed in all ABC contexts
%}
%%  

sampling_rate=5;       %Imaging Fs=5Hz
samping_rate_Traj=10;
imaging_per=600; %10min sessions 
num_Context=3;

%Load the raw data from events comment to avoid re/false data loading
for i=1:Nevents
Raw_event=load([Event_dir,'/Event',num2str(i),'.txt']);
raw(:,i)=Raw_event(:,2);
end

%%
[xA]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextA-ethovision.xlsx','C:D');
[xB]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextB-ethovision.xlsx','C:D');
[xC]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextC-ethovision.xlsx','C:D');

figure;
subplot(131);scatter(xA(:,1),xA(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
subplot(132);scatter(xB(:,1),xB(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
subplot(133);scatter(xC(:,1),xC(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);


selected_cells=randi(num_cell); % Replace it with the desired cell number(s)

%Uncomment the pause if you like to monitor sample by sample

for i=1:imaging_per*sampling_rate
% hold on;subplot(234);plot(raw(i,[CellA(1)]),'b^');
if(raw(i,[selected_cells])>0)
    subplot(131);hold on;scatter(xA(i,1),xA(i,2),'ro','LineWidth',5);axis([-30 30 -30 30]);
%     pause;
end
% hold on;subplot(235);plot(raw(3000+i,CellB(1)),'b^');
if(raw(i+3000,[selected_cells])>0)
    subplot(132);hold on;scatter(xB(i,1),xB(i,2),'ro','LineWidth',5);axis([-30 30 -30 30]);
%     pause;
end
% hold on;subplot(236);plot(raw(6001+i,CellC(1)),'b^');
if(raw(i+6000,[selected_cells])>0)
    subplot(133);hold on;scatter(xC(i,1),xC(i,2),'ro','LineWidth',5);axis([-30 30 -30 30]);
%     pause;
end
% pause;
% end
% pause(0.05);
end
