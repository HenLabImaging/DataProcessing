Comb_cell=imread([Image_dir,'/ic.tif']);
    Comb_cell(find(Comb_cell>0))=0; %Activation threshold

    for i=1:length(Active_cells)
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
        Comb_cell=imadd(Comb_cell,cell);
    end
    Comb_cell(find(Comb_cell>0))=5; %Activation threshold
   
    figure;imagesc(Comb_cell);view(-90,90);xlabel('')
    
%     des_cells=CellA1([2 3 8 9]);
    
     for i=1:length(des_cells)
        cell=imread([Image_dir,'/ic',num2str(des_cells(i)),'.tif']);
%         Comb_cell(find(cell>0))=tttemp(i);
        Comb_cell=imadd(Comb_cell,cell);
        Comb_cell(find(Comb_cell>5))=20;
         figure(1);imagesc(Comb_cell);view(-90,90);xlabel('')
        pause;
     end
      figure;imagesc(Comb_cell);view(-90,90);xlabel('')

      
      
