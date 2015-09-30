
tic; figure;subplot(122);scatter(Traj(:,1),Traj(:,2),'b.');
%         subplot(121);plot(raw_CellA1,'.','MarkerSize',20)
sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=600; %10min sessions 
num_Context=3;      %number of total contexts
Context=3;              % Select the working context (1 for A and 3 for C, double check the order with original data)
Threshold=0;            %Set the activation threshold (pay attention if you using EVent or raw data)


raw_data2=raw(sampling_rate*imaging_per*(Context-1)+1:sampling_rate*imaging_per*Context,:);
Comb_cell=imread([Image_dir,'/ic.tif']);


for i=1:length(raw_data2)/10

        subplot(121);imagesc(Comb_cell);view(-90,90);xlabel('')
        if(any(raw_data2(i,CellA1)>Threshold))
        imm=CellA1(find(raw_data2(i,CellA1)>Threshold));
        for iii=1:length(imm)
        cell=imread([Image_dir,'/ic',num2str(imm(iii)),'.tif']);
        cell(find(cell>0))=50;
        Comb_cell=imadd(Comb_cell,cell);
        subplot(122);imagesc(Comb_cell);view(-90,90);xlabel('')
        end
%         pause(.01);
        Comb_cell(find(Comb_cell>5))=5;
        end
        
        %%Finding Velocity
        k=i*2;                  %2 sample iteration-- Resample this if you need accurate trajectory measurement
        if(any(raw_data2(i,CellA1)>Threshold))
        x_disp=sqrt((Traj(k+1,1)-Traj(k,1))^2+(Traj(k+1,2)-Traj(k,2))^2);
% 
        subplot(122);hold on;scatter(Traj(k,1),Traj(k,2),'r^','LineWidth',5);axis([-30 30 -30 30]);title(['V=',num2str(x_disp),'mm/ms'])
        xlabel(['Time=',num2str(i/sampling_rate),'sec'])
%         pause;
        end
% pause(.5)    

end