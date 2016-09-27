function ClassifyWave(fs_Ca,timeofStart,timeofEnd,firstCell,lastCell,DATA)
ui.Cl = figure('Visible','on','Position',[10,10,600,400],'Units','normalized');set(gcf,'Color','[1 1 1]')

ui.slider = uicontrol('Parent', ui.Cl ,'Style','slider','String','Sliding Window','Position',[150,330,60,20],'Min',0,'Max',1,'SliderStep',[0.1, 0.1],'Callback',@slide,'FontSize',12,'Units','normalized');
ui.celltext = uicontrol('Style',' edit','String','#cell','Position',[50,360,50,20],'value',1,'backgroundc',get(ui.Cl,'color'),'Units','normalized','FontSize',12);

% ui.slidercelltext1 = uicontrol('Style',' edit','String','Sharp','Position',[20,430,50,30],'value',0,'backgroundc',get(ui.Cl,'color'),'Units','normalized','FontSize',12);
% ui.slidercelltext2 = uicontrol('Style',' edit','String','Smooth','Position',[20,230,50,30],'value',0,'backgroundc',get(ui.Cl,'color'),'Units','normalized','FontSize',12);


ui.slider2 = uicontrol('Parent', ui.Cl ,'Style','slider','String','Sliding Window','Position',[20,300,100,50],'Min',0,'Max',10,'SliderStep',[0.1, 0.1],'Callback',@slide2,'FontSize',12,'Units','normalized');

uicontrol('Style','Text','String','Smoother','Position',[110,350,60,20],'backgroundc',get(ui.Cl,'color'),'FontSize',12,'Units','normalized');
uicontrol('Style','Text','String','Original','Position',[180,350,60,20],'backgroundc',get(ui.Cl,'color'),'FontSize',12,'Units','normalized');


% ui.cellenter=uicontrol('Parent', ui.Cl,'Style','pushbutton','String','Cell','Position',[15,510,50,30],'Callback',@cellenter,'FontSize',16,'Units','normalized');



ui.threshtxt = uicontrol('Style',' edit','String','0','Position',[250,330,40,20],'value',0,'backgroundc',get(ui.Cl,'color'),'Units','normalized','FontSize',12);
ui.widthtxt = uicontrol('Style',' edit','String','0','Position',[300,330,40,20],'value',0,'backgroundc',get(ui.Cl,'color'),'Units','normalized','FontSize',12);

uicontrol('Style','Text','String','Amp','Position',[250,350,40,20],'backgroundc',get(ui.Cl,'color'),'FontSize',12,'Units','normalized');
uicontrol('Style','Text','String','Width','Position',[300,350,40,20],'backgroundc',get(ui.Cl,'color'),'FontSize',12,'Units','normalized');

ui.rad(1)=uicontrol('style','rad','unit','pix','position',[350,350,100,20],'string','Events','backgroundc',get(ui.Cl,'color'),'Units','normalized','FontSize',12);
 ui.rad(2)=uicontrol('style','rad','unit','pix','position',[350,320,100,20],'string','Manual','backgroundc',get(ui.Cl,'color'),'Units','normalized','FontSize',12);

ui.thresh=uicontrol('Parent', ui.Cl,'Style','pushbutton','String','Threshold','Position',[440,320,120,50],'Callback',@thresh,'FontSize',16,'Units','normalized');
%%
  
  
data=DATA;
% data=DataRead(fs_Ca,timeofStart,timeofEnd,firstCell,lastCell);
% randcell=randi([firstCell lastCell]);

eventsmenu=menu('Events data','YES','NO');
if(eventsmenu==1)
     eventsdata=DataRead(fs_Ca,timeofStart,timeofEnd,firstCell,lastCell);
end
       
% figure(ui.Cl.Number);plot(data(:,randcell));
figure(ui.Cl.Number);subplot(412);plot(data(:,1));
set(ui.celltext,'str',num2str(1))



function slide2(hObject, eventdata)
     object_data=guidata(hObject);
     Min_slider=1
     Max_slider=lastCell-firstCell+1
    Step_slider=1/(Max_slider-Min_slider);  
    set(ui.slider2,'Min',Min_slider)
     set(ui.slider2,'Max',Max_slider)
    set(ui.slider2,'SliderStep',[Step_slider Step_slider])
     
    celln=round(get(ui.slider2,'val'))
    set(ui.celltext,'str',num2str(celln))
      object_data.cell=celln;
     guidata(hObject,object_data);
