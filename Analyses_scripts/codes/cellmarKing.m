
figure;subplot(212);hold on;scatter(xA(:,1),xA(:,2),'bo','LineWidth',1);axis([-30 30 -30 30]);
% cell2=imread([Image_dir,'/ic',num2str(CellA(1)),'.tif']);
   cell_xy=load([data_dir,'/Cells location xy.mat']);
    coord=round(cell_xy.coordinates(2:end,:));
   
    cell2=Comb_cell;

for kk=8:9
%     subplot(211);hold on;scatter(xA(i,1),xA(i,2),'bo');axis([-20 20 -30 30])
    cell=imread([Image_dir,'/ic',num2str(CellA(kk)),'.tif']);
    cell2=imadd(cell,cell2);
    subplot(211);image(cell2);view(-90,90)
    [x1,y1]=find(cell>0);
    x(kk)=mean(x1);y(kk)=mean(y1); %Ez finding of cell coordinates
%     hold on;text(y,x,'1','Color',[1 1 1])
    CellA_event_frames1=find(raw(1:3000,CellA(kk))>0);
    subplot(212);hold on;scatter(xA(CellA_event_frames1*2,1),xA(CellA_event_frames1*2,2),'LineWidth',8);axis([-30 30 -30 30])
    
%     pause;
end
%  subplot(211);text(y,x,['1\num2str(2)'],'Color',[1 1 1])