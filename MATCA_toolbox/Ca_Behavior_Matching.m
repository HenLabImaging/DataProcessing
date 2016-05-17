function Ca_Behavior_Matching(fs_Ca,fs_video,time1,time2,var1,var2,behinputs,behdata,DATA)

beh=behinputs;
xxyy=behdata;

if nargin < 1; errordlg('Select data'); end;
if nargin < 2;errordlg('Sampling frequency required');end
% if(isempty(time1)||isempty(time2))
%     time1=round(DATA(1,1));
%     time2=round(length(DATA)/fs);
% end
% 
% if(isempty(var1)||isempty(var2))
%    Nevents=min(size(DATA))-1;
%    DATA(:,1)=[];
% else
%     Nevents=var2-var1+1;
% end



ui.fh = figure('Visible','on','Position',[10,10,1000,600],'Units','normalized');
set(gcf,'Color','[1 1 1]')
% ui.data = uicontrol('Parent', ui.fh ,'Style','pushbutton','string',['Load behavior'],'Position',[50,10,140,50],'Callback',@load,'FontSize',16,'Units','normalized');
ui.datatype = uicontrol('Parent', ui.fh ,'Style','pop','Position',[800,20,200,30],'backgroundc',get(ui.fh,'color'),'fontsize',14,'fontweight','bold','string',{'Raw transient';'Normalized';'v-Kernel'},'value',1,'Callback',@datatype,'Units','normalized');
ui.text_slidermin = uicontrol('Style',' edit','String','0','Position',[200,10,30,20],'backgroundc',get(ui.fh,'color'),'Units','normalized','FontSize',12);
ui.text_slidermax = uicontrol('Style',' edit','String',' ','Position',[720,10,30,20],'backgroundc',get(ui.fh,'color'),'Units','normalized','FontSize',12);
uicontrol('Style','Text','String','Samples ','Position',[450,10,80,20],'backgroundc',get(ui.fh,'color'),'FontSize',14,'Units','normalized');
ui.figtype = uicontrol('Parent', ui.fh ,'Style','pop','Position',[800,50,200,30],'backgroundc',get(ui.fh,'color'),'fontsize',14,'fontweight','bold','string',{'HeatMAp';'Raster'},'value',1,'Units','normalized');


