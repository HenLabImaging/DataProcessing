%%normalization of data Ca Events (0-1 within the channel)
function RasterPlot
sampling_rate=5;

%   data_dir=uigetdir('','Locate the data directory');
  
  userSel1=char(inputdlg('Would you like to use Raw Ca2+ or Event data? (C or E)')); 
  if(userSel1=='C')
      [dir data_dir]=uigetfile('*.','Load the Ca transients','.*');
      raw_transients=struct2array(load([data_dir dir]));
      raw_transients=raw_transients(:,2:end);
        peak_threshold=str2num(char(inputdlg('Enter the peak threshold:')));
        raw_trans=raw_transients;
        for ll=1:min(size(raw_transients)) 
        raw_trans(find(raw_trans(:,ll)<peak_threshold),ll)=0;
%         temp=find(diff(raw_trans(:,ll))>0);                           %to
%           take only 
%         temp2=temp(find(diff(find(diff(raw_trans(:,ll))>0))>1));
%         temp2=temp2+1;
%         raw_trans(:,ll)=0;raw_trans(temp2,ll)=raw_transients(temp2,ll);
        end
%         figure;plot(raw_trans)     
        Events=raw_trans;
  else
      
 [dir data_dir]=uigetfile('*.','Load the Events','.*');
  raw_events=struct2array(load([data_dir dir]));
%   raw_transients=load([data_dir2 dir2]);
  Nevents=min(size(raw_events))-1;
  events=raw_events(:,2:end);
%   raw_transients=raw_transients(:,2:end);
%  [dir2 data_dir2]=uigetfile('*.','Load the Ca SD File','.*');
Events=events;
  end
 
  


% des_cells=[1 33 12 23]
  userSel2=char(inputdlg('Would you like to apply temporal binnig for the PSTH?: (y/n)'));
  if(userSel2=='y')
      bin_ent=str2num(char(inputdlg('Enter the binning size (e.g. 0.2 is absolute matching)' )));
  else
      bin_ent=sampling_rate*5;
  end
        
    bin=sampling_rate*bin_ent;

for i=1:min(size(Events))
normraw(:,i)=Events(:,i)./max(Events(:,i));
end
normraw(find(isnan(normraw)))=0;
norm_raw2=normraw; % Arrange it in the channel order.
for i=1:min(size(Events))
normraw2(:,i)=normraw(:,i)+i-1;
end
figure;subplot(411);plot(normraw);axis tight;box off
subplot(412);plot(normraw2);axis tight;box off;set(gcf,'Color','w')
ylabel('Cells#','FontSize',15)
% figure;imagesc(corrcoef(normraw2(1:1000,:)));caxis([0 0.3]);colormap jet
% corrcoefX=corrcoef(normraw2(1:1000,:));

des_cells=str2num(char(inputdlg('Enter any cell# like to focus:')));
if(length(des_cells)==0)
    des_cells=randi(min(size(Events)),[1 5]);
end

for i=1:length(des_cells)
normraw3(:,i)=normraw(:,des_cells(i))+i-1;
end
subplot(413);plot(normraw3);axis tight;box off
ylabel(['Cells#'  '    ' num2str(des_cells)])

% psth_normraw=[];
psth=[];
sumnormraw=sum(normraw');
for i=1:round(length(normraw)/bin)
    psth(i)=sum(sumnormraw((i-1)*bin+1:i*bin));
end
subplot(414);bar(psth);axis tight;box off
ylabel('#Events')
xlabel([num2str(bin_ent) '  ' 'seconds binning'],'FontSize',20)



%  msgbox('Calcium and Behavior Data size Mismatch!, Check the match data box','Error Check','Error');
end