
sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=600; %10min sessions 
num_Context=3;      %number of total contexts
Context=1;              % Select the working context (1 for A and 3 for C, double check the order with original data)
Threshold=1;            %Set the activation threshold (pay attention if you using EVent or raw data)

for i=1:Nevents
Raw_event=load([Event_dir,'/Event',num2str(i),'.txt']);         %Working with Events only
raw(:,i)=Raw_event(:,2);
end

[xA]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextA_ethovision.xlsx','C:D');
[xB]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextB_ethovision.xlsx','C:D');
[xC]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG1_contextC_ethovision.xlsx','C:D');

Traj=xB;


%%
raw_context=raw(sampling_rate*imaging_per*(Context-1)+1:sampling_rate*imaging_per*Context,:);

Comb_cell=imread([Image_dir,'/ic.tif']);
    Comb_cell(find(Comb_cell>0))=0; %Activation threshold

    for i=1:length(Active_cells)
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
        Comb_cell=imadd(Comb_cell,cell);
    end
    Comb_cell(find(Comb_cell>0))=5; %Activation threshold
   
%     figure;imagesc(Comb_cell);view(-90,90);xlabel('')

% Comb_cell=imread([Image_dir,'/ic.tif']);

desired_cells=CellA1; % use active cells for all cell analyses

    for i=1:length(desired_cells)
        cell=imread([Image_dir,'/ic',num2str(desired_cells(i)),'.tif']);
        Comb_cell=imadd(Comb_cell,cell);
    end
    Comb_cell(find(Comb_cell>0))=5; %Activation threshold
    figure;imagesc(Comb_cell);view(-90,90);xlabel('')

    writerObj = VideoWriter('peaks.avi');
    writerObj.FrameRate = 10;
    open(writerObj);
    
    figure;subplot(121);scatter(Traj(:,1),Traj(:,2),'b.');axis tight;axis off;set(gcf,'Color',[1 1 1])
    hold on;
for i=1:500
                     
                        
    subplot(121);plot(Traj(1:i,1),Traj(1:i,2),'r','LineWidth',3);
     
       
        if(any(raw_context(i,:)>Threshold))
              imm=find(raw_context(i,:)>Threshold);
            for iii=1:length(imm)
        cell=imread([Image_dir,'/ic',num2str(imm(iii)),'.tif']);
        cell(find(cell>0))=20;
        Comb_cell=imadd(Comb_cell,cell);
        subplot(122);imagesc(Comb_cell);view(-90,90);xlabel('')
            
        end
        pause(.1);
    
        Comb_cell(find(Comb_cell>5))=5;
        end
              f = getframe(gcf);
                        writeVideo(writerObj,f);
end
close(writerObj);
        