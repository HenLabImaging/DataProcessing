function CalciumBehaviorPair(fs_Ca,fs_video,time1,time2,var1,var2,var3,var4,DATA)


ui.fh = figure('Visible','on','Position',[10,10,1000,600],'Units','normalized');
set(gcf,'Color','[1 1 1]')
ui.data = uicontrol('Parent', ui.fh ,'Style','pushbutton','string',['Load behavior'],'Position',[50,10,140,50],'Callback',@load,'FontSize',16,'Units','normalized');
ui.datatype = uicontrol('Parent', ui.fh ,'Style','pop','Position',[800,20,200,30],'backgroundc',get(ui.fh,'color'),'fontsize',16,'fontweight','bold','string',{'Raw transient';'Normalized';'v-Kernel'},'value',1,'Callback',@datatype,'Units','normalized');

ui.text_slidermin = uicontrol('Style',' edit','String','0','Position',[200,10,30,20],'backgroundc',get(ui.fh,'color'),'Units','normalized','FontSize',12);
ui.text_slidermax = uicontrol('Style',' edit','String',' ','Position',[720,10,30,20],'backgroundc',get(ui.fh,'color'),'Units','normalized','FontSize',12);
uicontrol('Style','Text','String','Samples ','Position',[450,10,80,20],'backgroundc',get(ui.fh,'color'),'FontSize',14,'Units','normalized');

ui.figtype = uicontrol('Parent', ui.fh ,'Style','pop','Position',[900,500,200,100],'backgroundc',get(ui.fh,'color'),'fontsize',16,'fontweight','bold','string',{'HeatMAp';'Raster'},'value',1,'Units','normalized');


ui.slider = uicontrol('Parent', ui.fh ,'Style','slider','String','Sliding Window','Position',[200,20,550,30],'Min',0,'Max',100,'SliderStep',[0.1, 0.1],'Callback',@slide,'FontSize',16,'Units','normalized');
ui.slider2 = uicontrol('Parent', ui.fh ,'Style','slider','String','Sliding Window','Position',[5,30,30,100],'Min',0,'Max',10,'SliderStep',[0.1, 0.1],'Callback',@slide2,'FontSize',16,'Units','normalized');
ui.text_slider2 = uicontrol('Style',' edit','String','0','Position',[15,140,30,30],'value',0,'backgroundc',get(ui.fh,'color'),'Units','normalized','FontSize',12);

% set(ui.text_slider2 ,'str',num2str(activation_threshold));
% ui.r1 = uicontrol('Style',' edit','String','r1','Position',[400,300,50,20],'backgroundc',get(ui.fh,'color'),'Units','normalized','FontSize',12);



function load(hObject, eventdata)

    object_data=guidata(hObject);
    fs=fs_Ca;
    [beh dir]=uigetfile('.*','Enter behavior data');
    [pathdata,namedata,format]=fileparts(beh);
    switch format
    case '.xlsx'
        beh=xlsread([dir beh]);   
    case '.xls'
        beh=xlsread([dir beh]); 
        
    case '.txt'
        beh=load([dir beh]);
    case '.csv'
        beh=csvread([dir beh],1,0);
    case '.mat'
          beh=load([dir beh]);
    end
    
%     beh=xlsread([dir beh]);
    xxyy=beh(:,[var3 var4]);   
    figure(ui.fh.Number);subplot(2,10,1:3);hold on;plot(xxyy(:,1),xxyy(:,2),'b.')
        
%     newdata=DataRead(fs,time1,time2,var1,var2);
    newdata=DATA;
     bw=str2num(char(inputdlg('Enter bin width:')));
    bw=bw*fs_Ca;
    
     sampling_conv_ratio=round(fs_video/fs_Ca);
     xxyy=downsample(xxyy,sampling_conv_ratio);
     


    imageselect=menu('Image File','YES','NO')
    
    if(imageselect==1)
    
     [imagefile,image_dir]=uigetfile('.*','Load your image file')
   [pathdata,namedata,format]=fileparts(imagefile);
    
   comb_cell=imread([image_dir imagefile]);
   imagepath=char(inputdlg(['Is file tag without a number ending is true?:' ' '  namedata]));
   if(isempty(imagepath))
       imagepath=namedata;
   end
   
   for i=1:min(size(newdata))
        cell=imread([image_dir imagepath num2str(i) format]);
        comb_cell=imadd(comb_cell,cell);
   end
    comb_cell(find(comb_cell>0))=5;
    figure(ui.fh.Number);subplot(2,10,11:13);imagesc(comb_cell)
    
           object_data.imagedir=image_dir;
        object_data.imagepath=imagepath;
        object_data.format=format;
            object_data.combcell=comb_cell;
