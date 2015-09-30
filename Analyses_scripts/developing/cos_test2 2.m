zoneYtoX=zoneCentertoY;
conv_Center_kernel1=[];conv_Open_kernel1=[];conv_Close_kernel1=[];
for i=1:min(size(conv_kernel_trans))
% figure(1);clf;area(ZONES')
% hold on;plot(conv_kernel_trans(:,i),'r')
% pause(.1)

conv_Center_kernel1(:,i)=(CENTER_zones.*conv_kernel_trans(:,i)');
conv_Open_kernel1(:,i)=(OPEN_zones.*conv_kernel_trans(:,i)');
conv_Close_kernel1(:,i)=(CLOSE_zones.*conv_kernel_trans(:,i)');


OpenGrade(i)=sum(abs(conv_Center_kernel1(:,i)))+sum(abs(conv_Open_kernel1(:,i)));
CloseGrade(i)=sum(abs(conv_Close_kernel1(:,i)));


if(OpenGrade(i)>CloseGrade(i))
Scored_cells(i)=1;
else
    Scored_cells(i)=0;
end

% a=inputdlg('enter:','open_close arm score',2)
% temp=str2num(char(a));
% open_score(i)=temp(1);
% close_score(i)=temp(2);
% % 
% CenterGrade(i)=length(find(conv_Center_kernel1>0))/length(find(conv_kernel_trans(:,i)>0));
% OpenGrade(i)=length(find(conv_Open_kernel1>0))/length(find(conv_kernel_trans(:,i)>0));
% CloseGrade(i)=length(find(conv_Close_kernel1>0))/length(find(conv_kernel_trans(:,i)>0));

% figure(10);
% 
% abs_conv_kernel=(norm_transients);
% for ii=1:length(zoneYtoX)
% 
% on_score(ii,i)=mean(abs_conv_kernel(zoneYtoX(ii)-50:zoneYtoX(ii),i));
% off_score(ii,i)=mean(abs_conv_kernel(zoneYtoX(ii):zoneYtoX(ii)+50,i));
% 
% 
% 
% on_off_score(ii,i)=on_score(ii,i)-off_score(ii,i);
% 
% 
% hold on;scatter(off_score,on_score,'ro')
% end

% for ii=1:length(zoneXtoX)
% on_score=mean(abs_conv_kernel(zoneXtoX(ii)-50:zoneXtoX(ii),i));
% off_score=mean(abs_conv_kernel(zoneXtoX(ii):zoneXtoX(ii)+50,i));
% 
% off_off_score(ii,i)=on_score-off_score;
% 
% end



end
ss=find(Scored_cells>0);
figure;plot(CloseGrade,OpenGrade,'o')
hold on;plot(CloseGrade(ss),OpenGrade(ss),'ro')

Graded_scores=OpenGrade-CloseGrade;

figure;bar(Graded_scores)

pass1=[131:218];pass2=[374:546];pass3=[568:605];pass4=[834:911];pass5=[955:1048];pass6=[1351:1430];pass7=[2624:2711];
%%
figure;hold on;
  

for k=1:2
   
for i=1:3
       kk=randi(min(size(conv_kernel_trans)));
        ii=randi(min(size(conv_kernel_trans)));
scatter( mean(abs(conv_kernel_trans(pass1,kk))), mean(abs(conv_kernel_trans(pass1,ii))),'bo')
scatter( mean(abs(conv_kernel_trans(pass1(1)-length(pass1):pass1(1),kk))), mean(abs(conv_kernel_trans(pass1(1)-length(pass1):pass1(1),ii))),'ro')
% pause(1)
scatter( mean(abs(conv_kernel_trans(pass2,kk))), mean(abs(conv_kernel_trans(pass2,ii))),'bo')
scatter( mean(abs(conv_kernel_trans(pass2(1)-length(pass2):pass2(1),kk))), mean(abs(conv_kernel_trans(pass2(1)-length(pass2):pass2(1),ii))),'ro')
scatter( mean(abs(conv_kernel_trans(pass3,kk))), mean(abs(conv_kernel_trans(pass3,ii))),'bo')
scatter( mean(abs(conv_kernel_trans(pass3(1)-length(pass3):pass3(1),kk))), mean(abs(conv_kernel_trans(pass3(1)-length(pass3):pass3(1),ii))),'ro')
scatter( mean(abs(conv_kernel_trans(pass4,kk))), mean(abs(conv_kernel_trans(pass4,ii))),'bo')
scatter( mean(abs(conv_kernel_trans(pass4(1)-length(pass4):pass4(1),kk))), mean(abs(conv_kernel_trans(pass4(1)-length(pass4):pass4(1),ii))),'ro')
scatter( mean(abs(conv_kernel_trans(pass5,kk))), mean(abs(conv_kernel_trans(pass5,ii))),'bo')
scatter( mean(abs(conv_kernel_trans(pass5(1)-length(pass5):pass5(1),kk))), mean(abs(conv_kernel_trans(pass5(1)-length(pass5):pass5(1),ii))),'ro')
scatter( mean(abs(conv_kernel_trans(pass6,kk))), mean(abs(conv_kernel_trans(pass6,ii))),'bo')
scatter( mean(abs(conv_kernel_trans(pass6(1)-length(pass6):pass6(1),kk))), mean(abs(conv_kernel_trans(pass6(1)-length(pass6):pass6(1),ii))),'ro')
scatter( mean(abs(conv_kernel_trans(pass7,kk))), mean(abs(conv_kernel_trans(pass7,ii))),'bo')
scatter( mean(abs(conv_kernel_trans(pass7(1)-length(pass7):pass7(1),kk))), mean(abs(conv_kernel_trans(pass7(1)-length(pass7):pass7(1),ii))),'ro')

end
axis([0.01 0.1 0.01 0.1])
end

%%



for ii=1:min(size(cell_events))
    
eventss=find(cell_events(:,ii)>0);

open_score(ii)=0;
close_score(ii)=0;
center_score(ii)=0;


for i=1:length(eventss)
    if(any(eventss(i)==tempindx1) || any(eventss(i)==tempindx2))
        close_score(ii)=close_score(ii)+1;
    elseif(any(eventss(i)==tempindy1) || any(eventss(i)==tempindy1))
        open_score(ii)=open_score(ii)+1;
    elseif(any(eventss(i)==CenterPoints))
     
        center_score(ii)=center_score(ii)+1;
    end
end
end

