
% clear all
% close all

sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=600; %10min sessions 
num_Context=3;

Cell1=1; % Select the desired context comparison 1,2,3--> A,B,C
Cell2=2;
Activaton_threshold=10; % on #Mean firing rate



  data_dir=uigetdir('','Locate the data directory');
  
  Event_dir=([data_dir,'/Calcium Events']);
  Nevents=length(dir([Event_dir,'/*.txt']));
  Nevents=Nevents-1;
  
  Image_dir=([data_dir,'/ic']);
  num_cell=length(dir([Image_dir,'/*.tif']));
  num_cell=num_cell-2 %1.ic and average  baseimage r not saved with an integer!


    Active_cells=zeros(Nevents,num_Context);
    for i=1:Nevents
    Raw_event=load([Event_dir,'/Event',num2str(i),'.txt']);
    
    for ii=1:num_Context
    num_fires(ii)=length(find(Raw_event((ii-1)*sampling_rate*imaging_per+1:ii*sampling_rate*imaging_per,2)>0));
    end
    
    Active_cells(i,:)=num_fires;
    
    end
%%

ActiveAB_cells=Active_cells(find(Active_cells(:,Cell1)>Activaton_threshold &  Active_cells(:,Cell2)>Activaton_threshold),:);
AB_cellS=Active_cells(:,[Cell1 Cell2]);
AB_cellS(find(AB_cellS(:,1)<Activaton_threshold | AB_cellS(:,2)<Activaton_threshold),:)=0;
ActiveAB_cells=ActiveAB_cells(:,1:2);
sumABcells=sum(ActiveAB_cells')';

Norm_AB=[AB_cellS(:,1)./sum(AB_cellS')' AB_cellS(:,2)./sum(AB_cellS')'];
Norm_AB(find(isnan(Norm_AB)))=0;
Norm_AB=1*(Norm_AB(:,1)-Norm_AB(:,2));
% 
AB_cells=zeros(355,2)
for kk=1:length(ActiveAB_cells)
AB_cells(find(Active_cells(:,Cell1)==ActiveAB_cells(kk,1) & Active_cells(:,Cell2)==ActiveAB_cells(kk,2)),:)=Active_cells(find(Active_cells(:,Cell1)==ActiveAB_cells(kk,1) & Active_cells(:,Cell2)==ActiveAB_cells(kk,2)),1:2); 
end 
    
ActiveA_cells=ActiveAB_cells(:,1)./sumABcells
ActiveB_cells=ActiveAB_cells(:,2)./sumABcells
AB_cells_ratio=[ActiveA_cells ActiveB_cells]


Norm_AorB=(ActiveA_cells-ActiveB_cells);
histfreq=histcounts(sumABcells);
figure;subplot(121);barh(histfreq,0.5,'stacked');set(gca,'Fontsize',20);ylabel('#Events (A+C)','FontSize',20);xlabel('#Cells (A+C)','FontSize',20);
subplot(122);histfit(Norm_AorB,10,'kernel');set(gca,'Fontsize',20);xlabel('<-- C or A Cells --> Ratio','FontSize',20);ylabel('#Cells (A or C)','FontSize',20)

  Comb_cell=imread([Image_dir,'/ic.tif']);
  Comb_cell(find(Comb_cell>0))=0;
   Comb_cell_temp=Comb_cell;
    for i=1:num_cell
%         if(AB_cells(i)>0)
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
        cell(find(cell>0))=Norm_AB(i);
        Comb_cell=imadd(Comb_cell,cell);
%         end
%     pause;
    end

%  Comb_cell=imabsdiff(Comb_cell_temp,Comb_cell);
    figure;imagesc(Comb_cell);view(-90,90);colormap(jet);title(['Spatial distribution of Context-',num2str(Cell1),' and ',' Context-',num2str(Cell2)]);caxis([-1 1]);xlabel('med-lat(µm)','Fontsize',15),ylabel('Rost-Cau(µm)','Fontsize',15)

  