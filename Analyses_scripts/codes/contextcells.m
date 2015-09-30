clear all
% close all

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

Active_thresh=15; %upper quartile or 2-3 std.

cellA=find(Active_cells(:,1)>Active_thresh)
cellB=find(Active_cells(:,2)>Active_thresh)
cellC=find(Active_cells(:,3)>Active_thresh)

Comb_cell_temp=imread([Image_dir,'/ic.tif']);
Comb_cell2=Comb_cell_temp;
Comb_cell3=Comb_cell_temp;
Comb_cell4=Comb_cell_temp;

  Comb_cell=Comb_cell_temp;

    for i=1:Nevents
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell=imadd(Comb_cell,cell);
%         figure(1);hold on
%        image(Comb_cell);pause(0.5);
    %     imshow(event);pause(0.1);colormap(hsv)
    end
    
for i=1:length(cellA)
%     Raw_event=load([Event_dir,'/Event',num2str(cellB(i)),'.txt']);
%     figure(1);subplot(311);hold on;plot(Raw_event(1:3000,1),Raw_event(1:3000,2),'-.')
     cell=imread([Image_dir,'/ic',num2str(cellA(i)),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell2=imadd(Comb_cell2,cell);
end
    Comb_cell2=imabsdiff(Comb_cell2,Comb_cell_temp);

for i=1:length(cellB)
%     Raw_event=load([Event_dir,'/Event',num2str(cellB(i)),'.txt']);
%     figure(1);subplot(311);hold on;plot(Raw_event(1:3000,1),Raw_event(1:3000,2),'-.')
     cell=imread([Image_dir,'/ic',num2str(cellB(i)),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell3=imadd(Comb_cell3,cell);
end
    Comb_cell3=imabsdiff(Comb_cell3,Comb_cell_temp);
for i=1:length(cellC)
%     Raw_event=load([Event_dir,'/Event',num2str(cellB(i)),'.txt']);
%     figure(1);subplot(311);hold on;plot(Raw_event(1:3000,1),Raw_event(1:3000,2),'-.')
     cell=imread([Image_dir,'/ic',num2str(cellC(i)),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell4=imadd(Comb_cell4,cell);
end
    Comb_cell4=imabsdiff(Comb_cell4,Comb_cell_temp);
            
     Comb_celltemp=imadd(Comb_cell,Comb_cell2);
     Comb_celltemp=imadd(Comb_celltemp,Comb_cell2);
     Comb_cell2=imadd(Comb_celltemp,Comb_cell2);
     clear Comb_celltemp
     
     Comb_celltemp=imadd(Comb_cell,Comb_cell3);
     Comb_celltemp=imadd(Comb_celltemp,Comb_cell3);
     Comb_cell3=imadd(Comb_celltemp,Comb_cell3);
     clear Comb_celltemp
     
     Comb_celltemp=imadd(Comb_cell,Comb_cell4);
     Comb_celltemp=imadd(Comb_celltemp,Comb_cell4);
     Comb_cell4=imadd(Comb_celltemp,Comb_cell4);
     clear Comb_celltemp
     
     
     figure;subplot(321);image(Comb_cell2);view(-90,90);xlabel('Context A')
            subplot(323);image(Comb_cell3);view(-90,90);xlabel('Context B')
            subplot(325);image(Comb_cell4);view(-90,90);xlabel('Context C')
%             
     %Finding Overlapping active neurons across Contexts
          
    cell_xy=load([data_dir,'/Cells location xy.mat']);
    coord=round(cell_xy.coordinates(2:end,:)); 
    
    
     Lsize=min([length(cellA) length(cellB)])
     for kk=1:Lsize
         if(length(cellA)>length(cellB))
                temp=find(cellA==cellB(kk));
                if(temp>0)
                   subplot(321);hold on;scatter(coord(cellA(temp),1),coord(cellA(temp),2),100,'r')
                    subplot(323);hold on;scatter(coord(cellA(temp),1),coord(cellA(temp),2),100,'r')
                end
         else
             temp=find(cellA(kk)==cellB);
                if(temp>0)
                    subplot(321);hold on;scatter(coord(cellB(temp),1),coord(cellB(temp),2),100,'r')
                    subplot(323);hold on;scatter(coord(cellB(temp),1),coord(cellB(temp),2),100,'r')
                end
         end
     end
            
     
     activeAB=find(cellA(1:Lsize)==cellB(1:Lsize))
     Lsize=min([length(cellA) length(cellC)])
     activeAC=find(cellA(1:Lsize)==cellC(1:Lsize))
     Lsize=min([length(cellB) length(cellC)])
     activeBC=find(cellB(1:Lsize)==cellC(1:Lsize))
%      
%      cellActiveAB=cellA(activeAB)
%      cellActiveAC=cellA(activeAC)
%      cellActiveBC=cellB(activeBC)
% 
%     if(any(activeAB))
%         AB_xy=coord(cellA(activeAB),:)
%         subplot(311);hold on;scatter(AB_xy(:,1),AB_xy(:,2),200,'r','LineWidth',3) 
%         subplot(312);hold on;scatter(AB_xy(:,1),AB_xy(:,2),200,'r','LineWidth',3) 
%     end
%     if(any(activeAC))
%         AC_xy=coord(cellA(activeAC),:)
%         subplot(311);hold on;scatter(AC_xy(:,1),AC_xy(:,2),200,'g','LineWidth',3) 
%         subplot(313);hold on;scatter(AC_xy(:,1),AC_xy(:,2),200,'g','LineWidth',3) 
%     end
%     if(any(activeBC))
%         BC_xy=coord(cellA(activeBC),:)
%         subplot(312);hold on;scatter(BC_xy(:,1),BC_xy(:,2),200,'m','LineWidth',3) 
%         subplot(313);hold on;scatter(BC_xy(:,1),BC_xy(:,2),200,'m','LineWidth',3)
%     end
%     
    
    if(any(activeAB)&&any(activeBC)&&any(activeAC))  %NaN check
        if(length(activeAB)>length(activeAC))
            for kk=1:length(activeAC)
                temp=find(activeAB==activeAC(kk));
                if(temp>0)
                    aa(kk)=activeAB(temp)
                end
            end
                ABCxyz=coord(cellA(aa),:)
        end
    end
    
        if(length(activeAB)<length(activeAC))
            for kk=1:length(activeAB)
                temp=find(activeAC==activeAB(kk));
                if(temp>0)
                    aa(kk)=activeAC(temp)
                end
            end
                ABCxyz=coord(cellA(aa),:)
        end
    
            
    ABC_xy=coord(cellA(activeAB(find(activeAB==activeAC>0))),:)
    subplot(311);hold on;scatter(ABC_xy(1),ABC_xy(2),200,'r','LineWidth',3)
    subplot(312);hold on;scatter(ABC_xy(1),ABC_xy(2),200,'r','LineWidth',3)
    subplot(313);hold on;scatter(ABC_xy(1),ABC_xy(2),200,'r','LineWidth',3)
   
    if(any(activeAB~=activeAC))
    AC_xy=coord(cellA(activeAC(find(activeAB~=activeAC))),:)
    subplot(311);hold on;scatter(AC_xy(1),AC_xy(2),200,'g','LineWidth',3)
    subplot(313);hold on;scatter(AC_xy(1),AC_xy(2),200,'g','LineWidth',3)
    end
    
   
    
    if(any(activeAB~=activeBC))
    BC_xy=coord(cellC(activeAC(find(activeAB~=activeBC))),:)
    subplot(312);hold on;scatter(BC_xy(1),AC_xy(2),200,'g','LineWidth',3)
    subplot(313);hold on;scatter(BC_xy(1),AC_xy(2),200,'g','LineWidth',3)
    end
	
    
    %%%Selective neurons by the context
    clear Comb_cell2 Comb_cell3 Comb_cell4
    Comb_cell2=Comb_cell_temp;
    Comb_cell3=Comb_cell_temp;
    Comb_cell4=Comb_cell_temp;

    cella=find(Active_cells(:,1)>sum(Active_cells(:,[2 3])')');
    cellb=find(Active_cells(:,2)>sum(Active_cells(:,[1 3])')');
    cellc=find(Active_cells(:,3)>sum(Active_cells(:,[1 2])')');

    for i=1:length(cella)
%     Raw_event=load([Event_dir,'/Event',num2str(cellB(i)),'.txt']);
%     figure(1);subplot(311);hold on;plot(Raw_event(1:3000,1),Raw_event(1:3000,2),'-.')
     cell=imread([Image_dir,'/ic',num2str(cella(i)),'.tif']);
    %     Event(:,:,i)=event;
     Comb_cell2=imadd(Comb_cell2,cell);
    end
    Comb_cell2=imabsdiff(Comb_cell2,Comb_cell_temp);
    
   for i=1:length(cellb)
%     Raw_event=load([Event_dir,'/Event',num2str(cellB(i)),'.txt']);
%     figure(1);subplot(311);hold on;plot(Raw_event(1:3000,1),Raw_event(1:3000,2),'-.')
     cell=imread([Image_dir,'/ic',num2str(cellb(i)),'.tif']);
    %     Event(:,:,i)=event;
     Comb_cell3=imadd(Comb_cell3,cell);
   end
       Comb_cell3=imabsdiff(Comb_cell3,Comb_cell_temp);
       
for i=1:length(cellc)
%     Raw_event=load([Event_dir,'/Event',num2str(cellB(i)),'.txt']);
%     figure(1);subplot(311);hold on;plot(Raw_event(1:3000,1),Raw_event(1:3000,2),'-.')
     cell=imread([Image_dir,'/ic',num2str(cellc(i)),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell4=imadd(Comb_cell4,cell);
end
    Comb_cell4=imabsdiff(Comb_cell4,Comb_cell_temp);
    
     Comb_celltemp=imadd(Comb_cell,Comb_cell2);
     Comb_celltemp=imadd(Comb_celltemp,Comb_cell2);
     Comb_cell2=imadd(Comb_celltemp,Comb_cell2);
     clear Comb_celltemp
     
     Comb_celltemp=imadd(Comb_cell,Comb_cell3);
     Comb_celltemp=imadd(Comb_celltemp,Comb_cell3);
     Comb_cell3=imadd(Comb_celltemp,Comb_cell3);
     clear Comb_celltemp
     
     Comb_celltemp=imadd(Comb_cell,Comb_cell4);
     Comb_celltemp=imadd(Comb_celltemp,Comb_cell4);
     Comb_cell4=imadd(Comb_celltemp,Comb_cell4);
     clear Comb_celltemp
     
       
     figure;
     subplot(322);image(Comb_cell2);view(-90,90);
            subplot(324);image(Comb_cell3);view(-90,90);
            subplot(326);image(Comb_cell4);view(-90,90);
            
     