function MATCa
Place.tool = figure('Visible','on','Name','MATCa toolbox','NumberTitle','off','Position',[20,20,800,800],'Units','normalized','Resize','on','Color',[0.9 0.98 0.85]);
% set(gcf,'Name','Ca2_Toolbox','Color',[0.98 0.98 0.99],'NumberTitle','off')
uicontrol('Style','Text','String','Select data','Position',[400,320,240,400],'backgroundc',get(Place.tool,'color'),'FontSize',16,'Units','normalized');
uicontrol('Style','Text','String','Calcium Data','Position',[250,315,200,400],'backgroundc',get(Place.tool,'color'),'FontSize',16,'Units','normalized');

 Place.loaddata=uicontrol('Parent', Place.tool,'Style','pushbutton','String','Locate the Script folder','Position',[80,725,200,50],'Callback',@loaddata,'FontSize',16,'Units','normalized');
 Place.importdata=uicontrol('Parent', Place.tool,'Style','pushbutton','String','Import Data','Position',[300,300,100,60],'Callback',@importdata,'FontSize',16,'Units','normalized');
Place.data_list2 = uicontrol('Style','listbox','String',' ','Position',[80,300,200,400],'FontSize',20,'Units','normalized');

 Place.checkbox1_1=uicontrol('Style','checkbox','String','Manual','Position',[80,705,100,20],'background','w','HorizontalAlign','left','FontSize',12,'Units','normalized');


 Place.sampling  = uicontrol('Style',' edit','String','Sampling Rate','Position',[300,650,100,30],'Units','normalized','FontSize',12);
 Place.start_time  = uicontrol('Style',' edit','String','First frame (sec)','Position',[300,600,100,30],'Units','normalized','FontSize',12);
 Place.end_time = uicontrol('Style',' edit','String','Last frame (sec)','Position',[300,550,100,30],'Units','normalized','FontSize',12);
 Place.cell1  = uicontrol('Style',' edit','String','First Column (includes time stamps) ','Position',[300,500,100,30],'Units','normalized','FontSize',12);
 Place.cellend  = uicontrol('Style',' edit','String','Last Column ','Position',[300 450,100,30],'Units','normalized','FontSize',12);
 Place.dataname  = uicontrol('Style',' edit','String','DataTag','Position',[300 400,100,30],'Units','normalized','FontSize',12);

 
 
Place.data_list = uicontrol('Style','listbox','String',' ','Position',[450,400,140,300],'FontSize',20,'Units','normalized');

 
 

  Place.runfunction=uicontrol('Parent', Place.tool,'Style','pushbutton','String','RUN','Position',[450,300,120,60],'Callback',@runfunction,'FontSize',16,'Units','normalized','background','w');

  
  uicontrol('Style','Text','ForegroundColor',[1 0.2 0.1],'String','Step#1 - Load Scripts and check the manual tick box if you are a new user','Position',[50,200,640,50],'backgroundc',get(Place.tool,'color'),'FontSize',18,'Units','normalized');
    uicontrol('Style','Text','ForegroundColor',[1 0.2 0.1],'String','Step#2 - Enter data parameters and locate your data (Transients/events/behavior) in pop up window','Position',[50,140,640,70],'backgroundc',get(Place.tool,'color'),'FontSize',18,'Units','normalized');
    uicontrol('Style','Text','ForegroundColor',[1 0.2 0.1],'String','Step#3 -Click a suitable analysis and a desired data for analysis-->RUN','Position',[50,100,640,50],'backgroundc',get(Place.tool,'color'),'FontSize',18,'Units','normalized');
%     uicontrol('Style','Text','ForegroundColor',[0 0 0],'String','~ FOR LARGE DATA SETS, ENJOY PHD COMICS! ~','Position',[50,160,640,20],'backgroundc',get(Place.tool,'color'),'FontSize',16,'Units','normalized');

    
    uicontrol('Style','Text','ForegroundColor',[0.1 0.2 0.1],'String','For comments and updates  --> https://github.com/HenLabImaging/MATCAImage_toolbox','Position',[100,50,640,40],'backgroundc',get(Place.tool,'color'),'FontSize',16,'Units','normalized');
% 
      uicontrol('Style','Text','ForegroundColor',[0 0 0.1],'String','Developed by Gokhan Ordek','FontName','Apple','Position',[580,20,200,30],'backgroundc',get(Place.tool,'color'),'FontSize',14,'Units','normalized');