ui.slider = uicontrol('Parent', ui.fh ,'Style','slider','String','Sliding Window','Position',[200,20,550,30],'Min',0,'Max',100,'SliderStep',[0.1, 0.1],'Callback',@slide,'FontSize',16,'Units','normalized');
% ui.slider2 = uicontrol('Parent', ui.fh ,'Style','slider','String','Sliding Window','Position',[5,30,30,100],'Min',0,'Max',10,'SliderStep',[0.1, 0.1],'Callback',@slide2,'FontSize',16,'Units','normalized');
% ui.text_slider2 = uicontrol('Style',' edit','String','0','Position',[15,140,30,30],'value',0,'backgroundc',get(ui.fh,'color'),'Units','normalized','FontSize',12);


 newdata=DATA(:,var1:var2);
 Nevents=var2-var1+1;
 bw=str2num(char(inputdlg('Enter the length of running time window (sec):')));
 bw=bw*fs_Ca;
 t=linspace(time1,time2,length(newdata));  
 
 sampling_conv_ratio=round(fs_video/fs_Ca);
 xxyy=downsample(xxyy,sampling_conv_ratio);
 figtype=get(ui.figtype,'val');
  
   if(figtype==2)
    figure(ui.fh.Number); subplot(3,10,1:10);spy(newdata(1:bw,:)');axis normal;box off;
    else
       figure(ui.fh.Number); subplot(3,10,1:10);pcolor(newdata(1:bw,:)');box off;shading flat;colormap jet(20);colorbar
        xlabel(['samples' ,'( fs =' num2str(fs_Ca) 'Hz)'],'FontSize',16)
   end 
    
       figure(ui.fh.Number); subplot(3,10,21:30);stairs(xxyy(1:bw,beh),'.-');axis tight;box off;legend on;
%        ll=length(beh);
%         for i=1:ll
%        legend(['Beh - ' ' ' num2str(beh(ll))]);hold on
%         end
%      



function slide(hObject, eventdata)

     object_data=guidata(hObject);
%      xxyy=object_data.xxyy;
%      activation_threshold=object_data.activation_threshold;
     xx_max=max([abs(max(xxyy(:,1))) abs(min(xxyy(:,1)))]);
     yy_max=max([abs(max(xxyy(:,2))) abs(min(xxyy(:,2)))]);

     
%      imageselect=object_data.imageselect;
%          if(imageselect==1)
%             comb_cell=object_data.combcell;
%             image_dir=object_data.imagedir;
%             imagepath=object_data.imagepath;
%             format=object_data.format;
% %             imagesize=object_data.imagesize;
%               cell=zeros(size(comb_cell));      %preallocation
% 
%          end
     
%     figure;imagesc(comb_cell)
%      rawdata=object_data.rawdata;
    rawdata=newdata;
%      bw=object_data.bw;
%      size(rawdata)
     Min_slider=time1*fs_Ca;
     Max_slider=time2*fs_Ca;
     Step_slider=1/(Max_slider-Min_slider);
     
     set(ui.text_slidermin,'str',num2str(Min_slider))
     set(ui.text_slidermax,'str',num2str(Max_slider))
     
     set(ui.slider,'Min',Min_slider)
     set(ui.slider,'Max',Max_slider)
    set(ui.slider,'SliderStep',[Step_slider Step_slider])
        
    
        slider_sample=round(get(ui.slider,'val'));
%     tic
%      activecells=find(mean(rawdata(slider_sample:slider_sample+bw,:))>activation_threshold);
%     if(imageselect==1) 
%     for kk=1:length(activecells)
%         cell=imread([image_dir imagepath num2str(activecells(kk)) format]);
%         comb_cell=imadd(comb_cell,cell);
%     end
%         comb_cell(find(comb_cell)>5)=20;
%     end
%     toc
%     whos
       rawdata(isnan(rawdata))=0;
     figtype=get(ui.figtype,'val');

%     figure(ui.fh.Number); subplot(2,10,1:3);plot(xxyy(slider_sample:slider_sample+bw,beh),xxyy(slider_sample:slider_sample+bw,beh),'rx','MarkerSize',12);axis tight;axis off;
    if(figtype==2)
    figure(ui.fh.Number); subplot(3,10,1:10);spy(rawdata(slider_sample:slider_sample+bw,:)');axis normal;box off;
    else
       figure(ui.fh.Number); subplot(3,10,1:10);imagesc(t(slider_sample:slider_sample+bw),Nevents,rawdata(slider_sample:slider_sample+bw,:)');box off;shading flat;colormap jet(20);colorbar
        
    end
        xlabel('seconds','FontSize',16);ylabel('Cell','FontSize',16);
        
        f = linspace(0,length(slider_sample:slider_sample+bw),length(slider_sample:slider_sample+bw));
        xshade = [f,fliplr(f)];
%         norm_max=max(mean(xxyy(:,beh)));
        
        coh   = rawdata(slider_sample:slider_sample+bw,:)';
        meanC1 = mean(coh);
        stdC1=std(coh)/sqrt(min(size(rawdata)));
%         figure;
         figure(ui.fh.Number); subplot(3,10,11:20);axis on
        y1 = (meanC1  + stdC1);
        y2 = (meanC1  - stdC1);
        %moving average filter
        [bb,aa]=butter(2,0.5);
        y1=filtfilt(bb,aa,y1);
        y2=filtfilt(bb,aa,y2);
        meanC1=filtfilt(bb,aa,meanC1);
        maxmeanC1=max([y1 y2]);
        %
        yshade = [y1,fliplr(y2)]; %sd or sem values
        fill(xshade,yshade,[0.95,0.95,0.95],'EdgeColor',[0.85,0.65,0.95]);axis tight;axis off
         hold on;box off;
         plot(f,meanC1,'b','LineWidth',2); %mean value
         hold off;legend('+- Pop Activity')   
            figure(ui.fh.Number); subplot(3,10,21:30);stairs(xxyy(slider_sample:slider_sample+bw,beh(:)),'.-');axis tight;box off;legend on
%                 figure(ui.fh.Number); subplot(2,10,14:20);stairs(xxyy(slider_sample:slider_sample+bw,2),'r.-');axis tight
            
        hold off
        ss='Ca2+ data' ;
        for i=1:length(beh)
         tt{i}=['beh' num2str(i)];
        end
       
%        ss=[ss tt]
        legend(tt);


end
    
    
    
    
    
end