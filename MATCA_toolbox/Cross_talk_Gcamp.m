function Cross_talk_Gcamp  
tic
% msgbox('Select a single ic file from each of your 1. and 2. sessions, respectively');
   [imagefile,image_dir]=uigetfile('*.','Load your Reference Images')
   [pathdata,namedata,format]=fileparts(imagefile);
   
%       [imagefile2,image_dir2]=uigetfile('.*','Load your Reference Images')
%    [pathdata2,namedata2,format2]=fileparts(imagefile2);
   
    
   comb_cell=imread([image_dir imagefile]);
   imagepath=char(inputdlg(['Is file tag without a number ending is true?:' ' '  namedata]));
   if(isempty(imagepath))
       imagepath=namedata;
   end
 root_dir=fileparts(image_dir);   
 mkdir(root_dir,'stableICs');  
 MaxDist=[];
nn=str2double(char(inputdlg('Enter a saving# for stable ICs')));  
calciumdata=menu('Include calcium dynamics?', 'YES','NO');
if(calciumdata==1)
    

% 
% Image_dir1=uigetdir('','Locate the 1.day Images');
% root_dir=fileparts(Image_dir1);
% Image_dir2=uigetdir('','Locate the 2.day Images');
% mkdir(root_dir,'stableICs');
% SaveIm=char(inputdlg('Would you like to save the image files? (y/n)   ', 's'));
% MaxDist=str2double(char(inputdlg('Enter the Max inter-cell allowance: ')));
% MaxDist=[];
% nn=str2double(char(inputdlg('Enter a saving number for the inter cell distance matrix:')));
[transfile transdir]=uigetfile('*.','Transients_ReferenceDataset');
[eventsfile eventsdir]=uigetfile('*.','Events_ReferenceDataset');
a1=load([transdir transfile]);
a11=load([eventsdir eventsfile]);
% cells_transients=struct2array(a);
cells_transients_ref=a1(:,2:end);
cells_events_ref=a11(:,2:end);
% [transfile transdir]=uigetfile('.*','Transients_EPMONLY');
% [eventsfile eventsdir]=uigetfile('.*','Events_EPM');
a2=a1;
a22=a11;

% cells_transients=struct2array(a);
cells_transients_epm=a2(:,2:end);
cells_events_epm=a22(:,2:end);

% cells_transients_ref=cells_transients_ref(4501:4500+length(cells_transients_epm),:);
% cells_events_ref=cells_events_ref(4501:4500+length(cells_events_epm),:);

% 
% Kernel_ref=Conv_Kernel(cells_transients_ref,cells_events_ref);      %%Using external function 
% Kernel_epm=Conv_Kernel(cells_transients_epm,cells_events_epm);
end
toc
%%
tic

Image_dir=pwd;
image_dir2=image_dir;
     num_cell1=length(dir([image_dir imagepath '*' format]));
     num_cell2=length(dir([image_dir imagepath '*' format]));

  xy_cell1=zeros(num_cell1,2);
   xy_cell2=zeros(num_cell2,2);
Comb_cell1=imread([image_dir imagepath format]); Comb_cell2=imread([image_dir2 imagepath format]);
        BW1=im2bw(Comb_cell1);BW2=im2bw(Comb_cell2);
        [x1,y1]=find(BW1>0);[x2,y2]=find(BW2>0);
        xc1=mean(y1);yc1=mean(x1);xc2=mean(y2);yc2=mean(x2);
        xy_cell1(1,1)=xc1;xy_cell1(1,2)=yc1;xy_cell2(1,1)=xc2;xy_cell2(1,2)=yc2;
        
        
            diameter1=zeros(2,num_cell1);
        diameter_1=max(x1)-min(x1);diameter_2=max(y1)-min(y1);
        diameter1(:,1)=[diameter_1;diameter_2];
        
    for i=1:(num_cell1-1)
        cell1=imread([image_dir imagepath num2str(i) format]);
        BW1=im2bw(cell1);
        [x1,y1]=find(BW1>0);
        xc1=mean(y1);yc1=mean(x1);
        xy_cell1(i+1,1)=xc1;xy_cell1(i+1,2)=yc1;
        Comb_cell1=imadd(Comb_cell1,cell1);
             diameter_1=max(x1)-min(x1);
        diameter_2=max(y1)-min(y1);
        diameter1(:,i)=[diameter_1;diameter_2];
          
    end
    