%  rr=randi(2);
%  if(rr==1)
%      im=imread(['/Volumes/Research/Analyses_scripts/MATCA_toolbox/phdcomics/Unknown-'
%      num2str(randi(12))])
% %      format(im)
%      im=imresize(im,[300 550]);
%      figure(Place.tool.Number);subplot(10,10,81:98);imshow(im)
%  else
%       im=imread(['/Volumes/Research/Analyses_scripts/MATCA_toolbox/phdcomics/images-' num2str(randi(12)) '.jpeg']);
%          im=imresize(im,[300 550]);
%               figure(Place.tool.Number);subplot(10,10,81:98);imshow(im)
% 
%  end
%  
persistent bb
 DATA={};
 function importdata(hObject, eventdata)
%         clear guidat
        object_data=guidata(hObject);
            fs=str2num(get(Place.sampling,'string'));
        st_time=str2num(get(Place.start_time,'string'));
        end_time=str2num(get(Place.end_time,'string'));
          cell1=str2num(get(Place.cell1,'string'));
        cellend=str2num(get(Place.cellend,'string'));
        [data data_dir]=DataRead(fs,st_time,end_time,cell1,cellend);
        data_parameters=[fs st_time end_time cell1 cellend];

        
        DATA=[DATA data];
%         figure;imagesc(DATA{2})
        bb=get(Place.data_list,'str');
         aa=get(Place.dataname,'str');
         bb=[cellstr(bb) ;cellstr(aa)];
         set(Place.data_list,'String',bb);
         object_data.DATA=DATA;
         object_data.data_dir=data_dir;
         object_data.namelist=bb;
         object_data.data_parameters=data_parameters;
         guidata(hObject,object_data);
 end
 function loaddata(hObject, eventdata)
%     DATAA={}
%     object_data=guidata(hObject)
%     DATAA=object_data.DATA
%     size(DATAA)
%      sel_data=get(Place.data_list,'Value')
%      ssel_data=get(Place.data_list,'str')
%      sel_data=sel_data-1;
     script_dir=uigetdir();
     delete([script_dir '/*._*']);
     dir_struct=dir([script_dir '/*.m']);
     [sorted_names,sorted_index] = sortrows({dir_struct.name}');
     set(Place.data_list2,'String',sorted_names);
     
    
     
     
%      sel_data=str2num(sel_data)
%      figure;imagesc(DATAA{sel_data});
%     set(Place.data_list2,'String',ssel_data)
%         guidata(hObject,object_data);
 end

    function runfunction(hObject,eventdata)
            object_data=guidata(hObject);
          data_parameters=object_data.data_parameters; %return the GUI handle parameters for data spec
         DATA=object_data.DATA;
         data_dir=object_data.data_dir;
%          size(DATA)
          bb=object_data.namelist;
          
               index_selected = get(Place.data_list2,'Value');
                    index2 = get(Place.data_list,'Value');
            file_list = get(Place.data_list2,'String');
             filename = file_list{index_selected};
              [pathImage,NameImage,ExtImage]=fileparts(filename);
          
          
% %       
        if(length(data_parameters)<5)
            errordlg('You left a parameter(s) not entered! It will load the entire dataset!');
            ddata=DATA{index2-1};
                time1=round(ddata(1,1));
                time2=round(length(ddata)/data_parameters(1));
                data_parameters(2:3)=[time1 time2];
                Nevents=min(size(ddata))-1;
                ddata(:,1)=[];
                data_parameters(4)=2;
                data_parameters(5)=Nevents;
        end
        
%             if(length(data_parameters)<5)
%                 Nevents=min(size(ddata))-1;
%                 ddata(:,1)=[];
%                 data_parameters(4)=2;
%                 data_parameters(5)=Nevents;
%             end
% %         data_parameters
        

               

              switch NameImage
                  
                   
                  case 'AveragingBehEpochs'
%                       open help_TFIDF2.pdf
                    selectedfunc=str2func(NameImage);
                    selectedfunc(data_parameters(1),data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),DATA{index2-1});

                  
                  case 'RasterPlot'
                      if(Place.checkbox1_1.Value == 1)
                     open help_RasterPlot.pdf
                      end
                     selectedfunc=str2func(NameImage);
                     TW=str2double(char(inputdlg('Enter the time width for running window: (sec)')));
                      selectedfunc(data_parameters(1),data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),TW,DATA{index2-1});
                  case 'Centroid_shifts'
