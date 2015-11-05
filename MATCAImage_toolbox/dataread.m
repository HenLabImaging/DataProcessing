function data=dataread(dir,format,fs,time1,time2,var1,var2)
% disp(dir)
% format=char(format)
switch format
    case 'excel'
        data=xlsread(dir);        
    case 'text'
        data=load(dir);
    case 'matlab'
        data=load(dir);
        data=struct2array(data);
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