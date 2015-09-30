
cells1=[2 5 17 20 26 30 33];
cells2=[2 10 14 21 24 26 37 41];
cells3=[1 3 5 10 12 18 22 25 28 34];
cells4=[3 5 10 12 16 20 22 24 28 31];
cells5=[3 8 10 12 15 20 26 31 36 43 45];
cells6=[1 4 6 11 13 15 20 28 32 34];
counter=0;
X={x2x1 x2x2 x2x3 x2x4 x2x5 x2x6};
X_cells={cells1 cells2 cells3 cells4 cells5 cells6};
figure;
   subplot(6,2,[7 12]);
fill([0 50 50 0],[0 0 1 1],[0.85 0.95 0.97]);hold on;
fill([50 160 160 50],[0 0 1 1],[0.90 0.95 0.89]);

BigMatrix_Close2open=[];

for ii=1:length(X_cells)
hold on;
% des_signal=strcat('x2x',num2str(ii));

 


des_signal=X{ii};
[b,a]=butter(5,0.04);
filt_sig=filtfilt(b,a,des_signal);
des_cells=X_cells{ii};

set(gcf,'Color','w');box off
hold on;

% plot([50 50],[0 1],'r--')
for i=1:min(size(filt_sig))
    
    if(any(i==des_cells))
        
        BigMatrix_Close2open(:,i)=des_signal(:,i);
        
temp=des_signal(:,i);
temp(find(temp==0))=[];
% filt_temp=filtfilt(b,a,temp);
% subplot(6,1,ii);hold on;
filt_sig=filtfilt(b,a,temp);

hold on;plot(filt_sig(1:50),'b:','LineWidth',2)
ll=length(filt_sig);
% [t,p,k]=ttest2(filt_temp(1:50),filt_temp(51:end));
[t,p,k]=ttest(filt_sig(51:end),mean(filt_sig(1:50)),'Tail','Right');
if(p<0.05)
    hold on;plot(51:50+(ll-50),filt_sig(51:end),'r','LineWidth',3)
    counter=counter+1;
    text(ll,filt_sig(end),'*','FontSize',22)

else
hold on;plot(51:50+(ll-50),filt_sig(51:end),'b','LineWidth',3)
end
% figure;plot(sum(filt_sig(:,1:10)'));axis([450 600 0 10])
    end
end

    text(15,0.95,'CLOSE','FontSize',20)
     text(120,0.95,'OPEN','FontSize',20)
end


temp=BigMatrix_Close2open(501:end,:);
for ii=1:length(temp)
     meantemp=0;
     count=0;
for i=1:min(size(temp))
   
    
    if(temp(ii,i)>0)
    meantemp=meantemp +temp(ii,i)
    count=count+1;
    end
    
%     pause(.1)
end
    
    meanTime(ii)=meantemp/count;
% pause;
end
temp2=[]
temp2=[mean(BigMatrix_Close2open(451:500,:)') meanTime];
    figure;plot(temp2)
    tt=find(temp2>0);
    
    filt_temp2=temp2(1:length(tt));
    [b,a]=butter(5,0.5);
    filt_temp2=filtfilt(b,a,filt_temp2);
    figure;plot(filt_temp2)
    
    
    
    
    
    
