%%interpolation for missed tracking points

Fs_tracking=str2num(char(inputdlg('Enter the tracking sampling rate(e.g., 30): ')));   
Im_duration=str2num(char(inputdlg('Enter the tracking duration: ')));   
Im_dur=Im_duration*60;


[beh dir]=uigetfile('.xlsx','Behavior');
beh=xlsread([dir beh]);
beh=beh(1:Fs_tracking*Im_dur,:);

int_column=str2num(char(inputdlg('Enter the desired column numbers you would like to interpolate (e.g 3 4)?')));    
xxyy=beh(:,[int_column])

% ii=1;
% while ii>0
%   [xxnan yynan]=find(isnan(xxyy))
%   for i=1:length(yynan)
%       xxyy(xxnan(i),yynan(i))=xxyy(xxnan(i)+1,yynan(i));
%   end
%   ii=length(yynan)
% end
%      

xxyy_interp=inpaint_nans(xxyy);

figure;plot(xxyy_interp(:,1),xxyy_interp(:,2),'ro','MarkerSize',10)
hold on;plot(xxyy(:,1),xxyy(:,2),'o')


dlgTitle    = 'Interpolation';
 dlgQuestion = 'Do you wish to Save new file?';
 choice = questdlg(dlgQuestion,dlgTitle,'Yes','Naa', 'Yes');
% choice='Yes';
 if(choice=='Yes') 
xlswrite([dir '/interpolated_behavior'],xxyy)
 end