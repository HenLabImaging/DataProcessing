% Initial Visualization of the data (Cell Map & Histogram)
%{
- It finds the most active and distinctive cells (context selective) in ABC contexts (set threshold)
- Plot out the histogram of #Events and mean firing rates in ABC
- Distinctivity of a cell was computed by the indicated highest variations
across ABC contexts. Indicated cells can be analyzed in the 
- Take the num_cell2 for the selective cells and num_cell3 for the most
active cells 
- Context Selectivity of the cells is also color coded in plot(222), 
- Determined num_cell2 and num_cell3 will be analyzed in place fields or
other spatial temporal analysis.
%}
%%  
clear all

%%
rank1=xlsread('vole_324_2-72hrs_all-behaviors.xls');
rank1(find(isnan(rank1)))=0;
% rank1=rank1(1:end-2530,:);
rank1_down=downsample(rank1,2);
figure;plot(rank1_down(:,2:end))
rank1_down(find(rank1_down==2))=1;

baseline=find(rank1_down(:,2)==1);
FoodDrop=find(rank1_down(:,3)==1);
FoodInteract=find(rank1_down(:,4)==1);
NotEating=find(rank1_down(:,5)==1);
FemaleDrop=find(rank1_down(:,6)==1);
Interact=find(rank1_down(:,7)==1);
NotInteracting=find(rank1_down(:,8)==1);


% close all
sampling_rate=5;       %Imaging Fs=5Hz
imaging_per=13; %10min sessions 
num_Context=4;
Contxts=[0 5 5 10 10 5];


% vole_324_premating_
% baseline	300 sec
% food1	300 sec
% novel	600 sec
% mate	600 sec
% food2	300 sec
% 
% 
% vole_324_72h_
% baseline	180
% food1	300
% mate	600
% novel	600
% food2	300
% 
% vole_324_2weeks_
% baseline	120
% food1	180
% novel	300
% mate	300
% food2	180
% 
% vole_326_premating_
% baseline	300
% food1	300
% mate	600
% novel	600
% food2	300
% baseline	300
% --> You can delete the last baseline session in this one, we don't need it.
% 
% 
% 
% vole_326_72h_
% baseline	180
% food1	300
% mate	600
% novel	600
% food2	300
% 
% vole_326_2weeks_
% baseline	120
% food1	180
% novel	300
% mate	300
% food2	180
% 
% vole_342_premating_
% baseline	120
% food1	180
% mate	600
% novel	600
% food2	180
% 
% vole_342_72h_
% baseline	120
% food1	180
% mate	600
% novel	600
% food2	180
% vole_342_2weeks_
% baseline	120
% food1	180
% novel	600
% mate	600
% food2	180





  data_dir=uigetdir('','Locate the data directory');
  
 [dir data_dir]=uigetfile('*.','Load the Events','.*');
 [dir2 data_dir2]=uigetfile('*.','Load the Ca SD File','.*');
 
 raw_events=load([data_dir dir]);
  raw_transients=load([data_dir2 dir2]);
  Nevents=min(size(raw_events))-1;
  events=raw_events(:,2:end);
  raw_transients=raw_transients(:,2:end);


Sessions={'Baseline','Food1','Mating','Novel','Food2'}

Contxts=str2num(char(inputdlg('Enter the duration (min) for each contexts by a space')));
Contxts=[0 Contxts];
Epoch_dur1=str2double(char(inputdlg('Enter the beginning of Epoch (sec)')));
Epoch1=sampling_rate*Epoch_dur1;
Epoch_dur2=str2double(char(inputdlg('Enter the end of the Epoch (sec)')));
Epoch2=sampling_rate*Epoch_dur2;
Epoch=Epoch2-Epoch1;
threshold=str2double(char(inputdlg('Enter the amplitude threshold')));
  
  
Contxt1=sampling_rate*Contxts(2)*60;
Contxt2=sampling_rate*Contxts(3)*60;
Contxt3=sampling_rate*Contxts(4)*60;
Contxt4=sampling_rate*Contxts(5)*60;
Contxt5=sampling_rate*Contxts(6)*60;
Ca_Threshold=4;

    event1=events(1:Contxt1,:);
  event2=events(Contxt1+1:Contxt1+Contxt2,:);
  event3=events(Contxt2+1:Contxt2+Contxt3,:);
  event4=events(Contxt3+1:Contxt3+Contxt4,:);
  event5=events(Contxt4+1:Contxt4+Contxt5,:);
  
 Rank_session=str2double(char(inputdlg('For which context would you like to rank the HeatMap, e.g. "3" for Mating  ')));
 Rank_session=Rank_session-1;
  
  
  Image_dir=([data_dir,'/Images']);
  Comb_cell=imread([Image_dir,'/ic1.tif']); 
