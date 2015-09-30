figure;
% subplot(4,2,4);scatter(xC(:,1),xC(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
% subplot(4,2,5);scatter(xC(:,1),xC(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
% subplot(4,2,6);scatter(xC(:,1),xC(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
% subplot(4,2,7);scatter(xC(:,1),xC(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);



    for ii=1:length(CellC)
        
        Comb_cell_copy=imread([Image_dir,'/ic.tif']);
    Comb_cell2=Comb_cell_copy;
    Comb_cell(find(Comb_cell>0))=5;
    clear Celltemp
        cell=imread([Image_dir,'/ic',num2str(CellC(ii)),'.tif']);
%         cell=cell*raw(round(i/2),CellA(ii));
%         cell=cell*raw(round(i/2),CellC(ii));
        Comb_cell2=imadd(Comb_cell2,cell);
    
     
   Comb_cell2=imabsdiff(Comb_cell2,Comb_cell_copy);
    Celltemp=imadd(Comb_cell,Comb_cell2);
    subplot(length(CellC),2,ii);imagesc(Celltemp);view(-90,90);caxis([0 40]);colormap(jet)
    pause(0.1);

        subplot(length(CellC),2,ii+length(CellC));hold on;scatter(xC(:,1),xC(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
for i=1:imaging_per*sampling_rate

if(raw(i+6000,[CellC(ii)])>0)
    subplot(length(CellC),2,ii+length(CellC));hold on;scatter(xC(i,1),xC(i,2),'ro','LineWidth',5);axis([-30 30 -30 30]);
     axis off
%     pause;
end
end

    end
    
    
    %%%
    %temporal normalization
    for n=1:3000
        rawC(n,:)=rawC(n,:)/max(max(rawC'));
    end
    
    for n=1:100
   Comb_cell_copy=imread([Image_dir,'/ic.tif']);
    Comb_cell2=Comb_cell_copy;
    clear CellA_cells
    
    for ii=1:355
        cell(find(cell>0))=0;
        cell=imread([Image_dir,'/ic',num2str(ii),'.tif']);
%         cell=cell*raw(round(i/2),CellA(ii));
        cell=cell*rawC(n,ii)*10;
        Comb_cell2=imadd(Comb_cell2,cell);
     end
%     Comb_cell2=imabsdiff(Comb_cell2,Comb_cell_copy);
%     CellA_cells=imadd(Comb_cell,Comb_cell2);
%     subplot(133);imagesc(CellA_cells);view(-90,90);caxis([0 40]);colormap(jet)
    figure(12);clf;imagesc(Comb_cell2);colormap(jet);view(-90,90);colorbar;pause(0.5)
        
    end
        