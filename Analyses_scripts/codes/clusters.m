%{
   - Run this with temporal m file.
   - Program will find the statistical different A,B and C cells with 2
   different approaches
    - Default is set to 2x s.d. of mean fire rate of individual cells.
    A/B/C cells that demonstrated 2sd differences in other 2 contexts wrt
    the one is marked.
    - Second method is to select the cells wrt normalized fire rate in ABC
       Example: Cell1 fired 3/5/2 times in A/B/C context,respectively -->
       it is marked as 30% A cell and 50% B cell. Thresholding is at ~70-80%
    - Once the selected A/B/C cells it is imaged on the XY anatomical
    location in color coded (A<--lighter--B--darker-->C).
    
%}

sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=600; %10min sessions 
num_Context=3;

    data_dir=uigetdir('','Locate the data directory');
    Image_dir=([data_dir,'/ic']);

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
    

%%
figure;plot(mean(Active_cells')','.','MarkerSize',10)
%pick the threshold -- 2xs.d. is selected as default now
Dist_cells=find(std(Active_cells')>2*mean(std(Active_cells'))>0)
% hold on;errorbar(1:length(Active_cells),mean(Active_cells')',std(Active_cells')','r')
hold on;errorbar(Dist_cells,mean(Active_cells(Dist_cells,:)'),std(Active_cells(Dist_cells,:)'),'LineStyle',':')

c=zeros(2,length(Dist_cells));
for i=1:length(Dist_cells)
c(:,i)=find(Active_cells(Dist_cells(i),:)==max(Active_cells(Dist_cells(i),:)')')
end

find(c(1,:)~=c(2,:)>0) %to indicate the activations in >1 contexts

    cell_xy=load([data_dir,'/Cells location xy.mat']);
    coord=round(cell_xy.coordinates(2:end,:));
        clear Comb_cell
      Comb_cell=imread([Image_dir,'/ic.tif']);

    for i=1:length(Active_cells)
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell=imadd(Comb_cell,cell);
    end




% Analysis-1 to run stats based Mapping 
    dd=[Dist_cells' c'];
    CellA=dd(find(dd(:,2)==1));
    CellB=dd(find(dd(:,2)==2));
    CellC=dd(find(dd(:,2)==3));
% %% Analysis-2 to run Patternic Mapping 
%     
% sumCells=sum(Active_cells')'
% 
% NormA=Active_cells(:,1)./sumCells;
% NormB=Active_cells(:,2)./sumCells;
% NormC=Active_cells(:,3)./sumCells;
% NormABC=[NormA*1e2 NormB*1e2 NormC*1e2];
% NormABC(find(isnan(NormABC)==1))=0;
% 
% 
% CellA=find(NormABC(:,1)>70)     %A>B+C
% CellB=find(NormABC(:,2)>80)     %B>A+C
% CellC=find(NormABC(:,3)>60)     %C>A+B
%%
    
    Comb_cell_copy=imread([Image_dir,'/ic.tif']);
    Comb_cell_copy(find(Comb_cell>0))=0;
    Comb_cell2=Comb_cell_copy;
    Comb_cell3=Comb_cell_copy;
    Comb_cell4=Comb_cell_copy;
    
    %Combining and bordering the CellA,B,C on same image in diff colors
    
     for i=1:length(CellA)
        cell=imread([Image_dir,'/ic',num2str(CellA(i)),'.tif']);
        Comb_cell2=imadd(Comb_cell2,cell);
     end
%      Comb_cell2=imabsdiff(Comb_cell2,Comb_cell_copy);
     
     for i=1:length(CellB)
        cell=imread([Image_dir,'/ic',num2str(CellB(i)),'.tif']);
        Comb_cell3=imadd(Comb_cell3,cell);
     end
     for i=1:length(CellC)
        cell=imread([Image_dir,'/ic',num2str(CellC(i)),'.tif']);
        Comb_cell4=imadd(Comb_cell4,cell);
     end
     
     Comb_cell(find(Comb_cell>0))=5;
     Comb_cell2(find(Comb_cell2>5))=20;
    Comb_cell3(find(Comb_cell3>5))=40;
    Comb_cell4(find(Comb_cell4>5))=60;
    
    comb23=imadd(Comb_cell,Comb_cell2);
    comb233=imadd(comb23,Comb_cell3);
    comb234=imadd(comb233,Comb_cell4);
    
    figure;subplot(211);imagesc(comb234);view(-90,90);caxis([0 60]);colormap(jet)
     set(gcf,'Color',[1 1 1])
     ylabel('A-B-C, respectively from lighter to darker in color','FontSize',20)

%    Go to temporal map to see their firing pattern in time