%% It will plot out 3 data for adjust sampling_rates(Ca and Trajectory)
% Monitoring (1) Raw Ca Events  + (2) Cell Activation(anatomical) + (3) Mouse Trajectory (Activity dependency)
% It is set to sample by sample monitoring in order to catch the intervals
% but remove the pauses if you need only the result mapping+activations

% -Desired context is required-- Assign the Traj=xA,xB,xC for the imported
% animal's data
% -Activation threshold is set to 4-5Xs.d.
% -Subset of cells for A,B,C (You can use Clusters.m or logicals.m) or random must be entered.
% -You can run this after finding a spatial or temporal relationship 

%%CA Events For DG1,2 and DG4.
raw_data=load('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG 1 August 28 Final extracted data/DG 1 Final sd raw data.txt');    %1.mouse
% raw_data=load('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG2/DG2 raw sd values.txt');                                                     %2.mouse
% raw_data=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG 4 Aug 28 Final Extracted Data/dg4_356CELLS_SD.xlsx');          %4.mouse
%%

raw_data=raw_data(:,3:end); %discard the time and 1.Event
% raw_data=Raw_event;  % Using the events data 
% [xA]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextA-ethovision.xlsx','C:D');
% [xB]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextB-ethovision.xlsx','C:D');
% [xC]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextC-ethovision.xlsx','C:D');


%%normalization of data Ca Events (0-1 within the channel)
for i=1:length(Active_cells)
normraw(:,i)=raw_data(:,i)./max(raw_data(:,i));
end
norm_raw2=normraw; % Arrange it in the channel order.
for i=1:length(Active_cells)
normraw2(:,i)=normraw(:,i)+i-1;
end
figure;imagesc(corrcoef(normraw2(1:1000,:)));caxis([0 0.3]);colormap jet
corrcoefX=corrcoef(normraw2(1:1000,:));

for i=1:length(des_cells)
normraw3(:,i)=normraw(:,des_cells(i))+i-1;
end
figure;plot(normraw3(1:3000,:))


CellA1=randi(num_cell,10,1); %random 10 cell is set but replace with the desired cells
Traj=xA; % assign the working Context (A-B-C)
n=1; % enter 1-3 for respective A,B,C contexts
raw_data2=raw_data((n-1)*imaging_per*sampling_rate+1:n*imaging_per*sampling_rate,:); %10min sessions )
Threshold=4; % Revise this depending on the event data or raw data you r using.
%%
Comb_cell=imread([Image_dir,'/ic.tif']);
raw_CellA1=raw_data2(:,CellA1);         %new raw data for selected Cells
raw_CellA1(find(raw_CellA1<Threshold))=0; %thresholding from the raw Ca data

    for i=1:length(Active_cells)
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
        Comb_cell=imadd(Comb_cell,cell);
    end
    Comb_cell(find(Comb_cell>0))=5; %Activation threshold
%     figure;imagesc(Comb_cell);view(-90,90);xlabel('')
    
     for ii=1:length(CellA1)
        cell=imread([Image_dir,'/ic',num2str(CellA1(ii)),'.tif']);      
        Comb_cell=imadd(Comb_cell,cell);
     end
        Comb_cell(find(Comb_cell>5))=20;
%           figure;imagesc(Comb_cell);view(-90,90);xlabel('')

       tic; figure;subplot(133);scatter(Traj(:,1),Traj(:,2),'b.'); 
        subplot(131);plot(raw_CellA1,'.','MarkerSize',20)
for i=1:length(raw_data2)
%         if(any(raw_data2(i,CellA1)>4))
%         subplot(131);hold on;plot(i,raw_CellA1(i,:),'r.','MarkerSize',20);
%         end
        subplot(132);imagesc(Comb_cell);view(-90,90);xlabel('')
        if(any(raw_data2(i,CellA1)>Threshold))
        imm=CellA1(find(raw_data2(i,CellA1)>Threshold));
        for iii=1:length(imm)
        cell=imread([Image_dir,'/ic',num2str(imm(iii)),'.tif']);
        cell(find(cell>0))=50;
        Comb_cell=imadd(Comb_cell,cell);
        subplot(132);imagesc(Comb_cell);view(-90,90);xlabel('')
        end
        pause(.1);
        Comb_cell(find(Comb_cell>5))=20;
        end
        
        %%Finding Velocity
        
        if(any(raw_data2(i,CellA1)>Threshold))
        x_disp=sqrt((Traj(i+1,1)-Traj(i,1))^2+(Traj(i+1,2)-Traj(i,2))^2);

        subplot(133);hold on;scatter(Traj(i,1),Traj(i,2),'r^','LineWidth',5);axis([-30 30 -30 30]);title(['V=',num2str(x_disp),'mm/ms'])
%         pause;
        end
pause(.1)    
end
toc


