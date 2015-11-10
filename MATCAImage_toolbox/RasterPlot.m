%%normalization of data Ca Events (0-1 within the channel)
function data2= RasterPlot(threshold,fs,time1,time2,var1,var2,bw,gaussorder)

% sampling_rate=5;
% 
% %   data_dir=uigetdir('','Locate the data directory');
%   
%   userSel1=char(inputdlg('Would you like to use Raw Ca2+ or Event data? (C or E)')); 
%   if(userSel1=='C')
%       [dir data_dir]=uigetfile('*.','Load the Ca transients','.*');
%       raw_transients=struct2array(load([data_dir dir]));
%       raw_transients=raw_transients(:,2:end);
%         peak_threshold=str2num(char(inputdlg('Enter the peak threshold:')));
%         raw_trans=raw_transients;
%         for ll=1:min(size(raw_transients)) 
%         raw_trans(find(raw_trans(:,ll)<peak_threshold),ll)=0;
% %         temp=find(diff(raw_trans(:,ll))>0);                           %to
% %           take only 
% %         temp2=temp(find(diff(find(diff(raw_trans(:,ll))>0))>1));
% %         temp2=temp2+1;
% %         raw_trans(:,ll)=0;raw_trans(temp2,ll)=raw_transients(temp2,ll);
%         end
% %         figure;plot(raw_trans)     
%         Events=raw_trans;
%   else
%       
%  [dir data_dir]=uigetfile('*.','Load the Events','.*');
%   raw_events=struct2array(load([data_dir dir]));
% %   raw_transients=load([data_dir2 dir2]);
%   Nevents=min(size(raw_events))-1;
%   events=raw_events(:,2:end);
% %   raw_transients=raw_transients(:,2:end);
% %  [dir2 data_dir2]=uigetfile('*.','Load the Ca SD File','.*');
% Events=events;
%   end

newdata=dataread(fs,time1,time2,var1,var2);
figure(100);clf;subplot(411);pcolor(newdata');shading flat;colormap parula;set(gcf,'Color',[1 1 1]);colorbar
xlabel('time (sample)','FontSize',16),ylabel('cell','FontSize',16);axis tight
set(gca,'FontSize',16)
title(['(' num2str(min(size(newdata))) ') cells in time'],'FontSize',16)


if(exist('threshold')) %#ok<EXIST>
        for ll=1:min(size(newdata)) 
        newdata(find(newdata(:,ll)<threshold),ll)=0;
        end
end


normraw=[];
for i=1:min(size(newdata))
normraw(:,i)=newdata(:,i)./max(newdata(:,i));
end
normraw(find(isnan(normraw)))=0;
norm_raw2=normraw; % Arrange it in the channel order.
%raster
% figure;imagesc(normraw');
figure(100);subplot(412);

for i=1:min(size(normraw))
   temp=find(normraw(:,i)>0);
   if(temp>0)
       for ii=1:size(temp)
        line([temp(ii) temp(ii)],[i-1 i],'LineWidth',2);
       end
   end
end
xlabel('time (samples)','FontSize',16),ylabel('cell','FontSize',16)
set(gca,'FontSize',16);axis tight
title('Raster ','FontSize',16)


binned_signal=[];
normraw=normraw';
if(size(bw)>0)
    binn=fs*bw;
    for t=1:min(size(normraw))
        for tt=1:(max(size(normraw))/binn)
        binned_signal(t,tt)=sum(normraw(t,(tt-1)*binn+1:binn*tt));
        end
    end
    
else
    binn=fs;
        for t=1:min(size(normraw))
        for tt=1:(max(size(normraw))/binn)
        binned_signal(t,tt)=sum(normraw(t,(tt-1)*binn+1:binn*tt));
        end
        end
end

figure(100);subplot(413);stairs(sum(binned_signal),'Color','r','LineWidth',2);box off;
xlabel('bin(samples)','FontSize',16),ylabel('N of active cells','FontSize',16)
set(gca,'FontSize',16);axis tight
title(['PETH bin size= ' num2str(binn) 'samples'],'FontSize',16)


[xycell_file xycell_dir]=uigetfile('.*','Load your cell coordinates')

if(size(xycell_dir)>0)
    if(size(gaussorder)>0)
        order=gaussorder;
    else
        order=5;
    end
xy_cell=load([xycell_dir xycell_file]);
xy_cell=struct2array(xy_cell);

size(binned_signal)
Activecells=sum(binned_signal');
pop_map=[];
length(Activecells)
    for ii=1:length(Activecells);
        X=xy_cell(ii,1);Y=xy_cell(ii,2);
        pop_map(X:X+10,Y:Y+10)=Activecells(ii);
    end

% h=ones(10,10)/20;
smoothMap=imgaussfilt(pop_map,order);% 
% FilteredMapA= imnoise(pop_map,'Gaussian',0.9,0.9);
% h = fspecial('motion', 10, 10);
% FilteredMapA = imfilter(pop_map,h);
figure(100);subplot(414);pcolor(smoothMap);shading flat;colormap jet(100);
set(gca,'FontSize',16);axis tight;xlabel('pix','FontSize',16);ylabel('pix','FontSize',16);
end


% size(binned_signal)
%%binning sum



% 
% for i=1:min(size(newdata))
% normraw2(:,i)=normraw(:,i)+i-1;
% end
% figure;subplot(411);plot(normraw);axis tight;box off
% subplot(412);plot(normraw2);axis tight;box off;set(gcf,'Color','w')
% ylabel('Cells#','FontSize',15)

  
% 
% 
% % des_cells=[1 33 12 23]
%   userSel2=char(inputdlg('Would you like to apply temporal binnig for the PSTH?: (y/n)'));
%   if(userSel2=='y')
%       bin_ent=str2num(char(inputdlg('Enter the binning size (e.g. 0.2 is absolute matching)' )));
%   else
%       bin_ent=sampling_rate*5;
%   end
%         
%     bin=sampling_rate*bin_ent;
% 
% for i=1:min(size(Events))
% normraw(:,i)=Events(:,i)./max(Events(:,i));
% end
% normraw(find(isnan(normraw)))=0;
% norm_raw2=normraw; % Arrange it in the channel order.
% for i=1:min(size(Events))
% normraw2(:,i)=normraw(:,i)+i-1;
% end
% figure;subplot(411);plot(normraw);axis tight;box off
% subplot(412);plot(normraw2);axis tight;box off;set(gcf,'Color','w')
% ylabel('Cells#','FontSize',15)
% % figure;imagesc(corrcoef(normraw2(1:1000,:)));caxis([0 0.3]);colormap jet
% % corrcoefX=corrcoef(normraw2(1:1000,:));
% 
% des_cells=str2num(char(inputdlg('Enter any cell# like to focus:')));
% if(length(des_cells)==0)
%     des_cells=randi(min(size(Events)),[1 5]);
% end
% 
% for i=1:length(des_cells)
% normraw3(:,i)=normraw(:,des_cells(i))+i-1;
% end
% subplot(413);plot(normraw3);axis tight;box off
% ylabel(['Cells#'  '    ' num2str(des_cells)])
% 
% % psth_normraw=[];
% psth=[];
% sumnormraw=sum(normraw');

% subplot(414);bar(psth);axis tight;box off
% ylabel('#Events')
% xlabel([num2str(bin_ent) '  ' 'seconds binning'],'FontSize',20)



%  msgbox('Calcium and Behavior Data size Mismatch!, Check the match data box','Error Check','Error');
end