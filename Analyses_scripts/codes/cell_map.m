% Initial Visualization of the data (Cell Map & Histogram)
%{
- It finds the most active and distinctive cells (context selective) in ABC contexts (set threshold)
- Plot out the histogram of #Events and mean firing rates in ABC
- Distinctivity of a cell was computed by the indicated highest variations
across ABC contexts. Indicated cells can be analyzed in the 
- Take the num_cell2 for the selective cells and num_cell3 for the most
active cells 
- Context Selectivity of the cells is also color coded in plot(222), 
- Determined num_cell2 and num_cell3 will be analyzed in place fields or
other spatial temporal analysis.
%}
%%  
clear all
% close all
sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=600; %10min sessions 
num_Context=3;

  data_dir=uigetdir('','Locate the data directory');
  
  Event_dir=([data_dir,'/Calcium Events']);
  Nevents=length(dir([Event_dir,'/*.txt']));
  Nevents=Nevents-1;
  
  Image_dir=([data_dir,'/Images']);
  num_cell=length(dir([Image_dir,'/*.tif']));
  num_cell=num_cell-2 %1.ic and average  baseimage r not saved with an integer!
  Comb_cell=imread([Image_dir,'/ic.tif']); 
%%
    for i=1:num_cell
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell=imadd(Comb_cell,cell);
%         figure(1);hold on
%        image(Comb_cell);pause(0.5);
    %     imshow(event);pause(0.1);colormap(hsv)
    end
    Comb_cell(find(Comb_cell>0))=20;
    figure;image(Comb_cell);
    colormap(jet);title('Raw Cells')

    Active_cells=zeros(Nevents,num_Context);
    for i=1:Nevents
    Raw_event=load([Event_dir,'/Events',num2str(i),'.txt']);
    
    for ii=1:num_Context
    num_fires(ii)=length(find(Raw_event((ii-1)*sampling_rate*imaging_per+1:ii*sampling_rate*imaging_per,2)>0));
    end
    
    Active_cells(i,:)=num_fires;
    
    end

%most active cells across 3 contexts, set the activation threshold
sumActive=sum(Active_cells');
num_cell3=find(sumActive>0.6*max(sumActive)); % Mean firing rate 
% clear Comb_cell
% Comb_cell=imread(['ic',num2str(num_cell3(1)),'.tif'])
Comb_cell_temp=Comb_cell;
% clear Comb_cell
%  Comb_cell=imread([Image_dir,'/ic.tif']);
for i=1:length(num_cell3)
cell=imread([Image_dir,'/ic',num2str(num_cell3(i)),'.tif']);
cell*mean(Active_cells(num_cell3(i),:));
Comb_cell=imadd(Comb_cell,cell);
% imshow(Comb_cell);view(-90,90);pause
end
subplot(221);imagesc(Comb_cell);view(-90,90);colormap(jet);title('Most Active Cells (A-B-C)')

%Finding the distinctive cells by calculating highest variance/cell across
%A,B,C
for i=1:Nevents
tt(i,:)=mean(abs(diff(Active_cells(i,:))));
end

clear Comb_cell
 Comb_cell=imread([Image_dir,'/ic.tif']);
num_cell2=find(tt>0.6*max(tt));

for i=1:length(num_cell2)
cell=imread([Image_dir,'/ic',num2str(num_cell2(i)),'.tif']);
Sel_contxt=find(Active_cells(num_cell2(i),:)==max(Active_cells(num_cell2(i),:)))
cell(find(cell>10))=Sel_contxt(1)*25;   %% Fix the bug here..takes only 1.argument when there is an overlap q
Comb_cell=imadd(Comb_cell,cell);
end
Comb_cell=imadd(Comb_cell,Comb_cell_temp);

subplot(222);imagesc(Comb_cell);caxis([15 110]);colormap(jet);title('Most Selective Cells');
ylabel('A-B-C, respectively from lighter to darker in color','FontSize',20)

% Firing Rates
FiringRate=Active_cells/imaging_per;
subplot(223);hist(FiringRate(:,1:3),8);xlabel('Rate(Hz)');ylabel('# of cells');legend(' A',' B',' C')
subplot(224);histfit(sumActive',8,'rayleigh');xlabel('# of Events')
