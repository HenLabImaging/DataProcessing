clear all
% close all

sampling_rate=5;       %Imaging Fs=5Hz
samping_rate_Traj=10;
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

FreqCells_A=(Active_cells(:,1)./sum(Active_cells(:,1)))*1e2;
FreqCells_B=(Active_cells(:,2)./sum(Active_cells(:,2)))*1e2;
FreqCells_C=(Active_cells(:,3)./sum(Active_cells(:,3)))*1e2;


cell_xy=load([data_dir,'/Cells location xy.mat']);
coord=round(cell_xy.coordinates(2:end,:));


figure;set(gcf,'Color',[1,1,1]);
% title('Pattern A-B-C')
% for i=1:Nevents
% scatter(coord(i,1),coord(i,2),FreqCells_A(i)*1e3,'bo','LineWidth',3)
% scatter(coord(i,1),coord(i,2),FreqCells_B(i)*1e3,'ro','LineWidth',3)
% scatter(coord(i,1),coord(i,2),FreqCells_C(i)*1e3,'go','LineWidth',3)
% end
% view(90,-90)

A=zeros(280,260);
B=A;C=A;
for i=1:Nevents
X=coord(i,1);Y=coord(i,2);
A(X:X+10,Y:Y+10)=FreqCells_A(i);
B(X:X+10,Y:Y+10)=FreqCells_B(i);
C(X:X+10,Y:Y+10)=FreqCells_C(i);
end

ImA = imnoise(smooth_map,'Gaussian',0.4,0.02);
ImB = imnoise(B,'Gaussian',0.04,0.02);
ImC = imnoise(C,'Gaussian',0.04,0.02);

H = fspecial('Gaussian',[9 9],1);
h = fspecial('motion', 5, 5);

FilteredMapA = imfilter(ImA,H);
FilteredMapB = imfilter(ImB,H);
FilteredMapC = imfilter(ImC,H);
FilteredMapA = imfilter(FilteredMapA,h);
FilteredMapB = imfilter(FilteredMapB,h);
FilteredMapC = imfilter(FilteredMapC,h);


% Filtered_M_Map=imfilter(FilteredMapA,h);

figure;set(gcf,'Color',[1 1 1]);
% subplot(2,3,2);imagesc(x);axis xy;
subplot(3,2,1);imagesc(FilteredMapA);axis xy;colormap(jet);axis off;title('Context A');
subplot(3,2,3);imagesc(FilteredMapB);axis xy;colormap(jet);axis off;title('Context B')
subplot(3,2,5);imagesc(FilteredMapC);axis xy;colormap(jet);axis off;title('Context C')
% 
% figure;imagesc(Filtered_M_Map),colormap(jet);axis xy
% figure;contourf(Filtered_M_Map);
MapAB=FilteredMapA-FilteredMapB;
MapAC=FilteredMapA-FilteredMapC;
MapBC=FilteredMapB-FilteredMapC;
% figure;
subplot(3,2,2);imagesc(MapAB);colormap(jet);axis xy;caxis([-0.4 0.4]);title('Context A-B');
subplot(3,2,4);imagesc(MapAC);colormap(jet);axis xy;caxis([-0.4 0.4]);title('Context A-C')
subplot(3,2,6);imagesc(MapBC);colormap(jet);axis xy;caxis([-0.4 0.4]);title('Context B-C')


%%%Trajectory Heat Map
% 
XX=zeros(50,50);
% roundXA=round(xA);
% roundXA=roundXA+30;

% roundXB=round(xB);
% roundXB=roundXB+30;
% 
roundXC=round(xC);
roundXC=roundXC+30;

 Comb_cell=imread([Image_dir,'/ic.tif']);

    for i=1:num_cell
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell=imadd(Comb_cell,cell);
%         figure(1);hold on
%        image(Comb_cell);pause(0.5);
    %     imshow(event);pause(0.1);colormap(hsv)
    end
    
    Comb_cell(find(Comb_cell>0))=5;
% figure;image(Comb_cell);view(-90,90)
figure;
for i=2001:4000
    subplot(131);hold on;scatter(xC(i,1),xC(i,2),'bd');axis([-30 30 -30 30])
      time=i/samping_rate_Traj;
    title(['Time:',num2str(time),'sec'])
    
    iter=XX(roundXC(i,1),roundXC(i,2));
    XX(roundXC(i,1),roundXC(i,2))=iter+1;
    subplot(132);imagesc(XX');colorbar;colormap(jet);axis xy
    
    Comb_cell_copy=imread([Image_dir,'/ic.tif']);
    Comb_cell2=Comb_cell_copy;
    clear CellA_cells
    for ii=1:length(CellC)
        cell=imread([Image_dir,'/ic',num2str(CellC(ii)),'.tif']);
%         cell=cell*raw(round(i/2),CellA(ii));
        cell=cell*raw(round(i/2),CellC(ii));
        Comb_cell2=imadd(Comb_cell2,cell);
     end
    Comb_cell2=imabsdiff(Comb_cell2,Comb_cell_copy);
    CellA_cells=imadd(Comb_cell,Comb_cell2);
    subplot(133);imagesc(CellA_cells);view(-90,90);caxis([0 40]);colormap(jet)
    pause(0.1);
%     if(cell>0)
%         pause;
%     end
end
    