%     Comb_cell(find(Comb_cell>0))=20;
    BW_combcell1=im2bw(Comb_cell1);
%     figure;
   figure(101);subplot(331); imshow(BW_combcell1);hold on;set(gcf,'Color',[1 1 1])
    hold on;plot(xy_cell1(:,1),xy_cell1(:,2),'b.','MarkerSize',5)
    colormap(gray);title('Cells-1');axis normal;
    %
    imwrite(Comb_cell1,[image_dir,'/BaseImage.jpeg'])
    save([image_dir '/xy_cell.mat'],'xy_cell1')
%     save([image_dir '/xy_cell'],'xy_cell1','-ascii')
    
         diameter2=zeros(2,num_cell2);
        diameter_1=max(x2)-min(x2);diameter_2=max(y2)-min(y2);
        diameter2(:,1)=[diameter_1;diameter_2];
    
    
    for ii=1:(num_cell2-1)
       cell2=imread([image_dir2 imagepath num2str(ii) format]);
        BW2=im2bw(cell2);
        [x2,y2]=find(BW2>0);
        xc2=mean(y2);yc2=mean(x2);
        xy_cell2(ii,1)=xc2;xy_cell2(ii,2)=yc2;
        Comb_cell2=imadd(Comb_cell2,cell2);
             diameter_1=max(x2)-min(x2);
        diameter_2=max(y2)-min(y2);
        diameter2(:,ii)=[diameter_1;diameter_2];

    end
%     Comb_cell(find(Comb_cell>0))=20;
    BW_combcell2=im2bw(Comb_cell2);
%     figure;
%    subplot(232); imshow(BW_combcell2);hold on
%     hold on;plot(xy_cell2(:,1),xy_cell2(:,2),'r.','MarkerSize',5)
%     colormap(gray);title('Cell-2');axis normal;
    %
    imwrite(Comb_cell2,[image_dir2,'/BaseImage.jpeg'])
    save([image_dir2 '/xy_cell.mat'],'xy_cell2')
%     save([Image_dir2 '/xy_cell'],'xy_cell2','-ascii')
    
%     subplot(233);contour(BW_combcell1);hold on;contour(BW_combcell2);axis normal;view(0,-90)
%     hold on;plot(xy_cell1(:,1),xy_cell1(:,2),'b.','MarkerSize',5);plot(xy_cell2(:,1),xy_cell2(:,2),'r.','MarkerSize',5);title('Merged');
    
    %%Sele
    xy1=zeros(length(xy_cell1),length(xy_cell1));
    for i=1:length(xy_cell1)
for k=1:length(xy_cell1)
xy1(i,k)=sqrt([power(xy_cell1(i,1) - xy_cell1(k,1),2) + power(xy_cell1(i,2) - xy_cell1(k,2),2)]);
end
    end
    
    toc
    %%
    
    
    CC=zeros(size(xy1));
[b,a]=butter(2,[0.4 0.9],'bandpass');
filt_transients=filtfilt(b,a,cells_transients_ref);
filt_transients2=filtfilt(b,a,cells_transients_epm);

for k=1:num_cell1
for j=1:num_cell1
% cell1=imread([image_dir imagepath num2str(j) format]);
% cell2=imread([image_dir imagepath num2str(k) format]);

 C=corr(abs(hilbert(filt_transients(:,k))),abs(hilbert(filt_transients(:,j))),'Type','Spearman');
    CC(k,j)=C;
end
end

normxy1=xy1/max(max(xy1));

CCC=(1./normxy1).*CC;
CCC(find(isinf(CCC)))=0;
figure(101);subplot(3,3,2);imagesc(normxy1);axis tight;colormap gray;title('Inter-cell Centoids','FontSize',16);colorbar
figure(101);subplot(3,3,3);imagesc(CC);axis tight;colormap gray;title('Temporal Correlation','FontSize',16);colorbar
caxis([0 0.5])    
figure(101);subplot(3,3,4);imagesc(CCC);title('False correlation','FontSize',16);colorbar