end

% function cellenter(hObject, eventdata)
%      object_data=guidata(hObject);
%     celln=str2double(get(ui.celltext,'str'))
%     object_data.cell=celln;
%      guidata(hObject,object_data);
%      
% end
function slide(hObject, eventdata)
     object_data=guidata(hObject);
      celln=round(object_data.cell)
%       ceelll=ceil(celln)
          Min_slider=0.0001;
     Max_slider=1;
     Step_slider=0.1;

     
     
     x=linspace(timeofStart,timeofEnd,length(data));
     
     
          set(ui.slider,'Min',Min_slider);
     set(ui.slider,'Max',Max_slider);
    set(ui.slider,'SliderStep',[Step_slider Step_slider]);
    
    slider_sample=(get(ui.slider,'val'))
    
    [b,a]=butter(2,slider_sample);
    filtered_data=filtfilt(b,a,data);
    
%     figure(ui.Cl.Number);subplot(211);plot(filtered_data(:,celln));
    figure(ui.Cl.Number);hh=subplot(412);findpeaks(filtered_data(:,celln),x,'Annotate','extents','WidthReference','halfheight');legend off
   if(eventsmenu==1)
    subplot(412);hold on;plot(x,eventsdata(:,celln),'r')
    hold off;
   end
   
% figure;findpeaks(dd,'MinPeakDistance',MinWidth,'MinPeakProminence',MinProminence)
    set(hh,'FontSize',15)
%     xlabel('seconds','FontSize',15);box off;ylabel('s.d mag','FontSize',14)
    [signal,peak,heights,width]=findpeaks(filtered_data(:,celln),x,'Annotate','extents','WidthReference','halfheight');
%     
      PPC=zeros(10,100);  
%     peaks=[signal,peak,heights,width];
    object_data.amp=signal;
    object_data.time=peak;
    object_data.heights=heights;
    object_data.width=width;
    object_data.filtered_data=filtered_data;
    object_data.x=x;
    object_data.PPC=PPC;
    guidata(hObject,object_data);
    
end


function thresh(hObject, eventdata)
     object_data=guidata(hObject);
     filtered_data=object_data.filtered_data;
     signal=object_data.amp;
     width=object_data.width;
     heights=object_data.heights;
      peaks=object_data.time;
     celln=object_data.cell;
     x=object_data.x;
     PPC=object_data.PPC;
     
    reference_events=get(ui.rad,'Value')
    
     MinProminence=str2double(get(ui.threshtxt,'str'));
    MinWidth=str2double(get(ui.widthtxt,'str'))
    
%     ind=find(signal>thresh_val);
%   ( [ signal(ind)  width(ind) peaks(ind)'  heights(ind)'])
  
dd=filtered_data(:,celln);

            figure(ui.Cl.Number);hh=subplot(412);findpeaks(dd,x,'MinPeakDistance',MinWidth,'MinPeakProminence',MinProminence);legend off
[pks,locs]=findpeaks(dd,x,'MinPeakDistance',MinWidth,'MinPeakProminence',MinProminence);
if(eventsmenu==1)
          subplot(412);hold on;plot(x,eventsdata(:,celln),'r')
    hold off;
end

%      figure(ui.Cl.Number);h=subplot(312);hold on;errorbar(celln,mean(width(ind)),std(width(ind)),'b');hold on;bar(celln,mean(width(ind)));
%      set(h,'FontSize',15);axis tight
                 xlabel('sec','FontSize',15);box off;ylabel('s.d','FontSize',16);
%          figure(ui.Cl.Number);subplot(313);hold on;bar(celln,length(peaks(ind)))
%           xlabel('cell#','FontSize',15);box off;ylabel('N of peaks','FontSize',16);
     
          MinWidth=MinWidth*fs_Ca;
      [peaks,locs]=findpeaks(dd,'MinPeakDistance',MinWidth,'MinPeakProminence',MinProminence);
if(length(locs)>0)
temp1=find(locs<=2*MinWidth);
temp2=find(length(dd)-locs<=2*MinWidth);

