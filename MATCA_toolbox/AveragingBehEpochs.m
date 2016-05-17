function AveragingBehEpochs(fs,fs_video,time1,time2,var1,var2)

% 
if nargin < 1;errordlg('load a dataset'); end;
if nargin < 2;errordlg('Sampling frequency required');end
%%
 NofDataSet=str2double(char(inputdlg(['How many dataset would you like to roll? '])));
 for N=1:NofDataSet
 
% uiwait(msgbox('Enter your behavioral data!'))
% [beh dir]=uigetfile('.*','Enter behavior data');
% [pathdata,namedata,format]=fileparts(beh);
% 
% 
% 
% fs_video=round(length(beh)/(beh(end,1)-beh(1,1)));
% fs_in=char(inputdlg(['Is your video sampling rate: ' num2str(fs_video) '?' ' '  'y/n']));
% if(fs_in~='y')
%     fs_video=str2double(char(inputdlg('Enter the correct Video sampling rate:')));
% end
% if nargin < 3;
DATA=DataRead(5,'','','','');
beh=DataRead(fs_video,'','','','');

data=DATA(:,2:end);
Ncells=min(size(data));
% end

% fs_video=str2double(char(inputdlg('Enter your video sampling rate')));

beh_column=str2double(char(inputdlg('Enter the behavioral column you like to analyze')));

sampling_conv=fs_video/fs;

TimeW=str2double(char(inputdlg('Enter a Time Window size in seconds: ')));
if(isnan(TimeW))
    TimeW=10;
    errordlg('Time Window was skipped, default window is 10 sec')
end

% data=DataRead(5.'','','','');
% data=DATA(:,2:end);

% timeind=round(beh(find(beh(:,3)>0),2));
% dtimeind= diff(timeind);
% 
% intertimeind=find(dtimeind>10);
% timeind(intertimeind)
% 

norm_data=normdata(data);

data=norm_data;

% [pks,locs]=findpeaks(beh(:,3),30)
[pks,locs]=findpeaks(beh(:,beh_column));
datalocs=round(locs/sampling_conv);

beh_epochs=[];
TimeWW=fs*TimeW;
rmdown=find(datalocs<TimeWW);
rmup=find(datalocs>(length(data)-TimeWW));
datalocs(rmdown)=[];
datalocs(rmup)=[];

if(length(datalocs)<2)
    errordlg('No behavioral episode has been found, Try another behavior column!')
end

for i=1:length(datalocs)
beh_epochs(i,:,:)=data(datalocs(i)-TimeWW+1:datalocs(i)+TimeWW,:);
end

t=linspace(-TimeW,TimeW,2*TimeWW);

average_beh_epoch=squeeze(mean(beh_epochs));

TFIDF=average_beh_epoch';Rated_bigXtoX=[];
temp22=0;
% TFIDF=dg1A';
mean2bigXtoX=[];
mean2bigXtoX=max(TFIDF(:,1:TimeWW)');
% Rated_bigXtoX=TFIDF;
sortedmeanbigXtoX=sort(mean2bigXtoX,'ascend');
for i=1:Ncells
temp2=find(mean2bigXtoX==sortedmeanbigXtoX(i));
if(length(temp2)>1)
for k=1:length(temp22)
aa=find(temp2==temp22(k));
temp2(aa)=[];
end
end
temp22(i)=min(temp2);
Rated_bigXtoX(i,:)=TFIDF(temp22(i),:);
end
% figure;pcolor(Rated_bigXtoX);shading flat;colormap jet(20);



figure;set(gcf,'Color',[1 1 1]);subplot(7,1,1:3);imagesc(t,1:Ncells,average_beh_epoch');title(['N of averaged epochs:'  num2str(length(datalocs)) '(IC cells)'],'FontSize',16);axis xy
shading flat;colormap jet(20);;ylabel('cells','FontSize',16);hold on;plot([0 0],[1 Ncells],'w:','LineWidth',3)
subplot(7,1,4:6);imagesc(t,1:Ncells,Rated_bigXtoX);axis xy;title(['N of averaged epochs:' num2str(length(datalocs)) ' (Rated Cells)'],'FontSize',16)
shading flat;colormap jet(20);xlabel('seconds','FontSize',16)
ylabel('cells','FontSize',16);hold on;plot([0 0],[1 Ncells],'w:','LineWidth',3)
subplot(7,1,7);plot(t,mean(squeeze(mean(beh_epochs))'),'k','LineWidth',2);hold on;plot([0 0],[min(mean(squeeze(mean(beh_epochs))')) max(mean(squeeze(mean(beh_epochs))'))],'r--','LineWidth',3);box off;axis tight
 end

end