figure(101);subplot(3,3,5);hold on;set(gca,'FontSize',15);title('Spatio-temporal Regression');xlabel('cell');ylabel('Spearman R');
for i=1:length(CC)
figure(101);subplot(3,3,5);plot(xy1(i,:),CC(i,:),'b.')
% if(any(xy1(i,:)<10))
% hold on;plot(xy1(i,:),CC(i,:),'r.')
% end
end
axis tight
   
   %% ColorCoding the
   for jk=1:15
   Thresh=jk;
   Inter_cell_dist=1;
   while Inter_cell_dist<21
      ccc=Comb_cell1;
      ccc(ccc>0)=10;
   
%          Thresh_in=str2double(char(inputdlg('Enter the coeff threshold:')));
%    if isnan(Thresh_in)        
%    else
%        Thresh=Thresh_in
%    end
   [Xx,Yy]=find(CCC>Thresh);
   figure(101);subplot(3,3,6);image(ccc)
   ss=[];
     for i=1:length(Xx)
    ss(i)=xy1(Xx(i),Yy(i));
    end
    prc=prctile(ss,[95]);
    Cell_perc(Inter_cell_dist)=length(find(ss<Inter_cell_dist))/length(ss)*100;
    Inter_cell_dist=Inter_cell_dist+1;
    
   end
%    figure(10);subplot(5,2,jk);
   figure(101);subplot(3,3,7);hold on;plot(1:20,Cell_perc,'ro','LineWidth',2)
   figure(101);subplot(3,3,7);hold on;plot(1:20,Cell_perc,'b','LineWidth',2)
   txt1= [ 'Thresh=' num2str(Thresh) ''];
   lx=randi(10);
   text(7,Cell_perc(7),txt1,'HorizontalAlignment','left','FontSize',16,'Color','k')
   end
   
   
   Thresh_in=str2double(char(inputdlg('Enter the coeff threshold:')));
   if isnan(Thresh_in)        
   else
       Thresh=Thresh_in;
   end
   
   [Xx,Yy]=find(CCC>Thresh);
    
   %%
   for ij=1:length(Xx);
       if(Xx(ij)==1)
            cell1=imread([image_dir imagepath  format]);
       else
          cell1=imread([image_dir imagepath num2str(Xx(ij)-1) format]); 
       end
       
   if(Yy(ij)==1)
       cell2=imread([image_dir imagepath format]); 
   else
   cell2=imread([image_dir imagepath num2str(Yy(ij)-1) format]);
   end
%     coeff_color=50*CCC(Xx(ij),Yy(ij));
    
     cell1(cell1>0)=20;
     cell2(cell2>0)=20;
    figure(101);subplot(3,3,6);hold on;contour(cell1,'LineWidth',3);hold on;contour(cell2,'LineWidth',3);
   end
   colormap bone(20)
    %%
    
    falsecells=zeros(1,length(xy_cell1))
for ci=1:length(xy1)
if(any(find(Xx==ci)))
falsecells(Xx(find(Xx==ci)))=1;
end
end


FalseCells=find(falsecells>0);
    
    
    Ccount=zeros(power(ceil(length(CCC)/2),2),1)';
    
    ij=1;for i=1:length(CCC)
    ll=length(CCC(i,ij:end));
    a=find(Ccount==0);
    Ccount(a(1):a(1)+ll-1)=CCC(i,ij:end);
    end