if(length(temp1)>0)
%     for i=1:length(temp1)
        locs(temp1)=[];
        peaks(temp1)=[];
%     end
end

if(length(temp2)>0)
%     for i=1:length(temp2)
        locs(temp2)=[];
        peaks(temp2)=[];
%     end
end
% 
% 
% if(length(dd)-locs(end)<2*MinWidth)
%     locs(end)=[];
%     peaks(end)=[];
% end
% 
% if(locs(1)<2*MinWidth)
%     locs(1)=[];
%     peaks(1)=[];
% end
% reference_events{2}

if(reference_events{2}==1)
    ref_locs=locs
elseif(reference_events{1}==1)
    
if(eventsmenu==1)
ref_locs=find(eventsdata(:,celln)>0)
else
    errordlg('Events data is not loaded!')
end
end

AUC=[];


for ii=1:length(ref_locs)
% ii=1
tempp=find(dd(ref_locs(ii)+1:end)<0);
AUC(ii)=sum(dd(ref_locs(ii):ref_locs(ii)+tempp(1)-1));

% t1=find(dd(ref_locs(ii)-MinWidth*2:ref_locs(ii))<0);
% t2=find(dd(ref_locs(ii):ref_locs(ii)+MinWidth*2)<0);
% 
% if(length(t1)==0)
% temp=min(dd(ref_locs(ii):ref_locs(ii)+MinWidth*2));
% t1=find((dd(ref_locs(ii):ref_locs(ii)+MinWidth*2)==min(dd(ref_locs(ii):ref_locs(ii)+MinWidth*2))));
% end
% 
% 
% if(length(t2)==0)
% temp=min(dd(ref_locs(ii):ref_locs(ii)+MinWidth*2));
% t2=find((dd(ref_locs(ii):ref_locs(ii)+MinWidth*2)==min(dd(ref_locs(ii):ref_locs(ii)+MinWidth*2))));
% end
%  
% t11=MinWidth*2-t1(end);
% t22=t2(1);
% len=t11+t22;
% 
% dd(ref_locs(ii)-t11:ref_locs(ii)+t22);
% AUC(ii)=mean(dd(ref_locs(ii)-t11:ref_locs(ii)+t22));
end

if(reference_events{2}==1)
PAUC=[peaks' AUC];
Peak2AUC=[peaks'./AUC];
elseif(reference_events{1}==1)
    peaks2=eventsdata(ref_locs,celln);
    AUC=AUC/fs_Ca;
    PAUC=[peaks2' AUC]
    Peak2AUC=[peaks2'./AUC]
end


if(length(AUC)<=0)
    AUC=0;
end


    if(mean(peaks2)>mean(AUC))
 figure(ui.Cl.Number);subplot(414);errorbar(celln,mean(peaks2),std(peaks2));hold on;bar(celln,mean(peaks2),'b');box off;
 errorbar(celln,mean(AUC),std(AUC));hold on;bar(celln,mean(AUC),'r');box off;
    else
      figure(ui.Cl.Number);subplot(414);errorbar(celln,mean(AUC),std(AUC));hold on;bar(celln,mean(AUC),'r');box off;   
      errorbar(celln,mean(peaks2),std(peaks2));hold on;bar(celln,mean(peaks2),'b');box off;
    end
 axis tight; xlabel('cell#','FontSize',15);box off;ylabel('AUC(sdXsec)','FontSize',16);
 
 figure(ui.Cl.Number);subplot(413);hold on;bar(celln,length(peaks2))
%  errorbar(celln,mean(Peak2AUC),std(Peak2AUC));hold on;bar(celln,mean(Peak2AUC),'b');box off;
 
% pause(1)   

tempp=find(diff(ref_locs)<MinWidth*fs_Ca*4);

%  figure(ui.Cl.Number);subplot(313);hold on;bar(celln,length(ref_locs))
%            figure(ui.Cl.Number);subplot(313);hold on;bar(celln,length(tempp),'r')
%            xlabel('cell#','FontSize',15);box off;ylabel('N of peaks (and bursts)','FontSize',16);
    
%  PPC(1:length(PAUC),celln)=PAUC
  
%          
%          figure;bar(mean(
% save('outputs.txt','-ascii','PAUC')

end
     
end
end