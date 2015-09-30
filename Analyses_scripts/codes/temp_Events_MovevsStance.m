% 
XX=zeros(50,50);
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
for i=1:length(x_event_movement)
    subplot(131);hold on;scatter(xC(x_movement(i),1),xC(x_movement(i),2),'bd');axis([-30 30 -30 30])
      time=i/samping_rate_Traj;
    title(['Time:',num2str(time),'sec'])
    
    iter=XX(roundXC(x_movement(i),1),roundXC(x_movement(i),2));
    XX(roundXC(x_movement(i),1),roundXC((i),2))=iter+1;
    subplot(132);imagesc(XX');colorbar;colormap(jet);axis xy
%     
    Comb_cell_copy=imread([Image_dir,'/ic.tif']);
    Comb_cell2=Comb_cell_copy;
    clear CellA_cells
    for ii=1:length(CellC)
        cell=imread([Image_dir,'/ic',num2str(CellC(ii)),'.tif']);
%         cell=cell*raw(round(i/2),CellA(ii));
        cell=cell*raw(round(x_movement(i)/2),CellC(ii));
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
    