%     figure;bar(Ccount)
%     figure;hist(Ccount,length(CCC))


    corr_stat=[]
    for i=1:length(Xx)
        corr_stat(i)=CC(Xx(i),Yy(i));
    end
    
       bigMatrix=  [Xx Yy  diameter1(Xx) (abs([xy1(Yy)-  xy1(Xx)])) corr_stat']
       bigMatrix2=[xy_cell1 median(diameter1)' falsecells']
       
       
    
%         xy2=zeros(length(xy_cell2),length(xy_cell2));
%     for i=1:length(xy_cell2)
% for k=1:length(xy_cell2)
% xy2(i,k)=sqrt([power(xy_cell2(i,1) - xy_cell2(k,1),2) + power(xy_cell2(i,2) - xy_cell2(k,2),2)]);
% end
%     end
%     
%     min_intercell1=[];min_intercell2=[];
% for i=1:length(xy1)
%     temp=sort(xy1(i,:));
%     min_intercell1(i)=temp(2);          %determine the min inter-cell distance for each cell
% end
% for i=1:length(xy2)
%     temp=sort(xy2(i,:));
%     min_intercell2(i)=temp(2);          %determine the min inter-cell distance for each cell
% end
%     
%    minxy1= min(xy1(find(xy1>0)));
%    
% 
%    xy=zeros(length(xy_cell1),length(xy_cell2));
%    for i=1:length(xy_cell1)
% for k=1:length(xy_cell2)
%     xy(i,k)=sqrt([power(xy_cell1(i,1) - xy_cell2(k,1),2) + power(xy_cell1(i,2) - xy_cell2(k,2),2)]);
% end
%    end
%    xy=xy'; 
%    
%    
%    
% close_cells=[]
% for i=1:length(xy1)
% temp=find(xy1(:,i)>0 & xy1(:,i)<5);
% if(isempty(temp))
%     close_cells(i)=0
% else
%    close_cells(i)=temp(1)   %%only one close cells fix this for all later
% end
% end
% 
% matched_cells=[find(close_cells>0) ;close_cells(close_cells>0)]
% 
% for ii=1:length(matched_cells)
%     figure(1);clf;plot(abs(hilbert(cells_transients_ref(:,matched_cells(1,ii)))))
%     hold on;plot(abs(hilbert(cells_transients_ref(:,matched_cells(2,ii)))))
%     tempc=corrcoef(cells_transients_ref(:,matched_cells(:,ii)));
%     cc(ii)=tempc(2,1);
% %     pause;
% 
%         dlys(ii)=finddelay(cells_transients_ref(:,matched_cells(1,ii)),cells_transients_ref(:,matched_cells(2,ii)));
%     
% end
% 
% 
% for ii=1:length(matched_cells)
% tempc=corrcoef(cells_transients_epm(find(cells_transients_ref(:,matched_cells(1,ii))>0),matched_cells(:,ii)));
% cc2(ii)=tempc(1,2);
% end
% 
% % ccs=[];
% % for kk=1:225
% % for ii=1:225
% %     ch=randi(225);
% % tempc=corrcoef(cells_transients_ref(find(cells_transients_epm(:,kk)>0),[kk ii]));
% % ccs(kk,ii)=tempc(1,2);
% % end
% % ccs(kk,kk)=0;
% % end   
% 

% 
%  rawCorr=corrcoef(filt_transients);
% for i=1:min(size(cells_transients_epm));
% rawCorr(i,i)=0;
% end 
% %   maxCorrcell=[]
% for i=1:min(size(cells_transients_epm));
% maxCorrcell(i)=find(rawCorr(:,i)==max(rawCorr(:,i)));
% Cdist(i)=xy1(i,maxCorrcell(i));
% end   
%    
%    
% normXY=[];   
%    for j=1:min(size(xy))
% normXY(:,j)=xy(:,j)./max(xy(:,j));
% end
% figure;imagesc(normXY)
% Spatial_tempCoh=rawCorr./normXY;
%    
%    
%    count=0;
% for jj=1:min(size(Spatial_tempCoh));
% crosstalk_cells(jj)=length(find(Spatial_tempCoh(:,jj)>1));
% if(crosstalk_cells(jj)>0)
% count=count+crosstalk_cells(jj);
% end
% end
%    
%    
%    
% 
%    
%    
%    userinp=char(inputdlg([num2str(count) ' ' 'suspicious cases detected' ';' 'Would you like to check?'],'Crosstalk Bug Report?'));
% 
% if(userinp=='y')
% contaminated_cells=[];
% temp=find(crosstalk_cells>0);
% for jk=1:length(temp)
% crossC=find(Spatial_tempCoh(temp(jk),:)>1);
% figure;plot(cells_transients_epm(:,[temp(jk) crossC]));
% %      pause;
% userinp2=char(inputdlg('Mark the cells?: (y/n)'));
% if(userinp2=='y')
% contaminated_cells=[contaminated_cells 0 temp(jk) crossC]
% end
% end
% end
toc
end