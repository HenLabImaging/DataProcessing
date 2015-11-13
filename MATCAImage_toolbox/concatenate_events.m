function concatenate_events()
tic
     [imagefile,image_dir]=uigetfile('.*','Load your first text file')
   [pathdata,namedata,format]=fileparts(imagefile);
   Ncells=length(dir(image_dir));
   imagepath=char(inputdlg(['Is file tag without a number ending is true?:' ' '  namedata]));
      if(isempty(imagepath))
       imagepath=namedata;
      end
     Ncells=str2num(char(inputdlg(['Enter the Number of Events' ' '  num2str(Ncells)])));
   events=[];
   for i=1:Ncells
        event=load([image_dir imagepath num2str(i) format]);
        events(:,i)=event(:,2);
%         comb_cell=imadd(comb_cell,cell);
   end
   dlmwrite([image_dir 'All_Events.txt'],events)
   toc
   
end