%%
    for i=1:Nevents
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
    %     Event(:,:,i)=event;
        Comb_cell=imadd(Comb_cell,cell);
%         figure(1);hold on
%        image(Comb_cell);pause(0.5);
    %     imshow(event);pause(0.1);colormap(hsv)
    end
    Comb_cell(find(Comb_cell>0))=20;
    figure;image(Comb_cell);
    colormap(jet);title('Raw Cells')

    
    raw_meansub=[];
raw_norm=[];
for i=1:min(size(events))
    raw_meansub(:,i)=raw_transients(:,i)+mean(raw_transients(:,i));
    raw_norm(:,i)=raw_meansub(:,i)./max(raw_meansub(:,i));
end
    
    
     num_fires=[];
     num_fires2=[];
     Transients_epochs=zeros(Epoch,min(size(events)));
   for ii=1:length(Contxts)-1
    for i=1:Nevents
    num_fires(ii,i)=length(find(events(1+sampling_rate*60*sum(Contxts(1:ii)):sampling_rate*60*sum(Contxts(1:(ii+1))),i)>threshold))/length(events(1+sampling_rate*60*sum(Contxts(1:ii)):sampling_rate*60*sum(Contxts(1:(ii+1))),i))*sampling_rate;
    num_fires2(ii,i)=length(find(events(1+sampling_rate*60*sum(Contxts(1:ii))+Epoch1:sampling_rate*60*sum(Contxts(1:ii))+Epoch2,i)>threshold));
    end
        Transients_epochs(1+(ii-1)*Epoch:(ii-1)*Epoch+Epoch,:)=raw_norm(1+sampling_rate*60*sum(Contxts(1:ii))+Epoch1:sampling_rate*60*sum(Contxts(1:ii))+Epoch2,:);
   end
    
   %%
   figure;subplot(411);bar(mean(num_fires'),0.4,'b')
   
%    errorbar([1:5],mean(num_fires2'),std(num_fires2'),'k:')
%     hold on;bar(mean(num_fires2'),0.4,'k');
    xlabel('Contexts');ylabel('Mean Events/min');set(gcf,'Color','w');box off
      title([Sessions{1} '                          ' Sessions{2} '                       ' Sessions{3} '                    ' Sessions{4} '                      ' Sessions{5}],'FontSize',20)
    subplot(412);bar(mean(num_fires2'),0.4,'r');box off;ylabel('Mean Events/epoch')
%     
%     figure;
% 
% %most active cells across 3 contexts, set the activation threshold
% sumActive=sum(num_fires');
% % num_cell3=find(num_fires>0.6*max(num_fires)); % Mean firing rate 
% % clear Comb_cell
% % Comb_cell=imread(['ic',num2str(num_cell3(1)),'.tif'])
% Comb_cell_temp=Comb_cell;
% % clear Comb_cell
% subplot(2,6,1);bar(std(num_fires),'r');box off;;set(gcf,'Color',[1 1 1]);xlabel('cells');title('Most Variant cells');ylabel('#Events')
% for i=1:min(size(num_fires))
%     num1=num_fires(i,:);
%     num1=num1/max(num1)*100;
% 
% Comb_cell(find(Comb_cell>5))=1;
% for ii=1:length(num1)
%     cell=imread([Image_dir,'/ic',num2str(ii),'.tif']);
%     cell(find(cell>0))=num1(ii);
%         Comb_cell=imadd(Comb_cell,cell);
% end
% 
% subplot(2,6,i+1);imagesc(Comb_cell);colormap jet;title(Sessions(i));axis off
% subplot(2,6,i+7);histfit(num_fires(i,:));axis([0 50 0 50]);box off;xlabel('cells');title(Sessions(i));ylabel('#Events')
% end
% 
% subplot(2,6,7);bar(sumActive,'r');box off;xlabel('Behaviors');title('Activity in diff Behaviors');ylabel('#Pooled_Events')


events_zeroed=[];
events_norm=[];
events=Transients_epochs;
for i=1:min(size(events))
    events_zeroed(:,i)=events(:,i)+mean(events(:,i));
    events_norm(:,i)=events_zeroed(:,i)./max(events_zeroed(:,i));
end
%     figure;pcolor(events_norm');shading flat;caxis([0 0.5]);colormap jet
    
 big_matrix=zeros(length(events),min(size(events)));
 temp2=[];
 temp3=[];
% imagesc(big_matrix);shading flat

 temp=sort(mean(events_norm(1+Rank_session*Epoch:Rank_session*Epoch+Epoch,:)));
 mean_norm_events=mean(events_norm(1+Rank_session*Epoch:Rank_session*Epoch+Epoch,:));
 
% for i=1:10000
        for ii=1:min(size(events))
%         temp=sort(events_norm(i,:));
        temp2(ii)=find(mean_norm_events==temp(ii))
        big_matrix(:,ii)=events_norm(:,temp2(ii));
%         big_matrix(i,temp2(ii))=141-ii;
        temp3(temp2(ii))=141-ii;

        end
%           h.CData=big_matrix
%         drawnow
        
% end
    
    ll=1:length(Sessions);
%     figure;
%     subplot(412);pcolor(events_norm');colormap jet;shading flat;caxis([-0.7 0.7]);title(['Raw Rank' '  ' num2str(Epoch_dur2-Epoch_dur1) 'sec/contxt']);axis off;
%     hold on;stem(ll(1)*Epoch,min(size(events)),'k--');stem(ll(2)*Epoch,min(size(events)),'k--');stem(ll(3)*Epoch,min(size(events)),'k--');stem(ll(4)*Epoch,min(size(events)),'k--');stem(ll(5)*Epoch,min(size(events)),'k--')
    subplot(413);pcolor(big_matrix');colormap jet;shading flat;caxis([-0.7 0.7]);title(['Rated Map' '  ' num2str(Epoch_dur2-Epoch_dur1) 'sec/contxt']);axis off
        hold on;stem(ll(1)*Epoch,min(size(events)),'k--');stem(ll(2)*Epoch,min(size(events)),'k--');stem(ll(3)*Epoch,min(size(events)),'k--');stem(ll(4)*Epoch,min(size(events)),'k--');stem(ll(5)*Epoch,min(size(events)),'k--')
    
    freq=sampling_rate/100;
    [b,a] = butter(2,freq,'low');  
    Smoothed_epochs=filtfilt(b,a,Transients_epochs)
    subplot(414);plot(mean(Smoothed_epochs'));axis tight; axis off;hold on
%     title(Sessions);
  title([Sessions{1} '                          ' Sessions{2} '                       ' Sessions{3} '                    ' Sessions{4} '                      ' Sessions{5}],'FontSize',20)
% stem(ll(1)*Epoch,min(size(events)),'k--');stem(ll(2)*Epoch,min(size(events)),'k--');stem(ll(3)*Epoch,min(size(events)),'k--');stem(ll(4)*Epoch,min(size(events)),'k--');stem(ll(5)*Epoch,min(size(events)),'k--')





%%

% raw_norm=abs(raw_norm);

    raw_meansub=[];
raw_norm=[];
for i=1:min(size(events))
    raw_meansub(:,i)=raw_transients(:,i)+mean(raw_transients(:,i));
    raw_norm(:,i)=raw_meansub(:,i)./max(raw_meansub(:,i));
end

raw_norm=raw_norm(1:length(rank1_down),:);

temp=raw_norm(Interact,:);

mean_temp=mean(temp);
sorted_meantemp=sort(mean_temp);
rated_matrix=[];
rated_matrix2=[];rated_matrix3=[];rated_matrix4=[];rated_matrix5=[];rated_matrix6=[];rated_matrix7=[];rated_matrix8=[];
for i=1:length(sorted_meantemp)
    temp2=find(mean_temp(i)==sorted_meantemp);
    rated_matrix(:,temp2)=temp(:,i);
    rated_matrix2(:,temp2)=raw_norm(baseline,i);
     rated_matrix3(:,temp2)= raw_norm(FoodDrop,i);
     rated_matrix4(:,temp2)= raw_norm(FoodInteract,i);
     rated_matrix5(:,temp2)= raw_norm(NotEating,i);
     rated_matrix6(:,temp2)= raw_norm(FemaleDrop,i);
%     rated_matrix7(:,temp2)= raw_norm(Interact,i);
    rated_matrix7(:,temp2)= raw_norm(NotInteracting,i);
    
    
end
figure;subplot(3,1,1:2);pcolor([rated_matrix' rated_matrix2' rated_matrix3' rated_matrix4' rated_matrix5' rated_matrix6' rated_matrix7' ]);shading flat;caxis([-0.5 0.5]);colormap jet(4)
hold on;
plot([length(rated_matrix) length(rated_matrix)],[1 length(sorted_meantemp)],'k--','LineWidth',4)
plot([length(rated_matrix)+length(rated_matrix2) length(rated_matrix)+length(rated_matrix2)],[1 length(sorted_meantemp)],'k--','LineWidth',4)

plot([length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3) length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)],[1 length(sorted_meantemp)],'k--','LineWidth',4)

plot([length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)+length(rated_matrix4) length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)+length(rated_matrix4)],[1 length(sorted_meantemp)],'k--','LineWidth',4)

plot([length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)+length(rated_matrix4)+length(rated_matrix5) length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)+length(rated_matrix4)+length(rated_matrix5)],[1 length(sorted_meantemp)],'k--','LineWidth',4)

plot([length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)+length(rated_matrix4)+length(rated_matrix5)+length(rated_matrix6) length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)+length(rated_matrix4)+length(rated_matrix5)+length(rated_matrix6)],[1 length(sorted_meantemp)],'k--','LineWidth',4)

plot([length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)+length(rated_matrix4)+length(rated_matrix5)+length(rated_matrix6)+length(rated_matrix7) length(rated_matrix)+length(rated_matrix2)+length(rated_matrix3)+length(rated_matrix4)+length(rated_matrix5)+length(rated_matrix6)+length(rated_matrix7)],[1 length(sorted_meantemp)],'k--','LineWidth',4)

% subplot(3,1,3);bar([mean(mean(rated_matrix)) mean(mean(rated_matrix2)) mean(mean(rated_matrix3)) mean(mean(rated_matrix4)) mean(mean(rated_matrix5)) mean(mean(rated_matrix6)) mean(mean(rated_matrix7))])

subplot(3,1,3);bar([length(find(rated_matrix>0.2))/length(rated_matrix) length(find(rated_matrix2>0.2))/length(rated_matrix2) length(find(rated_matrix3>0.2))/length(rated_matrix3) length(find(rated_matrix4>0.2))/length(rated_matrix4) length(find(rated_matrix5>0.2))/length(rated_matrix5) length(find(rated_matrix6>0.2))/length(rated_matrix6) length(find(rated_matrix7>0.2))/length(rated_matrix7)])


% figure;imagesc([raw_norm(baseline,:)' raw_norm(foodDrop,:)' raw_norm(foodInt,:)' raw_norm(Noteating,:)' raw_norm(Female,:)'  raw_norm(Interact,:)' raw_norm(NotInt,:)'])