%             object_data.imagesize=size(cell);
        
    end
   
        object_data.xxyy=xxyy;
       object_data.imageselect=imageselect;
    
%     object_data.imagefile=imagefile;
    object_data.rawdata=newdata;
    object_data.bw=bw;
     object_data.activation_threshold=0;  
    guidata(hObject,object_data);
    
    
end

function datatype(hObject, eventdata)
    object_data=guidata(hObject);
    rawdata=object_data.rawdata;
    dataformat=get(ui.datatype,'val');
    if(dataformat==2)
        norm_transients=rawdata;
        for i=1:min(size(rawdata))
        mincell=abs(min(rawdata(:,i)));
        maxcell=abs(max(rawdata(:,i)));
            if(maxcell>mincell)
            ref_baseline=maxcell;
             else
            ref_baseline=mincell;
            end 
        % norm_transients(:,i)=norm_transients(:,i)/mean(norm_transients(:,i));
            norm_transients(:,i)=norm_transients(:,i)/ref_baseline;
% norm_transients(:,i)=norm_transients(:,i)./abs(min(norm_transients(:,i)));
        end
        rawdata=norm_transients;

%         
    elseif(dataformat==3)
            fs=fs_Ca;
            msgbox('Enter event data')
            events=DataRead(fs,time1,time2,var1,var2);
            kernel_trans=Conv_Kernel(rawdata,events);    
             kernel_trans(isnan(kernel_trans))=0;
            rawdata=kernel_trans;
           
    end
             
    object_data.rawdata=rawdata;
    guidata(hObject,object_data);
end

function slide2(hObject, eventdata)
    object_data=guidata(hObject);
      activation_threshold=object_data.activation_threshold;
        step_slider2=0.001;
    set(ui.slider2,'SliderStep',[step_slider2 step_slider2])
    activation_threshold=(get(ui.slider2,'val'));
      object_data.activation_threshold=activation_threshold;
      
      set(ui.text_slider2 ,'str',num2str(activation_threshold));
      
    guidata(hObject,object_data);
end

function slide(hObject, eventdata)

     object_data=guidata(hObject);
     xxyy=object_data.xxyy;
     activation_threshold=object_data.activation_threshold;
     xx_max=max([abs(max(xxyy(:,1))) abs(min(xxyy(:,1)))]);
         yy_max=max([abs(max(xxyy(:,2))) abs(min(xxyy(:,2)))]);

     
     imageselect=object_data.imageselect;
         if(imageselect==1)
            comb_cell=object_data.combcell;
            image_dir=object_data.imagedir;
            imagepath=object_data.imagepath;
            format=object_data.format;
%             imagesize=object_data.imagesize;
              cell=zeros(size(comb_cell));      %preallocation

         end
     
%     figure;imagesc(comb_cell)
     rawdata=object_data.rawdata;
     bw=object_data.bw;
%      size(rawdata)
     Min_slider=time1*fs_Ca;
     Max_slider=time2*fs_Ca;
     Step_slider=1/(Max_slider-Min_slider);
     
     set(ui.text_slidermin,'str',num2str(Min_slider))
     set(ui.text_slidermax,'str',num2str(Max_slider))
     
     set(ui.slider,'Min',Min_slider)
     set(ui.slider,'Max',Max_slider)
    set(ui.slider,'SliderStep',[Step_slider Step_slider])
    


%      figure(ui.fh.Number);subplot(131);plot(xxyy(:,1),xxyy(:,2),'o')
     
    slider_sample=round(get(ui.slider,'val'));
    tic
     activecells=find(mean(rawdata(slider_sample:slider_sample+bw,:))>activation_threshold);
    if(imageselect==1) 
    for kk=1:length(activecells)
        cell=imread([image_dir imagepath num2str(activecells(kk)) format]);
        comb_cell=imadd(comb_cell,cell);
    end