%                       errordlg('Locate Reference and secondary image folders')
                        if(Place.checkbox1_1.Value == 1)
                      open help_Centroid_shifts.pdf
                        end
                      selectedfunc=str2func(NameImage)
                      selectedfunc()
                  case 'CalciumBehaviorPair'
                        if(Place.checkbox1_1.Value == 1)
                      open help_CalciumBehaviorPair.pdf
                        end
                      helpdlg('Behavioral data in rowXcolumn is required')
                      Beh_input=str2num(char(inputdlg('Enter behavioral parameters: Sampling rate, X and Y column on the excel file; by each line','Behavioral Parameters',3)))
                      selectedfunc=str2func(NameImage);
                      selectedfunc(data_parameters(1),Beh_input(1),data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),Beh_input(2),Beh_input(3),DATA{index2-1});
                  
                  case 'Ca_Behavior_Matching'
                      if(Place.checkbox1_1.Value == 1)
                      end
                      
                        uiwait(msgbox('Enter your behavioral data!'))
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

                        fs_video=round(length(beh)/(beh(end,1)-beh(1,1)));
                        fs_in=char(inputdlg(['Is your video sampling rate: ' num2str(fs_video) '?' ' '  'y/n']));
                        if(fs_in~='y')
                            fs_video=str2double(char(inputdlg('Enter the correct Video sampling rate:')));
                        end

                        uiwait(msgbox('Enter the column numbers for your behavioral markings!'));
                        behinputs=str2num(char(inputdlg('Leave a space btw entered column numbers')));
                        selectedfunc=str2func(NameImage);
                        selectedfunc(data_parameters(1),fs_video,data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),behinputs,beh,DATA{index2-1});

                  
                  
                  case 'TFIDF'
%                       open help_TFIDF2.pdf
                    selectedfunc=str2func(NameImage);
                    selectedfunc(data_parameters(1),data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),DATA{index2-1});
                case 'ClassifyWave'  
                     if(Place.checkbox1_1.Value == 1)
                     open help_ClassifyWave.pdf
                     end
                    selectedfunc=str2func(NameImage);
                    selectedfunc(data_parameters(1),data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),DATA{index2-1});
                case 'concatenate_events'
                     if(Place.checkbox1_1.Value == 1)
                    open help_concatenate_events.pdf
                     end
                    selectedfunc=str2func(NameImage);
                    selectedfunc()
                 case 'CountEvents'
                    selectedfunc=str2func(NameImage);
                    selectedfunc(data_parameters(1),data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),DATA{index2-1});
                 case 'cell_centroids'
                      if(Place.checkbox1_1.Value == 1)
                     open help_cell_centroids.pdf
                      end
                     selectedfunc=str2func(NameImage);
                      selectedfunc()
                  case 'spatial_temporal_clustering'
             if(Place.checkbox1_1.Value == 1)                       
                open help_spatial_temporal_clustering.pdf
             end
                Cluster_input=str2num(char(inputdlg('Enter thresholding, desired min and max inter cell distances, and temporal window for temporal coherence; by each line','Clustering parameters',4)))

                      selectedfunc=str2func(NameImage);
                    selectedfunc(data_parameters(1),data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),DATA{index2-1},Cluster_input(1),Cluster_input(2),Cluster_input(3),Cluster_input(4));
                     
                  case'ColorMapDrawing_Transients'
                      selectedfunc=str2func(NameImage);
                      selectedfunc(data_parameters(1),data_parameters(2),data_parameters(3),DATA{index2-1});
                  case'CrossCorr'
                      selectedfunc=str2func(NameImage);
                      selectedfunc(DATA{index2-1});
                     case'PCA_reconstruction'
                          selectedfunc=str2func(NameImage);
                      selectedfunc(DATA{index2-1},data_parameters(1));
                        case 'shuffling'
%                       open help_TFIDF2.pdf
                    selectedfunc=str2func(NameImage);
                    shuffleddata=selectedfunc(data_parameters(1),data_parameters(2),data_parameters(3),data_parameters(4),data_parameters(5),DATA{index2-1});
                      DATA=[DATA shuffleddata];
                      size(DATA)
%                          figure;imagesc(shuffleddata)
                     object_data.shuffled_data=shuffleddata;
              
                         bb=[bb;'shuffledata']
                      set(Place.data_list,'String',bb);
                  case 'export_data'
                      selectedfunc=str2func(NameImage);
                      filename=get(Place.dataname,'str');
                      selectedfunc(DATA{index2-1},filename,data_dir)
                      
                         case'stats'
                          selectedfunc=str2func(NameImage);
                      selectedfunc(DATA{index2-1},data_parameters(1));
                      
                        case'naninterp'
                          selectedfunc=str2func(NameImage);
                      selectedfunc(DATA{index2-1},data_dir);
                         case'vennX'
                          selectedfunc=str2func(NameImage);
                        selectedfunc();
                      
              end
              
%              try
%                  
% %                   @Place_cell_gui_02
%                     selectedfunc(5,1201,1800,2,700,20);
%                 catch ex
%                     errordlg(...
%                       ex.getReport('basic'),'File Type Error','modal')
%              end

            
               
               object_data.DATA=DATA;
            guidata(hObject,object_data);
        
    
    end



end