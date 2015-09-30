
% { Clustering with respect to increasing inter-cell distances
%{
- Calculate the anatomical cell-to-cell distances in 2D plane
- Extracting the #cells that clustered with given range(µm) or comparing
closer to distance cells.
- It averages abundant of cells to find a mean value of analyzed distances.
- How to use it:
                         1.Set a fixed interdistance(ex. 5µm<cells<20µm) and find set of clusters
                         with the desired distance range.
                         2. Compute the all distance from smallest (5µm is
                         the smallest range ideally) to 200-300um
                         Note: the larger you go the more cells and
                         clusters you will compute thus requires extensive
                         memory to calculate in larger distances (50-100um is optimum max range)

-Ones the clusters are determined, it will show the s.d. or variance in
mean firing rate of these cells within the clusters (Reminder: to Context separation yet).
- To compare the effect size, a similar number of cells mean firing rate
and their distribution is also computed. 


%}

% clear all


sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=600; %10min sessions 
num_Context=3;

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

    ActiveCells_5=find(Active_cells(:,1)>1&Active_cells(:,2)>1&Active_cells(:,3)>1) ; %Thresholded Cells only


% raw_data=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG 4 Aug 28 Final Extracted Data/dg4_356CELLS_SD.xlsx');
% raw_data=raw_data(:,3:end); %discard the time and 1.Event


coord=load('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG 1 August 28 Final extracted data/Cells location xy.mat');
% coord=load('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG2/Cells location xy.mat');
% coord=load('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG 4 Aug 28 Final Extracted Data/Cells location xy.mat');

coord=coord.coordinates;
coord=coord(2:end,:);

coord_ActiveCells_5=coord(ActiveCells_5,:); % coordinates for thrsholded cells

clear X XX
for l=1:length(ActiveCells_5)
for i=1:length(ActiveCells_5)
% x=coord(l,:)-coord(i,:);
% xx(1,i)=sqrt(x(1)^2+x(2)^2);
X=coord_ActiveCells_5(l,:)-coord_ActiveCells_5(i,:);
XX(l,i)=sqrt(X(1)^2+X(2)^2);
end
end
%zeroing the redundant data
for i=1:length(ActiveCells_5)
XX(i,i:end)=0;
end
figure;imagesc(XX);colormap(jet);colorbar

%%Use this for all cells

% Finding the inter cell distances for one to another rest.  
for l=1:num_cell
for i=1:num_cell
% x=coord(l,:)-coord(i,:);
% xx(1,i)=sqrt(x(1)^2+x(2)^2);
X=coord(l,:)-coord(i,:);
XX(l,i)=sqrt(X(1)^2+X(2)^2);
end
end
%zeroing the redundant data
for i=1:num_cell
XX(i,i:end)=0;
end
figure;imagesc(XX);colormap(jet);colorbar
%%

% xx and yy corresponds the cell or event numbers determined in the spatial
% radius

clear xx yy
[xx,yy]=find(XX<25 & XX>0);
l2=length(xx)

% for ii=1:length(xx)
% Spatial_ACells(ii)=std(Active_cells([xx(ii) yy(ii)],1));
% Spatial_BCells(ii)=std(Active_cells([xx(ii) yy(ii)],2));
% Spatial_CCells(ii)=std(Active_cells([xx(ii) yy(ii)],3));
% end
% figure;bar([mean(Spatial_ACells) mean(Spatial_BCells) mean(Spatial_CCells)])

% hold on;scatter(coord(xx,1),coord(yy,2),'ro')
% 
% figure; plot(raw_data(1:9000,xx(end)))
% hold on;plot(raw_data(1:9000,yy(end)),'r')
clear hh hh2 zz2 aa 
zz2=zeros(3,100);

for kk=1:100
clear xx yy
[xx,yy]=find(XX<kk+1 & XX>kk);
zz2(:,kk)=mean(abs([Active_cells(ActiveCells_5(xx,:),:) - Active_cells(ActiveCells_5(yy,:),:) ]));
length(xx)
end
figure;plot(zz2','--');hold on;plot(mean(zz2),'k','LineWidth',4)

%% Use for wo Thresholded

% for k=1:50
%     clear xx yy 
% [xx,yy]=find(XX<k & XX>0);
% zz2=zeros(1,length(xx));
% a=zeros(1,length(xx));
% for i=1:length(xx)
% zz2(i)=abs([mean(Active_cells(xx(i),:))-mean(Active_cells(yy(i),:))]);      % finding differences btw clusters
% a(i)=mean(std([Active_cells(xx(i),:) ;Active_cells(yy(i),:)]));     % finding s.d. between clusters
% end
% hh(k)=mean(zz2);    
% hh_std(k)=std(zz2);
% zz_length(k)=length(xx);
% aa(k)=mean(a);  
% % hold on;plot(hh,'r.')
% end
% NaNhh=find(isnan(hh));  % Assigning the NaN characters from the first values to mean values.. Note that on the plot!
% hh2=hh;
% hh2([NaNhh])=mean(hh(NaNhh(end)+1:end));
% NaNaa=find(isnan(aa)); 
% aa([NaNaa])=mean(aa(NaNaa(end)+1:end));
% figure;plot(hh2,'--')
% hold on;plot(aa,'r--')
% 
% computing sparsity in random population
% % 
pop_size=1000;
hh2=zeros(1,pop_size);
clear XXX
for ii=1:pop_size
zz2=zeros(1,length(ii));

for i=1:ii
    cell1=randi(num_cell);
    cell2=randi(num_cell);
    X=coord(cell1,:)-coord(cell2,:);
    XXX(ii)=sqrt(X(1)^2+X(2)^2);
    
zz2(i)=abs([mean(Active_cells(cell1,:))-mean(Active_cells(cell2,:))]);
end
hh2(ii)=mean(zz2);
end
mean(XXX)
hold on;histfit(hh2)
% %

% For scatter regression r values calculating 10 random measurement pounts for diff inter-distances
% 
% for i=1:10
% mean(std([Active_cells(xx(random_ch(i)),:) ;Active_cells(yy(random_ch(i)),:)]))
% end

%Normalizing Active Cells for A or B or C Cells

for i=1:num_cell
   Norm_active(i,:)=Active_cells(i,:)/sum(Active_cells(i,:));
end
    Norm_active(find(isnan(Norm_active)))=0
   
    
    %% computing spatial coherence for each cell with determined adjacent radius cells.
   %% A-B-C Contexts are individually analyzed and compared
    
    r_close=5;
    r_dist=30;
    clear SelectedC
    
    for ii=1:num_cell
    clear xx yy X XX
%     cell_int=134;

for i=1:num_cell
% x=coord(l,:)-coord(i,:);
% xx(1,i)=sqrt(x(1)^2+x(2)^2);
X=coord(ii,:)-coord(i,:);
XX(i)=sqrt(X(1)^2+X(2)^2);
end
[xx,yy]=find(XX<r_dist & XX>r_close);
l2=length(yy); %2.half of data is redundant(copied) 
% xx=xx(1:l2/2);
% yy=yy(1:l2/2);
    
    ABC_dist=[Norm_active(yy,1)/Norm_active(ii,1) Norm_active(yy,2)/Norm_active(ii,2)  Norm_active(yy,3)/Norm_active(ii,3) ];
%     figure;histfit(ABC_dist(:,1))
% hold on;histfit(ABC_dist(:,2))
% hold on;histfit(ABC_dist(:,3))
ABC_std(ii,:)=mean(ABC_dist);
    end
    
    selectedA=Norm_active(find(ABC_std(:,1)<1),:);            % prediction ffrom the lowest s.d. for each cell
    selectedB=Norm_active(find(ABC_std(:,2)<1),:);
    selectedC=Norm_active(find(ABC_std(:,3)<1),:);
    
    cella=0;cellb=0;cellc=0;
    for kk=1:length(selectedC)
        ll=find(selectedC(kk,:)==max(selectedC(kk,:) ))
        if(ll==1)
            cella=cella+1;
        
        elseif(ll==2)
            cellb=cellb+1;
         
         else
            cellc=cellc+1
        end
    end
    
    figure;bar([cella cellb cellc]/length(selectedC)*100)       % compute the prediction percentage for the s.d. fit
    
    