%         comb_cell(find(comb_cell)>5)=20;
    end
    toc
%     whos
       rawdata(isnan(rawdata))=0;
     figtype=get(ui.figtype,'val');

    figure(ui.fh.Number); subplot(2,10,1:3);plot(xxyy(slider_sample:slider_sample+bw,1),xxyy(slider_sample:slider_sample+bw,2),'rx','MarkerSize',12);axis tight;axis off;
    if(figtype==2)
    figure(ui.fh.Number); subplot(2,10,4:10);spy(rawdata(slider_sample:slider_sample+bw,:)');axis normal;box off;
    else
       figure(ui.fh.Number); subplot(2,10,4:10);pcolor(rawdata(slider_sample:slider_sample+bw,:)');box off;shading flat;colormap jet(20);colorbar
        xlabel(['samples' ,'( fs =' num2str(fs_Ca) 'Hz)'],'FontSize',16)
    end
    ylabel('Cell','FontSize',16)
    title(['Analyzing Time: ' num2str(slider_sample/fs_Ca) '-' num2str((slider_sample+bw)/fs_Ca ) 'sec'],'FontSize',16);axis on
     if(imageselect==1)
        figure(ui.fh.Number); subplot(2,10,11:13);imagesc(comb_cell);shading flat;colormap jet(20)
%         comb_cell(find(comb_cell)>0)=5;
     end
       
     
             
        f = linspace(0,length(slider_sample:slider_sample+bw),length(slider_sample:slider_sample+bw));
        xshade = [f,fliplr(f)];
        coh   = rawdata(slider_sample:slider_sample+bw,:)';
        meanC1 = mean(coh);
        stdC1=std(coh)/sqrt(min(size(rawdata)));
%         figure;
         figure(ui.fh.Number); subplot(2,10,14:20);axis on
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
        fill(xshade,yshade,[0.95,0.95,0.95],'EdgeColor',[0.85,0.65,0.95]);axis tight;
%         axis([0 length(slider_sample:slider_sample+bw) -0.5 0.5])
%         axis([0 length(slider_sample:slider_sample+bw) min(min(rawdata(slider_sample:slider_sample+bw,:)')) max(max(rawdata(slider_sample:slider_sample+bw,:)'))])
        hold on;box off;
         plot(f,meanC1,'b','LineWidth',2); %mean value
%         figure(ui.fh.Number); subplot(2,10,14:20);plot(xxyy(slider_sample:slider_sample+bw,1)./xx_max*(maxmeanC1),'k:');axis tight
%         figure(ui.fh.Number); subplot(2,10,14:20);plot(xxyy(slider_sample:slider_sample+bw,2)./yy_max*(maxmeanC1),'r:');axis tight
        figure(ui.fh.Number); subplot(2,10,14:20);stairs(xxyy(slider_sample:slider_sample+bw,1),'k.-');axis tight
                figure(ui.fh.Number); subplot(2,10,14:20);stairs(xxyy(slider_sample:slider_sample+bw,2),'r.-');axis tight

%         set(ui.r1,'str',num2str(r1))
        
       
       legend('sd','mean','beh');

        r1=corrcoef(xxyy(slider_sample:slider_sample+bw,1),meanC1); %beh correlation output
        r2=corrcoef(xxyy(slider_sample:slider_sample+bw,2),meanC1);
        text(bw/2-12,maxmeanC1 ,'r1= ','FontSize',14);text(bw/2-10,maxmeanC1 ,num2str(r1(1,2)),'FontSize',14);
        text(bw/2+8,maxmeanC1 ,'r2= ','FontSize',14);text(bw/2+10,maxmeanC1 ,num2str(r2(1,2)),'FontSize',14);
       
        hold off
        pause(5)
        
         figure(ui.fh.Number); subplot(2,10,1:3);plot(xxyy(slider_sample:slider_sample+bw,1),xxyy(slider_sample:slider_sample+bw,2),'bx','MarkerSize',8);axis tight;axis off;
        
         
%    plot(mean(rawdata(slider_sample:slider_sample+bw,:)'));
end

end