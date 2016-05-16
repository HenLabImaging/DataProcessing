function [data ,data_dir]=DataRead(fs,time1,time2,var1,var2)

% disp(dir)
 [datafile,data_dir]=uigetfile('.*','Load your data');
   [pathdata,namedata,format]=fileparts(datafile);
tic
% format=char(format)
switch format
    case '.xlsx'
        data=xlsread([data_dir datafile]);        
         case '.xls'
        data=xlsread([data_dir datafile]);  
    case '.txt'
        data=load([data_dir datafile]);
    case '.csv'
        data=csvread([data_dir datafile],1,0);
    case '.mat'
        data=load([data_dir datafile]);
        data=struct2array(data);
end
if(isempty(format))
        data=load([data_dir datafile]);
end
if(size(time1)>0 & size(time2)>0) %#ok<EXIST>
    
    if(size(var1)>0 & size(var2)>0) %#ok<EXIST>
        data=data(time1*fs+1:time2*fs,var1:var2);
    else
    data=data(time1*fs+1:time2*fs,:);
    end
else
       if(size(var1)>0 & size(var2)>0) %#ok<EXIST>
           data=data(:,var1:var2);
       else
            data=data;
       end
    
end
toc