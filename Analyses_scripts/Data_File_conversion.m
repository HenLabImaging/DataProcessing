function Data_File_conversion
tic
    [FirstEvent,Event_dir]=uigetfile('.txt','Locate the First Ca Event')
    [FirstImage,Image_dir]=uigetfile('.tif','Locate the First Cell Image')
    eventSize=dir([Event_dir FirstEvent]);
      [pathEvent,NameEvent,ExtEvent] = fileparts(FirstEvent);
      if(FirstImage>0)
     [pathImage,NameImage,ExtImage] = fileparts(FirstImage);
      end
    savedir=inputdlg('want to use same directory for re-storage? (y/n)')
   
    if(char(savedir)=='n')
        savedir=uigetdir('Enter a new storage directory:')
    end
    
  Nevents=length(dir([Event_dir,'/' char(FirstEvent(1:3)) '*.txt']));
  mkdir(savedir,'/CalciumEvents');
  mkdir(savedir,'/Images');
  mkdir(savedir,'/Behavior');
  
if(eventSize.bytes>1e2)
   dataevents=load([Event_dir FirstEvent]);
    for i=2:min(size(dataevents))
    iii=i-1;
    event=dataevents(:,i);
    save([savedir,'/CalciumEvents/Event',num2str(iii), '.txt'],'event','-ascii')
    if(iii==1)
            ii=[]; %not to miss the first value which usually saved as no indexing 
    copyfile([Image_dir NameImage num2str(ii) ExtImage],[savedir '/Images/ic',num2str(iii) '.tif'])
    else
        ii=iii-1;
        copyfile([Image_dir NameImage num2str(ii) ExtImage],[savedir '/Images/ic',num2str(iii) '.tif'])
    end
    end
else

%   mkdir(savedir,'/XY_location');
    for i=1:Nevents
        if(i==1)
            ii=[]; %not to miss the first value which usually saved as no indexing
               copyfile([Event_dir NameEvent num2str(ii) ExtEvent],[savedir '/CalciumEvents/Event',num2str(i) '.txt'])
                if(FirstImage>0)      
        copyfile([Image_dir NameImage num2str(ii) ExtImage],[savedir '/Images/ic',num2str(i) '.tif'])
                end
        else
            ii=i-1; %shifted one value
       copyfile([Event_dir NameEvent num2str(ii) ExtEvent],[savedir '/CalciumEvents/Event',num2str(i) '.txt'])
       if(FirstImage>0)
        copyfile([Image_dir NameImage num2str(ii) ExtImage],[savedir '/Images/ic',num2str(i) '.tif'])
       end
        end
        
    end
end
   %Behavior Saving
   
     Beh_tag=inputdlg({'Enter the Project Tag: Example (DG or dHPC,etc.)' 'Animal number: '})
    Beh_N=inputdlg('Enter Number of Behavior Tested:')
    len_beh=str2num(char(Beh_N));
   for l=1:len_beh
       Context=inputdlg(['Tag the context#',num2str(l),' : ex: A1 or C'])
       [beh_file,beh_dir]=uigetfile(['.*'],'Locate the Behavior ')
       copyfile([beh_dir beh_file],[savedir '/Behavior/' char(Beh_tag(1)) char(Beh_tag(2)) char(Context) '_ethovision.xlsx'])
   end
    %%
   Image_dir=([savedir,'/Images']);
     num_cell=length(dir([Image_dir,'/ic*.tif']));
  xy_cell=zeros(num_cell,2);
Comb_cell=imread([Image_dir,'/ic1.tif']); 
%%
    for i=1:num_cell
        cell=imread([Image_dir,'/ic',num2str(i),'.tif']);
        BW=im2bw(cell);
        [x,y]=find(BW>0);
        xc=mean(y);yc=mean(x);
        xy_cell(i,1)=xc;xy_cell(i,2)=yc;
        Comb_cell=imadd(Comb_cell,cell);
    end
%     Comb_cell(find(Comb_cell>0))=20;
    BW_combcell=im2bw(Comb_cell);
    figure;imshow(BW_combcell);hold on
    plot(xy_cell(:,1),xy_cell(:,2),'r.')
    colormap(gray);title('Raw Cells')
    %
    imwrite(Comb_cell,[Image_dir,'/BaseImage.jpeg'])
    save([Image_dir '/xy_cell.mat'],'xy_cell')
    save([Image_dir '/xy_cell'],'xy_cell','-ascii')
   %%
   msgbox('File has been re-stored succesfully!')
   toc
end