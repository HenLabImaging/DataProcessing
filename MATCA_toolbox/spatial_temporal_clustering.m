function spatial_temporal_clustering(fs,time1,time2,cell1,cell2,Data,threshold,rmin,rmax,tempW)

if(isempty(threshold))
    threshold=0;
end


% data=DataRead(fs,time1,time2,cell1,cell2);
data=Data;
Nevents=min(size(data))


   [imagefile,image_dir]=uigetfile('.*','Load your image file');
   [pathdata,namedata,formatimage]=fileparts(imagefile);
    
   comb_cell=imread([image_dir imagefile]);
   imagepath=char(inputdlg(['Is file tag without a number ending is true?:' ' '  namedata]));
   if(isempty(imagepath))
       imagepath=namedata;
   end
   for ik=1:Nevents
    cell=imread([image_dir imagepath num2str(ik) formatimage]);
    comb_cell=imadd(comb_cell,cell);
   end
   comb_cell(find(comb_cell>0))=5;
   Comb_cell=comb_cell;
%    figure;imagesc(Comb_cell)
       
       

    count_synch=[];
count=[];
synch_window=tempW*fs; % 2 sec


for kk=1:min(size(data))
    bb=find(data(:,kk)>0);

for i=1:min(size(data))
aa=find(data(:,i)>0);
if(length(aa)>length(bb));
        count_synch=[]
for ii=1:length(bb)
count_synch(ii)=length(find(abs(aa-bb(ii))<synch_window));
end
elseif(length(bb)>length(aa));
        count_synch=[];
for ii=1:length(aa)
count_synch(ii)=length(find(abs(bb-aa(ii))<synch_window));
end
count(kk,i)=sum(count_synch);
else
        count_synch=[];
    count(kk,i)=0;
end
end
% pause;
end
figure;subplot(3,6,4:6);imagesc(count);colorbar;xlabel('cell','FontSize',16);ylabel('cell','FontSize',16);title('N of synch Events','FontSize',16);

       
   
   %%
   
%        Nevents=var2-var1+1;
    
    Active_cells=zeros(Nevents,1);
    for i=1:Nevents    
    Active_cells(i)=length(find(data(:,i)>0));
    end
    
    ActiveCells_5=find(Active_cells>threshold);
    
       [centroid_file,centroid_dir]=uigetfile('.*','Cell centroids');
       [pathdata,namedata,format]=fileparts(centroid_file);
        if(format=='.mat')
            coord=struct2array(load([centroid_dir centroid_file]));
        else
            coord=load([centroid_dir centroid_file]);
        end
        coord_ActiveCells_5=coord(ActiveCells_5,:); % coordinates for thrsholded cells
        data_activeCells_5=data(:,ActiveCells_5); 
        
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
for i=1:length(ActiveCells_5)
XX(i,i:end)=0;
end
subplot(3,6,1:3);imagesc(XX);colormap(jet);colorbar;set(gcf,'Color','w');title('Inter-cell distance (pix)','FontSize',16);xlabel('cell','FontSize',16);ylabel('cell','FontSize',16)
%%
clear xx yy
[xx,yy]=find(XX<rmax & XX>rmin);
l2=length(xx)


clear hh hh2 zz2 aa 
zz2=[];
% figure;
% max_dist=rmax;
for kk=rmin:rmax
clear xx yy
[xx,yy]=find(XX<kk+1 & XX>kk);
zz2(:,kk)=mean(abs([Active_cells(ActiveCells_5(xx,:),:) - Active_cells(ActiveCells_5(yy,:),:) ]));
subplot(3,6,7:8);hold on;bar(kk, length(find(diff(yy)>0)));axis tight;title('Clusters by inter-cell distances','FontSize',16);xlabel('Inter-cell distances (pix)','FontSize',16);ylabel('N of Clusters','FontSize',16)
std_clustersEvents=std([Active_cells(ActiveCells_5(xx))  Active_cells(ActiveCells_5(yy))]');
mean_clustersEvents=mean([Active_cells(ActiveCells_5(xx))  Active_cells(ActiveCells_5(yy))]');
sum_clustersEvents=sum([Active_cells(ActiveCells_5(xx)) Active_cells(ActiveCells_5(yy))]');

% subplot(133);hold on;errorbar(kk,mean(std_clustersEvents),std(std_clustersEvents));bar(kk,mean(std_clustersEvents));axis tight
% subplot(369);hold on;errorbar(kk,mean(sum_clustersEvents),std(sum_clustersEvents));hold on;bar(kk,mean(sum_clustersEvents));axis tight
% xlabel('Inter-cell distances (pix)','FontSize',16);ylabel('??(Events) of paired cells in cluster#','FontSize',16)
if(length(xx)>0)
for kkk=1:length(xx)
count_cluster(kkk)=count(ActiveCells_5(xx(kkk)), ActiveCells_5(yy(kkk)));
end
else
    count_cluster=0;
end

sumcount_cluster(kk)=mean(count_cluster);
end
subplot(3,6,9:10);stairs(zz2);xlabel('Inter-cell distances (pix)','FontSize',16);title('mean(diff(Event)) btw paired-cells in clusters#','FontSize',16);box off

subplot(3,6,11:12);bar(sumcount_cluster);xlabel('Inter-cell distances (pix)','FontSize',16);ylabel('Mean N of synch Events','FontSize',16);box off
title('Mean synch Events in clusters','FontSize',16)
best_cluster=find(zz2==min(zz2(find(zz2>0))));


[xx,yy]=find(XX<best_cluster+1 & XX>best_cluster);

comb_cell(find(comb_cell>0))=5;
for ix=1:length(xx)
   cell=imread([image_dir imagepath num2str(ActiveCells_5(xx(ix))) formatimage]);
   comb_cell=imadd(comb_cell,cell);
end
   comb_cell(find(comb_cell>5))=20;

for iy=1:length(yy)
   cell=imread([image_dir imagepath num2str(ActiveCells_5(yy(iy))) formatimage]);
   comb_cell=imadd(comb_cell,cell);
end
   comb_cell(find(comb_cell>5))=20;
subplot(3,6,13:18);imagesc(comb_cell); xlabel('pix','FontSize',16);ylabel('pix','FontSize',16);title('Clusters showed min(diff(sum(Event)))','FontSize',16);colormap parula(20)

% figure;scatter(coord_ActiveCells_5(:,1),coord_ActiveCells_5(:,2),'o')
% hold on;scatter(coord_ActiveCells_5(yy,1),coord_ActiveCells_5(yy,2),'ro')
%  hold on;scatter(coord_ActiveCells_5(xx,1),coord_ActiveCells_5(xx,2),'ro');axis tight;box off





%%
pop_size=100;
hh2=zeros(1,pop_size);
clear XXX
for ii=1:pop_size
zz2=zeros(1,length(ii));

for i=1:ii
    cell1=randi(Nevents);
    cell2=randi(Nevents);
    X=coord(cell1,:)-coord(cell2,:);
    XXX(ii)=sqrt(X(1)^2+X(2)^2);
    
zz2(i)=abs([mean(Active_cells(cell1,:))-mean(Active_cells(cell2,:))]);
end
hh2(ii)=mean(zz2);
end
 subplot(3,6,9:10);hold on;plot([1 rmax],[mean(hh2)+std(hh2) mean(hh2)+std(hh2)],'r--')
subplot(3,6,9:10);hold on;plot([1 rmax],[mean(hh2)-std(hh2) mean(hh2)-std(hh2)],'r--')


end
