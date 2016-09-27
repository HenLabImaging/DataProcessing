function CountEvents(fs,time1,time2,var1,var2,DATA)
menuselect=menu('Select datasets would you like to analyze?','Event','Event+Transients')
dur=time2-time1;
if nargin < 1;errordlg('Select data'); end;
if nargin < 2;errordlg('Sampling frequency required');end
if(isempty(time1)||isempty(time2))
    time1=round(DATA(1,1));
    time2=round(length(DATA)/fs);
end

if(isempty(var1)||isempty(var2))
   Nevents=min(size(DATA))-1;
   DATA(:,1)=[];
else
    Nevents=var2-var1+1;
end


Active_cells=zeros(1,Nevents);

if(menuselect==1)
    for i=1:Nevents    
    Active_cells(i)=length(find(DATA(:,i)>0))/dur;
    end  
else
    thresh=str2num(char(inputdlg('Enter a peak threshold:')));
   for i=1:Nevents 
    Active_cells(i)=length(DATA(find(DATA(:,i)>thresh),i))/dur;
   end
end
    figure;subplot(211);bar(Active_cells,'r','LineWidth',2); xlabel('cell','FontSize',16);ylabel('Events/sec','FontSize',16);box off;set(gcf,'Color',[1 1 1])
%         size(Active_cells)

%         edges=[0:length(Active_cells)]/length(Active_cells);
        subplot(212);histfit(Active_cells',10,'rayleigh'); xlabel('Events/sec','FontSize',16);ylabel('N of cells','FontSize',16);box off
        histc(Active_cells,0:10);
   
savein=char(inputdlg('Would you like to save the output? : (y/n)'));
if(savein == 'y')
    savedir=uigetdir('Show the saving directory');
    savetag=char(inputdlg('Enter a filename'));
        xlswrite([savedir '/' savetag],Active_cells');
end

end
