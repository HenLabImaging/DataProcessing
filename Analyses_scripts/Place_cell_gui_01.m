function Place_cell_gui_01
Place.fh = figure('Visible','on','Position',[20,20,1500,1000],'Units','normalized');
set(gcf,'Name','PlaceCellAnalysis v0.1','Color',[0.98 0.98 0.99],'NumberTitle','off')
uicontrol('Style','Text','String','Input Parameters','Position',[110,880,200,25],'backgroundc',get(Place.fh,'color'),'FontSize',16,'Units','normalized');

 Place.sampling  = uicontrol('Style',' edit','String','Ca2+ Fs (Hz)','Position',[20,850,100,25],'Units','normalized','FontSize',12);
 Place.sampling2 = uicontrol('Style',' edit','String','Video Fs (Hz)','Position',[130,850,100,25],'Units','normalized','FontSize',12);
 Place.imaging_per = uicontrol('Style',' edit','String','Imaging (min)','Position',[240,850,100,25],'Units','normalized','FontSize',12);
%          Place.contexts=uicontrol('style','list','String',{'1'; '2'; '3'; '4'},'Position',[280,825,30,50]);
 Place.parameters=uicontrol('style','edit','Position',[20,920,1400,80],'background','w','HorizontalAlign','left','FontSize',18,'min',0,'max',2,'Units','normalized');
Place.enterinputs=uicontrol('Parent', Place.fh,'Style','pushbutton','String','Load Data','Position',[620,840,100,50],'Callback',@enterinputs,'FontSize',16,'Units','normalized');
% Construct the components
% uicontrol('Style','Text','String','Activity Monitoring','Position',[50,950,900,25],'FontSize',16,'Units','normalized');


Place.ctx(1) = uicontrol('style','rad','unit','pix','position',[350 850 80 30],'string','  Context 1','backgroundc',get(Place.fh,'color'),'Units','normalized','FontSize',10);
Place.ctx(2) = uicontrol('style','rad','unit','pix','position',[430 850 80 30],'string','  Context 2','backgroundc',get(Place.fh,'color'),'Units','normalized','FontSize',10);
Place.ctx(3) = uicontrol('style','rad','unit','pix','position',[510 850 80 30],'string','  Context 3','backgroundc',get(Place.fh,'color'),'Units','normalized','FontSize',10);

Place.data = uicontrol('Parent', Place.fh ,'Style','pushbutton','String','Enter ','Position',[420,760,100,40],'Callback',@loaddata,'FontSize',16,'Units','normalized');

