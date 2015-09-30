% Logical operations
%{
-Run the first part of the code unless you already loaded the interested
event data.
-Finding Overlap scores for A-B-C contexts from their mean firing rates in the event data.
-Index the p(A&B), p(AVB), etc.. and use it in other spatial mapping,place
field code.
%}
%%  

sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=600; %10min sessions 
num_Context=3;

  data_dir=uigetdir('','Locate the data directory');
  
  Event_dir=([data_dir,'/Calcium Events']);
  Nevents=length(dir([Event_dir,'/*.txt']));
  Nevents=Nevents-1;

   Active_cells=zeros(Nevents,num_Context);
    for i=1:Nevents
    Raw_event=load([Event_dir,'/Event',num2str(i),'.txt']);
    
    for ii=1:num_Context
    num_fires(ii)=length(find(Raw_event((ii-1)*sampling_rate*imaging_per+1:ii*sampling_rate*imaging_per,2)>0));
    end
    
    Active_cells(i,:)=num_fires;
    
    end
% % 

AorB_cells=find(Active_cells(:,3)<5 & [Active_cells(:,1)>10|Active_cells(:,2)>10])
AorC_cells=find(Active_cells(:,2)<5 & [Active_cells(:,1)>10|Active_cells(:,3)>10])
BorC_cells=find(Active_cells(:,1)<5 & [Active_cells(:,2)>10|Active_cells(:,3)>10])

CellA=AorB_cells;
CellB=AorC_cells;
CellC=BorC_cells;