%{ 
   - Raster plot for selected A,B,C cells (can be adjusted in all cells)
   - Run this with clusters. m file 
   - Same color coding is true here -->Blue-A, yellow-B, red-C
   - Also, context representation is drawn in different backgroun color(A-B-C)
    
%}
%%
sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=600; %10min sessions 
num_Context=3;

for i=1:Nevents
Raw_event=load([Event_dir,'/Event',num2str(i),'.txt']);
raw(:,i)=Raw_event(:,2);
end


% To see activatoin strength use raw data!
raw2=raw;
for k=1:Nevents
raw2(find(raw2(:,k)>0),k)=1; %%for raster plot
end

for i=1:length(Active_cells)
raster_all(:,i)=i-1+raw2(:,i);
end
%%only for selected Events
for i=1:length(des_cells)
raster_des_cells(:,i)=i-1+raw2(:,des_cells(i));
end
figure;plot(raster_des_cells(1:3000,:))

figure;
x=[0 sampling_rate*imaging_per sampling_rate*imaging_per 0];
y=[0 0 220 220];
hold on;subplot(212);fill(x,y,[0.7 0.8 0.9])
% hold on
x2=x+sampling_rate*imaging_per;
x3=x2+sampling_rate*imaging_per;
hold on;subplot(212);fill(x2,y,[0.7 0.85 0.95])
hold on;subplot(212);fill(x3,y,[0.85 0.9 0.8])

hold on;subplot(212);plot(1:length(raw2),raw2(:,CellA),'b.','MarkerSize',10);
hold on;subplot(212);plot(1:length(raw2),raw2(:,CellB),'r.','MarkerSize',10);
% hold on;subplot(212);plot(1:length(raw2),raw2(:,CellC),'k.','MarkerSize',10);
axis tight

%   Comb_cell=imread([Image_dir,'/ic.tif']);
% 
% figure;
%   for i=1:length(CellB)
%         cell=imread([Image_dir,'/ic',num2str(CellB(i)),'.tif']);
%     %     Event(:,:,i)=event;
%      Comb_cell=imadd(Comb_cell,cell);
% %         figure(1);hold on
%    subplot(211);image(Comb_cell);view(-90,90);
%     %     imshow(event);pause(0.1);colormap(hsv)
%     for k=1:9000
%     subplot(212);plot(raw(1:1000,[CellB(i)]),'b^');
% %     drawnow;
% %     pause(0.1);
%     end
%   end