Place.checkbox1_1=uicontrol('Style','checkbox','String','Data Size','Position',[20,800,100,25],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');
Place.checkbox1_2=uicontrol('Style','checkbox','String','Plot Sample','Position',[20,770,100,25],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');
Place.checkbox1_3=uicontrol('Style','checkbox','String','Match Data','Position',[20,740,100,25],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');
Place.checkbox1_4=uicontrol('Style','checkbox','String','Active Events','Position',[20,710,100,25],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');

Place.data_beh = uicontrol('Style','listbox','String','Select Behavior ','Position',[150,715,240,100],'FontSize',12,'Units','normalized');



uicontrol('Style','Text','String','Velocity threshold ','Position',[20,660,120,30],'backgroundc',get(Place.fh,'color'),'FontSize',14,'Units','normalized');
 Place.vel  = uicontrol('Style',' edit','String','(cm/min)','Position',[20,630,120,30],'FontSize',16,'Units','normalized');
uicontrol('Style','Text','String','Bin Size','Position',[150,660,100,30],'FontSize',14,'backgroundc',get(Place.fh,'color'),'Units','normalized');
 Place.bin = uicontrol('Style',' edit','String','(N in cm)','Position',[150,630,100,30],'FontSize',16,'Units','normalized');

 Place.vel2 = uicontrol('Parent', Place.fh ,'Style','pushbutton','String','SET ','Position',[400,620,100,50],'Callback',@active_data,'FontSize',16,'Units','normalized');
% uicontrol('Style','Text','String','Draw Trajectory','Position',[330,660,100,25],'FontSize',12,'Units','normalized');

 Place.checkbox1_5=uicontrol('Style','checkbox','String','See Behavior','Position',[260,630,100,30],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');

  Place.cellInterest  = uicontrol('Style',' edit','String','Interested Cells','Position',[400,520,200,50],'FontSize',16,'Units','normalized');
 
  Place.Analyze = uicontrol('Parent', Place.fh ,'Style','togglebutton','String','Raw Place Fields','Position',[150,500,220,80],'Callback',@analyze,'FontSize',16,'Units','normalized');

   Place.checkbox1_6=uicontrol('Style','checkbox','String','Smoothing','Position',[30,560,100,20],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');
   Place.checkbox1_7=uicontrol('Style','checkbox','String','Normalize','Position',[30,540,100,20],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');
   Place.checkbox1_8=uicontrol('Style','checkbox','String','Plot','Position',[30,520,100,20],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');
   Place.checkbox1_9=uicontrol('Style','checkbox','String','Store','Position',[30,490,100,20],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');

     Place.Analyze2 = uicontrol('Parent', Place.fh ,'Style','togglebutton','String','Selected Place Fields','Position',[400,420,250,50],'Callback',@analyze2,'FontSize',16,'Units','normalized');
Place.SelectedMap = uicontrol('Style',' edit','String','#Map','Position',[400,480,60,30],'FontSize',16,'Units','normalized');
        Place.checkbox1_15=uicontrol('Style','checkbox','String','Store','Position',[500,470,80,50],'backgroundc',get(Place.fh,'color'),'HorizontalAlign','left','FontSize',16,'Units','normalized');

 %Settting initial Conditions 
 uicontrol('Style','Text','String','<---- Qualify the Place Cells ---->','Position',[100,400,300,30],'backgroundc',get(Place.fh,'color'),'FontSize',18,'Units','normalized');
  uicontrol('Style','Text','String','Enter Activity threshold (ex, 0.2 for 20%) = ','Position',[20,340,400,30],'backgroundc',get(Place.fh,'color'),'FontSize',18,'Units','normalized');
    uicontrol('Style','Text','String','Enter min Contiguous pixel (default is "9")= ','Position',[20,300,400,30],'backgroundc',get(Place.fh,'color'),'FontSize',18,'Units','normalized');


Place.Pk_threshold = uicontrol('Style',' edit','Position',[400,340,40,30],'FontSize',16,'Units','normalized');
Place.Cont_threshold = uicontrol('Style',' edit','Position',[400,300,40,30],'FontSize',16,'Units','normalized');

   Place.checkbox1_10=uicontrol('Style','checkbox','String','Single PFs','Position',[40,250,100,20],'background','w','HorizontalAlign','left','FontSize',14,'Units','normalized');
   Place.checkbox1_11=uicontrol('Style','checkbox','String','Multiple PFs','Position',[160,250,100,20],'background','w','HorizontalAlign','left','FontSize',14,'Units','normalized');
    set(Place.checkbox1_10,'Value',1);set(Place.checkbox1_11,'Value',1)
%    set(handles.checkbox11,'Value',1)
   
Place.checkbox1_12=uicontrol('Style','checkbox','String','Plot','Position',[40,220,100,20],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');
   Place.checkbox1_13=uicontrol('Style','checkbox','String','Store','Position',[40,200,100,20],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');
  Place.cellDist  = uicontrol('Style',' edit','String','Interested Cells','Position',[20,150,200,30],'FontSize',16,'Units','normalized');


   Place.Conditions = uicontrol('Parent', Place.fh ,'Style','togglebutton','String','Place Cells','Position',[375,140,150,150],'Callback',@Conditions,'FontSize',16,'Units','normalized');
   Place.SelPlaceFields = uicontrol('Parent', Place.fh ,'Style','pushbutton','String','Selected Place Cells','Position',[25,40,300,100],'Callback',@SelPlaceFields,'FontSize',12,'Units','normalized');

    uicontrol('Style','Text','String','---------------------------------------','Position',[700,50,10,750],'backgroundc',get(Place.fh,'color'),'FontSize',18,'Units','normalized');

   
   Place.CorrData=uicontrol('style','pop','unit','pix','position',[800,660,300,200],'backgroundc',get(Place.fh,'color'),'fontsize',14,'fontweight','bold','string',{'Raw Maps';'Qualified Place Cells'},'value',1,'Callback',@CorrData,'FontSize',16,'Units','normalized');
      Place.SelectedCorrData=uicontrol('style','tex','unit','pix','position',[1150,760,100,100],'backgroundc',get(Place.fh,'color'),'fontsize',14,'fontweight','bold','string','Analyzing Data:','Units','normalized');
   
         Place.AnalyzeCorrData = uicontrol('Parent', Place.fh ,'Style','togglebutton','String','2D Corr','Position',[1200,550,100,100],'Callback',@AnalyzeCorrData,'FontSize',16,'Units','normalized');
      Place.MovingWindow = uicontrol('Style',' edit','String','px','Position',[1100,720,40,30],'FontSize',16,'Units','normalized');
            uicontrol('Style','Text','String','Moving window size (ex. 0 for exact pix-wise 2D or 1 for 1Xbin moving) = ','Position',[750,660,300,100],'backgroundc',get(Place.fh,'color'),'FontSize',18,'Units','normalized');
  Place.CorrCells  = uicontrol('Style',' edit','String','Select the cells for Pairwise Corr-Coherence','Position',[750,600,400,50],'FontSize',13,'Units','normalized');
      Place.Corrthres = uicontrol('Style',' edit','String','Corr','Position',[1100,680,40,30],'FontSize',16,'Units','normalized');
            uicontrol('Style','Text','String','Enter the Correlation threshold = ','Position',[750,663,300,40],'backgroundc',get(Place.fh,'color'),'FontSize',18,'Units','normalized');

            Place.checkbox1_14=uicontrol('Style','checkbox','String','1-1 Correlation Map for Selected Cells','Position',[750,500,300,80],'background',get(Place.fh,'color'),'HorizontalAlign','left','FontSize',15,'Units','normalized');


              Place.Reset = uicontrol('Parent', Place.fh ,'Style','pushbutton','String','Reset','Position',[1350,50,100,50],'Callback',@reset,'FontSize',16,'FontWeight','bold','BackgroundColor',[0.2 .9 0.9],'Units','normalized');
            
                  Place.MeanCorr = uicontrol('Style',' edit','String','Mean Corr','Position',[900,420,250,30],'FontSize',16,'Units','normalized');

%    set(Place.CorrData,'value',0);
%    get(Place.CorrData,'val')
    Cell_Dist_ini=get(Place.cellDist,'string');
 
%
% hcontour = uicontrol('Style','pushbutton',...
%              'String','Countour','Position',[315,135,70,25],...
%              'Callback',@contourbutton_Callback);
% htext  = uicontrol('Style','text','String','Select Data',...
%            'Position',[325,90,60,15]);
% hpopup = uicontrol('Style','popupmenu',...
%            'String',{'Peaks','Membrane','Sinc'},...
%            'Position',[300,50,100,25],...
%            'Callback',@popup_menu_Callback);
% ha = axes('Units','pixels','Position',[50,60,200,185]);
% align([hsurf,hmesh,hcontour,htext,hpopup],'Center','None');

% Initialize the UI.


% % Assign the a name to appear in the window title.
% fh.Name = 'Simple GUI';
% 
% % Move the window to the center of the screen.
% movegui(fh,'center')
% 
% % Make the window visible.
% Place.fh.Visible = 'on';

%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to 
%  current_data because this function is nested at a lower level.
%    function popup_menu_Callback(source,eventdata) 
%       % Determine the selected data set.
%       str = get(source, 'String');
%       val = get(source,'Value');
%       % Set current data to the selected data set.
%       switch str{val};
%       case 'Peaks' % User selects Peaks.
%          current_data = peaks_data;
%       case 'Membrane' % User selects Membrane.
%          current_data = membrane_data;
%       case 'Sinc' % User selects Sinc.
%          current_data = sinc_data;
%       end
%    end



%%Define the Functions

function enterinputs(hObject, eventdata)
%         clear guidata
        object_data=guidata(hObject);
            
        
        Fs_Ca=get(Place.sampling,'string')
        Fs_Video=get(Place.sampling2,'string');
        Im_dur=get(Place.imaging_per,'string');
        set(Place.parameters,'str',['Im_Fs:' ' ' num2str(Fs_Ca) 'Hz' '  ' 'Video_Fs:' num2str(Fs_Video)  'Hz  ' 'Im_duration:' num2str(Im_dur) 'min']); 
          data_dir=uigetdir('','Locate the data directory');
        
        Event_dir=([data_dir,'/Calcium Events']);
        Nevents=length(dir([Event_dir,'/E*.txt']));
         dir_beh=dir([data_dir,'/Behavior']);
        if(any(char(dir_beh.name)))
            set(Place.data_beh,'str',char(dir_beh.name))
         
         object_data.data_dir=data_dir;
         dir_beh={dir_beh.name};
         object_data.dir_beh=dir_beh;
%             object_data.dir_beh=behavior_dir;
        
        else
             msgbox('Check your behavior directory','Error Check','Error');
        end
        guidata(hObject,object_data);
end
  
function loaddata(hObject, eventdata)
    object_data=guidata(hObject)
    
    sampling_rate_Ca=str2num(get(Place.sampling,'String'))      %Imaging Fs=5Hz)
    sampling_rate_Video=str2num(get(Place.sampling2,'String'))
    Resampling_ratio=sampling_rate_Video/sampling_rate_Ca; % 
    
    if((rem(Resampling_ratio,1))~=0)
        msgbox('Check your sampling rates','Error Check','Error');
    else
    
    Contexts=[get(Place.ctx(1),'val') get(Place.ctx(2),'val') get(Place.ctx(3),'val')]
        total_Contexts=length(Contexts);
        selected_Contexts=find(Contexts==1)
%         pause(2)
        set(Place.parameters,'str', ['Total #of_contexts:' ' ' num2str(total_Contexts) ' ' 'Selected Context(s):' '"' num2str(selected_Contexts) '"']);
        imaging_per=str2double(get(Place.imaging_per,'string'))*length(selected_Contexts)*60; %in sec
        set(Place.parameters,'str', ['Analyzing data length: ' num2str(imaging_per) ' ' 'seconds']);
        
%   data_dir=uigetdir('','Locate the data directory');
  data_dir=object_data.data_dir;
  Event_dir=([data_dir,'/CalciumEvents']);
  Nevents=length(dir([Event_dir,'/E*.txt']));
   set(Place.parameters,'str',['#Cells:' num2str(Nevents)]);
    
   raw=zeros(sampling_rate_Ca*imaging_per,Nevents);
    for i=1:Nevents
    Raw_event=load([Event_dir,'/Event',num2str(i),'.txt']);         %Working with Events only
    raw_event=Raw_event(sampling_rate_Ca*imaging_per*(selected_Contexts-1)+1:sampling_rate_Ca*imaging_per*selected_Contexts,2);
    raw(:,i)=raw_event;
    end
    raw=raw';
    size(raw)
%     raw=raw_event(sampling_rate_Ca*imaging_per*(selected_Contexts-1)+1:sampling_rate_Ca*imaging_per*selected_Contexts,:); 
%     raw=raw_event;
    object_data.raw=raw;
    guidata(hObject,raw);
    
    if(Place.checkbox1_1.Value == 1)
    set(Place.parameters,'str',['CellsXTime: ', num2str(size(raw))]);
    end
    if(Place.checkbox1_2.Value == 1)
    figure;plot(raw(randi(Nevents),:));
    end
%    behavior_dir=object_data.dir_beh;
    dir_beh=object_data.dir_beh
     s_beh=get(Place.data_beh,'Value')
%             dir_beh={dir_beh.name};
            behavior_dir=dir_beh(s_beh)
            object_data.dir_beh=behavior_dir;
    
%     dir_beh=dir([data_dir,'/Behavior']);
%     if(any(char(dir_beh.name)))
%     set(Place.data_beh,'str',char(dir_beh.name))
%    
%    
%     s_beh=get(Place.data_beh,'Value')
%     dir_beh={dir_beh.name};
%     behavior_dir=dir_beh(s_beh)
%     
%     else
%         msgbox('Check your behavior directory','Error Check','Error');
%     end
    xxyy=xlsread([data_dir,'/Behavior/',char(behavior_dir)],'C:D'); 
    xxyy=downsample(xxyy,Resampling_ratio);
    set(Place.parameters,'str',['CellsXTime: ', num2str(size(xxyy))]);
     if(Place.checkbox1_3.Value == 1)
   xxyy=xxyy(1:length(raw),:);
     end
    object_data.xxyy=xxyy;
    guidata(hObject,object_data);
    
    if(length(raw)~=length(xxyy))
    
        msgbox('Calcium and Behavior Data size Mismatch!, Check the match data box','Error Check','Error');
% % raw=raw';
    end
    
     if(Place.checkbox1_4.Value == 1)    %Finding # of Events/Cell
      for i=1:min(size(raw))       
        Active_cells(i)=length(find(raw(i,:))>0);
      end
      set(Place.parameters,'str',['Cell Ca Events in selected Contexts:... ', num2str(Active_cells)]);
%       figure;plot(Active_cells);
     end
     
      
  end

end
% 
    function active_data(hObject, eventdata)
             Vel_entered=str2double(get(Place.vel,'str'));
             Bin_size=str2double(get(Place.bin,'str'));
             sampling_rate_Ca=str2double(get(Place.sampling,'string'));
            object_data=guidata(hObject);
%
        xxyy=object_data.xxyy;
%%Finding Velocity
% Find the position matrix by sample
            for i=1:length(xxyy)-1
            x_disp(i)=sqrt((xxyy(i+1,1)-xxyy(i,1))^2+(xxyy(i+1,2)-xxyy(i,2))^2);
            end
%             figure;plot(x_disp);
% % determine the velocity cm/sec
% % sampling_rate was lowered to imaging rate
% 
        V_thres=Vel_entered; % cm/sec
        samples_min=60/sampling_rate_Ca;
        xy_moving=zeros(size(x_disp));
        xy_n_moving=zeros(size(x_disp));

for i=1:samples_min:length(x_disp)-samples_min
    if(mean(x_disp(i:i+samples_min))>V_thres)
        xy_moving(i:i+samples_min)=1;
    else
        xy_n_moving(i:i+samples_min)=1;
    end
end
N=Bin_size; % select your bin size (max size/N)

% gridxy1=ceil(max(xC));
% gridxy2=floor(min(xC));
        
      

xymin=floor(min(xxyy))
xymax=ceil(max(xxyy))
x = linspace(xymin(1)-1,xymax(1)+1,N);        
y = linspace(xymin(2)-1,xymax(2)+1,N);

X=zeros(N);
binx=diff(x);
biny=diff(y);
bin_size=binx(1)*biny(1);
if(Place.checkbox1_5.Value == 1)
figure;
% Horizontal grid 
for k = 1:length(y)
  line([x(1) x(end)], [y(k) y(k)])
end

% Vertical grid
for k = 1:length(x)
  line([x(k) x(k)], [y(1) y(end)])
end

hold on;scatter(xxyy(:,1),xxyy(:,2),'bo','LineWidth',1);axis tight
end
          object_data.xy_moving=xy_moving;
      object_data.xy_n_moving=xy_n_moving;
      object_data.binsize=bin_size;
        guidata(hObject,object_data);
    end
    
    function analyze(hObject, eventdata)
            object_data=guidata(hObject);
            raw=object_data.raw;
            size(raw)
            xxyy=object_data.xxyy;
            xy_moving=object_data.xy_moving;
            xy_n_moving=object_data.xy_n_moving
            bin_size=object_data.binsize;
            data_dir=object_data.data_dir;
            
            N=str2double(get(Place.bin,'str'));
            Cell_Dist=get(Place.cellDist,'string')
            
            if(Cell_Dist~=Cell_Dist_ini)
                Cell_dist=str2double(get(Place.bin,'str'))
            else
                Cell_dist=[1:min(size(raw))];
            end
                
           
            
            %Activity_MAP
            X=zeros(N);
            sizeXX=size(X);
            bigMap=zeros(length(Cell_dist),sizeXX(1),sizeXX(2));
            xk=ceil(sqrt(min(size(raw))));  %dividing the subplots for the #of cells

            for kkk=1:length(Cell_dist)%Place fields for set of #N Cells
            X=zeros(N);
            roundxxyy2=round(xxyy);
            roundxxyy2(find(isnan(roundxxyy2)))=0;
            xymin=floor(min(xxyy));
            xymax=ceil(max(xxyy));
            x = linspace(xymin(1)-1,xymax(1)+1,N);        
            y = linspace(xymin(2)-1,xymax(2)+1,N);
            
              for i=1:length(xy_moving)  %%  Tracking the mouse's trajectory
        
                 if(raw(kkk,i)&&xy_moving(i)>0) %all events greater than 1SD
              
                x_sample=find(abs(roundxxyy2(i,1)-x)==min(abs(roundxxyy2(i,1)-x)));
                y_sample=find(abs(roundxxyy2(i,2)-y)==min(abs(roundxxyy2(i,2)-y)));
                X(x_sample,y_sample) = X(x_sample,y_sample)+1;  %Adding 1 for each duration occupancy found under velocity condition 
        
    
   end
%     pause(0.1);
              end
            X_activity=X;
% figure(14);subplot(xk,xk,kkk);imagesc(x,y,smooth_map);axis xy,colormap(jet);caxis([0 0.05]);title(['Cell',num2str(kkk)],'Fontsize',5);
  X=zeros(N);

% for i=1:6000
        for i=1:length(xy_moving)
            if(xy_moving(i)>0)
                x_sample=find(abs(roundxxyy2(i,1)-x)==min(abs(roundxxyy2(i,1)-x)));
                y_sample=find(abs(roundxxyy2(i,2)-y)==min(abs(roundxxyy2(i,2)-y)));
                X(x_sample,y_sample) = X(x_sample,y_sample)+1;  %Adding 1 for each duration occupancy found under velocity condition 
        
            end
% xxyy2(xy_moving(i),1)=min(find(abs(roundxxyy2(xy_moving(i),1)-x)==min(abs(roundxxyy2(xy_moving(i),1)-x))));
% xxyy2(xy_moving(i),2)=min(find(abs(roundxxyy2(xy_moving(i),2)-y)==min(abs(roundxxyy2(xy_moving(i),2)-y))));
        end

        X_sampling=X;

% figure(14);subplot(xk,xk,kkk);pcolor(X);axis xy,colormap(jet);caxis([0 1]);title(['Cell',num2str(kkk)],'Fontsize',5);


XplaceField=X_activity./X_sampling;
XplaceField(find(isinf(XplaceField)))=.001;     %Eliminate the NaN or Inf numbers 
XplaceField(find(isnan(XplaceField)))=0;
% figure;imagesc(x,y,XplaceField);axis xy,colormap(jet);colorbar;title('Place Field','Fontsize',20)
xk=ceil(sqrt(min(size(raw))));  %dividing the subplots for the #of cells

% bin_size=1;
if(Place.checkbox1_6.Value == 1) 
window_size=round(bin_size/2); %cm2
H = fspecial('Gaussian',[window_size window_size],1);
smooth_map=imfilter(XplaceField,H,'same');
else
    smooth_map=XplaceField;
end
if(Place.checkbox1_7.Value == 1) 
norm_map=smooth_map./max(max(smooth_map));
else
    norm_map=smooth_map;
end
% figure(14);subplot(xk,xk,kkk);imagesc(x,y,smooth_map);axis xy,colormap(jet);caxis([0 0.05]);title(['Cell',num2str(kkk)],'Fontsize',5);
if(Place.checkbox1_8.Value == 1) 
figure(14);subplot(xk,xk,kkk);pcolor(norm_map);axis xy,colormap(jet(10));caxis([0 1]);title(['Cell',num2str(kkk)],'Fontsize',5);
end
axis off;shading interp;
% ylabel(['bin size:',num2str(bin_size),'cm'],'Fontsize',10) %
bigMap(kkk,:,:)=norm_map;


% pause(0.1)
            end
if(Place.checkbox1_9.Value == 1) 
     saveN=inputdlg('PlaceField#:')
%      saveN=1;
    save([data_dir,'/Raw_PlaceFields_', char(saveN) ],'bigMap')
end
                  set(Place.parameters,'str',['Bin size:', num2str(bin_size), 'cm2']);
                  object_data.bigMap=bigMap;
                  guidata(hObject,object_data);
    end

function analyze2(hObject, eventdata)
            object_data=guidata(hObject);
            bigMap=object_data.bigMap;
            data_dir=object_data.data_dir
            
            Cells_interest=str2num(get(Place.cellInterest,'string'));
            ll=length(Cells_interest);
            lll=ceil(sqrt(ll));
            figure;
            for ik=1:ll
                subplot(lll,lll,ik);pcolor(squeeze(bigMap(Cells_interest(ik),:,:)));axis xy,colormap(jet(10));caxis([0 1]);
%                 title(['Cell',num2str(Cells_interest(ik))],'Fontsize',5);
                shading interp;axis off;
            end
            if(Place.checkbox1_15.Value==1)
                ssMap=get(Place.SelectedMap,'string')
            saveas(gcf,[data_dir, '/SelectedCells' ,ssMap],'tif')
            end
  end
         
    function Conditions(hObject, eventdata)
            object_data=guidata(hObject);
            bigMap=object_data.bigMap;
            data_dir=object_data.data_dir;
            PCs=[];
%             Th_peak_firing=0.2;             %50 percent thresholding
%             Cont_pixel=9;
            
            Th_peak_firing=str2double(get(Place.Pk_threshold,'str'));
            Cont_pixel=str2double(get(Place.Cont_threshold,'str'));
            xk=ceil(sqrt(length(bigMap)))  %dividing the subplots for the #of cells
            
    for kkk=1:length(bigMap)
            
            temp=squeeze(bigMap(kkk,:,:) );


            [a,y]=max(max(temp'));              % Location and Mag of the Peak firing 
            [a,x]=max(max(temp));   
            temp(find(temp<a*Th_peak_firing))=0;
            [yy,xx]=find(temp>Th_peak_firing);       %indexing the remaining pixels
% Downgrading to Single PFs...comment this if you want to keep multiple
% fields
            
            if(Place.checkbox1_10.Value==1 && Place.checkbox1_11.Value ==0)
                
                for ii=1:length(xx)
                    bin_dist=2;         % discarding the pixels that is >2 bin size from the center of the peak firing 
                if(abs(xx(ii)-x)>bin_dist  || abs(yy(ii)-y)>bin_dist)       
                temp(yy(ii),xx(ii))=0   ;
                end
                end
                
                if(length(find(temp>0))<Cont_pixel)
                temp(:,:)=0;
                end
                temp2(kkk,:,:)=temp./max(max(temp));
                if(isnan(temp(:,:))==1)
                temp(:,:)=0;
                end
            end
            
            if(Place.checkbox1_12.Value ==1)
             figure(16);subplot(xk,xk,kkk);pcolor(temp); shading interp;axis xy,colormap(jet(10));caxis([0 1]);title(['Cell',num2str(kkk)],'Fontsize',5);
            end
            
            
            if(mean(mean(temp))~=0)
                PCs=[PCs kkk];
            end
                
            bigMap2(kkk,:,:)=temp;
            
    end
                  set(Place.parameters,'str',['Place Cells # ', num2str(PCs)]);

            if(Place.checkbox1_13.Value == 1) 
            saveN=inputdlg('PlaceField#:')
%      saveN=1;
           save([data_dir,'/Q_PlaceFields_', char(saveN) ],'bigMap')
            end
               object_data.bigMap2=bigMap2;
                  guidata(hObject,object_data);
    end
function SelPlaceFields(hObject, eventdata)
                      object_data=guidata(hObject);          
                bigMap2=object_data.bigMap2;
                Cells_twolook=str2num(get(Place.cellDist,'string'));
                averageMap=zeros(min(size(bigMap2)),min(size(bigMap2)));
%             Cells_twolook=[10 20 30 18 40 134];
    figure;
for i=1:length(Cells_twolook)
    temp=squeeze(bigMap2(Cells_twolook(i),:,:));
    
    h=pcolor(1:length(temp),1:length(temp),temp);
    hold on;
    h.ZData=ones(size(temp))*Cells_twolook(i);
    view(3)
    axis tight;shading interp;colormap(jet(10))
    pause(1)
    averageMap=averageMap+squeeze(bigMap2(Cells_twolook(i),:,:))
end
    h=pcolor(1:length(temp),1:length(temp),squeeze(averageMap));
     h.ZData=ones(size(temp))*Cells_twolook(i)+100;
    view(3)
    axis tight;shading interp;colormap(jet)
%     pcolor(squeeze(averageMap))
    
            
end

function CorrData(hObject, eventdata)
     object_data=guidata(hObject);
         data_dir=object_data.data_dir;
       
    SS=get(Place.CorrData,'val');
    if(SS==1)
        Map1=inputdlg('Enter the 1.Map#:');PlaceMap1=load([data_dir,'/Raw_PlaceFields_', char(Map1) '.mat'])
        Map2=inputdlg('Enter the 2.Map#:');PlaceMap2=load([data_dir,'/Raw_PlaceFields_', char(Map2) '.mat'])       
    end
    if(SS==2)
        Map1=inputdlg('Enter the #Maps:');PlaceMap1=load([data_dir,'/Q_PlaceFields_', char(Map1) '.mat'])
        Map2=inputdlg('Enter the 2.Map#:');PlaceMap2=load([data_dir,'/Q_PlaceFields_', char(Map2) '.mat'])       
    end
        bin_size=object_data.binsize;
        set(Place.parameters,'str',['Current Bin size: ', num2str(bin_size)]);    
        
        
        object_data.Map1=PlaceMap1;
        object_data.Map2=PlaceMap2;
        guidata(hObject,object_data);
        
end
 
function AnalyzeCorrData(hObject, eventdata)
        object_data=guidata(hObject);
        Map1=object_data.Map1;
        Map1=Map1.bigMap;
        Map2=object_data.Map2;
        Map2=Map2.bigMap;
        bin_size=object_data.binsize;
        xk=ceil(sqrt(length(Map1)));
         
        
        CCs=[];
        moving_window=1;
        Corr_thresh=0;
        moving_window=str2double(get(Place.MovingWindow,'str'));
        Corr_thresh=str2double(get(Place.Corrthres,'str'));
        
        
        for kkk=1:length(Map1)%Place fields for set of #N Cells
                sliding_win=moving_window*bin_size;
        if(sliding_win>0)  
        [a,x]=max(max(squeeze(Map1(kkk,:,:))'));
        [a,y]=max(max(squeeze(Map1(kkk,:,:))));
            %Calculate corr by shifting the reference PFs
            c=corrcoef(Map1(kkk,:,:),Map2(kkk,:,:));
            cc(kkk)=c(1,2);
           corrcell=corr(squeeze(Map1(kkk,:,:)),squeeze(Map2(kkk,:,:)));
           corrcell(isnan(corrcell))=0;
            xx=[x-sliding_win x+sliding_win];
            yy=[y-sliding_win y+sliding_win];
% Setting the borders 
if(xx(1)<1)
    xx(1)=1;
end
if(yy(1)<1)
    yy(1)=1;
end
if(xx(2)>min(size(Map1)));
xx(2)=min(size(Map1));
end
if(yy(2)>min(size(Map1)));
yy(2)=min(size(Map1));
end

figure(Place.fh.Number);hh=subplot(12,12,12);
% figure(10);
hold on;plot(kkk,cc(kkk),'b.','MarkerSize',20);
hold on;plot(kkk,Corr_thresh,'r^','MarkerSize',5)
% plot(kkk,mean(mean(corrcell(xx(1):xx(2),yy(1):yy(2)))),'.','MarkerSize',20);
set(gca,'FontSize',20);ylabel('Correlation')
% set(gcf,'Color', [1 1 1]),set(gca,'FontSize',20)
        end
%     if(mean(mean(corrcell(xx(1):xx(2),yy(1):yy(2)))) > Corr_thresh)
% corrcell2=xcorr2(squeeze(Map1(kkk,:,:)),squeeze(Map2(kkk,:,:)));
% figure(16);subplot(xk,xk,kkk);pcolor(corrcell2);shading interp;colormap jet;axis off;
% 
% h=line([0  2*min(size(Map1))-1] ,[min(size(Map1)) min(size(Map1))]);
% set(h,'LineStyle','--','Color','w','LineWidth' ,2);
% hold on
% h=line([min(size(Map1))  min(size(Map1))] ,[0 2*min(size(Map1))-1]);
% set(h,'LineStyle','--','Color','w','LineWidth' ,2);
% else
%    
% corrcell2=xcorr2(squeeze(Map1(kkk,:,:)),squeeze(Map2(kkk,:,:)));
%  if(mean(mean(corrcell2))~=0)
% figure(16);subplot(xk,xk,kkk);pcolor(corrcell2);shading interp;colormap jet;axis off;
% h=line([0  2*min(size(Map1))-1] ,[min(size(Map1)) min(size(Map1))]);
% set(h,'LineStyle','--','Color','g','LineWidth' ,1);
% hold on
% h=line([min(size(Map1))  min(size(Map1))] ,[0 2*min(size(Map1))-1]);
% set(h,'LineStyle','--','Color','g','LineWidth' ,1);
%     end
%     end

    if(cc(kkk) > Corr_thresh)
        CCs=[CCs kkk];
corrcell2=xcorr2(squeeze(Map1(kkk,:,:)),squeeze(Map2(kkk,:,:)));
figure(17);subplot(xk,xk,kkk);pcolor(corrcell2);shading interp;colormap jet;axis off;

h=line([0  2*min(size(Map1))-1] ,[min(size(Map1)) min(size(Map1))]);
set(h,'LineStyle','--','Color','w','LineWidth' ,2);
hold on
h=line([min(size(Map1))  min(size(Map1))] ,[0 2*min(size(Map1))-1]);
set(h,'LineStyle','--','Color','w','LineWidth' ,2);
else
   
corrcell2=xcorr2(squeeze(Map1(kkk,:,:)),squeeze(Map2(kkk,:,:)));

 if(cc(kkk)<Corr_thresh)
     
figure(17);subplot(xk,xk,kkk);pcolor(corrcell2);shading interp;colormap jet;axis off;
% title(num2str(kkk));
h=line([0  2*min(size(Map1))-1] ,[min(size(Map1)) min(size(Map1))]);
set(h,'LineStyle','--','Color','g','LineWidth' ,1);
hold on;
h=line([min(size(Map1))  min(size(Map1))] ,[0 2*min(size(Map1))-1]);
set(h,'LineStyle','--','Color','g','LineWidth' ,1); 
 end
                      set(Place.parameters,'str',['Corr Cells # ', num2str(CCs)]);


    end      
        
    
        end
        
        cc(find(isnan(cc)))=0;
        set(hh,'Position',[0.52 0.2 0.4 0.20]);
        set(Place.MeanCorr,'string',['#Cells' ' ' num2str(length(CCs)) ', ' 'MeanCorr:'  '' num2str(mean(cc)) ]);
        
        
            if(Place.checkbox1_14.Value==1)
                 CC_cells=str2num(get(Place.CorrCells,'string'))
                for ii=1:length(CC_cells)
                    figure(22);clf;
                    subplot(121);contour(squeeze(Map1(CC_cells(ii),:,:)));hold on;contour(squeeze(Map2(CC_cells(ii),:,:)));axis tight;title('Overlapping (Press any key)');
                    subplot(122);contourf(xcorr2(squeeze(Map1(CC_cells(ii),:,:)),squeeze(Map2(CC_cells(ii),:,:))));axis tight;title('Spatial Coherence (Press any key)');
                    h=line([0  2*min(size(Map1))-1] ,[min(size(Map1)) min(size(Map1))]);
                    set(h,'LineStyle','--','Color','w','LineWidth' ,1)
                    hold on
                        h=line([min(size(Map1))  min(size(Map1))] ,[0 2*min(size(Map1))-1]);
                    set(h,'LineStyle','--','Color','w','LineWidth' ,1)
                    axis off
                  colormap jet
                    pause;
                end
                    close figure 22
                
            end


end

function reset(hObject, eventdata,handles)
       close figure 'PlaceCellAnalysis v0.1'
       Place_cell_gui_01
end
end