
%   Image_dir=([savedir,'/Images']);
% function Centroid_shifts_GUI
% Centroid.fh = figure('Visible','on','Position',[20,20,1500,1000],'Units','normalized');
% set(gcf,'Name','StableCellImaging','Color',[0.98 0.98 0.99],'NumberTitle','off')

% Centroid.load=uicontrol('Parent', Centroid.fh,'Style','pushbutton','String','Load Data','Position',[220,840,100,50],'Callback',@images,'FontSize',16,'Units','normalized');

function Centroid_shifts
tic
   msgbox('Select a single ic file from each of your 1. and 2. sessions, respectively');
   [imagefile,image_dir]=uigetfile('.*','Load your Reference Images');
   [pathdata,namedata,format]=fileparts(imagefile);
   
      [imagefile2,image_dir2]=uigetfile('.*','Load your Reference Images');
   [pathdata2,namedata2,format2]=fileparts(imagefile2);
   
    
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
[transfile transdir]=uigetfile('.*','Transients_ReferenceDataset');
[eventsfile eventsdir]=uigetfile('.*','Events_ReferenceDataset');
a1=load([transdir transfile]);
a11=load([eventsdir eventsfile]);
% cells_transients=struct2array(a);
cells_transients_ref=a1(:,2:end);
cells_events_ref=a11(:,2:end);
[transfile transdir]=uigetfile('.*','Transients_EPMONLY');
[eventsfile eventsdir]=uigetfile('.*','Events_EPM');
a2=load([transdir transfile]);
a22=load([eventsdir eventsfile]);

% cells_transients=struct2array(a);
cells_transients_epm=a2(:,2:end);
cells_events_epm=a22(:,2:end);

cells_transients_ref=cells_transients_ref(4501:4500+length(cells_transients_epm),:);
cells_events_ref=cells_events_ref(4501:4500+length(cells_events_epm),:);


Kernel_ref=Conv_Kernel(cells_transients_ref,cells_events_ref);      %%Using external function 
Kernel_epm=Conv_Kernel(cells_transients_epm,cells_events_epm);


end

Image_dir=pwd;
     num_cell1=length(dir([image_dir imagepath '*' format]));
     num_cell2=length(dir([image_dir2 imagepath '*' format2]));

  xy_cell1=zeros(num_cell1,2);
   xy_cell2=zeros(num_cell2,2);
Comb_cell1=imread([image_dir imagepath format]); Comb_cell2=imread([image_dir2 imagepath format2]);

errorcheck1='n';
if(isequal(size(Comb_cell1),size(Comb_cell2)))
else
    errordlg('Loaded image sizes are not equal!');
    pause(1);
    errorcheck1=char(inputdlg('Like to still proceed? :(y/n)'));
    
end

if(errorcheck1=='y')
%Added for different size of images
ssize1=size(Comb_cell1);
ssize2=size(Comb_cell2);            
s1=min(ssize1(1),ssize2(1));
s2=min(ssize1(2),ssize2(2));

ss1=abs(ssize1(1)-ssize2(1));
ss2=abs(ssize1(2)-ssize2(2));

add_shift=sqrt((ss1/2)^2+(ss2/2)^2);



        BW1=im2bw(Comb_cell1);BW2=im2bw(Comb_cell2);
        [x1,y1]=find(BW1>0);[x2,y2]=find(BW2>0);
        xc1=mean(y1);yc1=mean(x1);xc2=mean(y2);yc2=mean(x2);
        xy_cell1(1,1)=xc1;xy_cell1(1,2)=yc1;xy_cell2(1,1)=xc2;xy_cell2(1,2)=yc2;
        
%         


% Image_dir=pwd;
%      num_cell1=length(dir([Image_dir1,'/ic*.tif']));
%      num_cell2=length(dir([Image_dir2,'/ic*.tif']));
%   xy_cell1=zeros(num_cell1,2);
%    xy_cell2=zeros(num_cell2,2);
% Comb_cell1=imread([Image_dir1,'/ic.tif']); Comb_cell2=imread([Image_dir2,'/ic.tif']); 
%         BW1=im2bw(Comb_cell1);BW2=im2bw(Comb_cell2);
%         [x1,y1]=find(BW1>0);[x2,y2]=find(BW2>0);
%         xc1=mean(y1);yc1=mean(x1);xc2=mean(y2);yc2=mean(x2);
%         xy_cell1(1,1)=xc1;xy_cell1(1,2)=yc1;xy_cell2(1,1)=xc2;xy_cell2(1,2)=yc2;
%         
% %         
%         Kernel_ref=Conv_Kernel(cells_transients_ref,cells_events_ref);      %%Using external function 
%         Kernel_epm=Conv_Kernel(cells_transients_epm,cells_events_epm);
%         
%         
%%
        
        diameter1=zeros(2,num_cell1);
        diameter_1=max(x1)-min(x1);diameter_2=max(y1)-min(y1);
        diameter1(:,1)=[diameter_1;diameter_2];
        
    for i=1:(num_cell1-1)
        cell1=imread([image_dir imagepath num2str(i) format]);
        BW1=im2bw(cell1);
        [x1,y1]=find(BW1>0);
        xc1=mean(y1);yc1=mean(x1);
        xy_cell1(i,1)=xc1;xy_cell1(i,2)=yc1;
        Comb_cell1=imadd(Comb_cell1,cell1);
             diameter_1=max(x1)-min(x1);
        diameter_2=max(y1)-min(y1);
        diameter1(:,i)=[diameter_1;diameter_2];
          
    end
    
%     Comb_cell(find(Comb_cell>0))=20;
    BW_combcell1=im2bw(Comb_cell1);
%     figure;
   figure;subplot(231); imshow(BW_combcell1);hold on;set(gcf,'Color',[1 1 1])
    hold on;plot(xy_cell1(:,1),xy_cell1(:,2),'b.','MarkerSize',5)
    colormap(gray);title(['Image-1:'  '  ' num2str(num_cell1') ' cells']);axis on;axis normal
    %
    imwrite(Comb_cell1,[image_dir,'/BaseImage.jpeg'])
    save([image_dir '/xy_cell.mat'],'xy_cell1')
%     save([image_dir '/xy_cell'],'xy_cell1','-ascii')
    
         diameter2=zeros(2,num_cell2);
        diameter_1=max(x2)-min(x2);diameter_2=max(y2)-min(y2);
        diameter2(:,1)=[diameter_1;diameter_2];
    
    
    for ii=1:(num_cell2-1)
       cell2=imread([image_dir2 imagepath num2str(ii) format2]);
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
   subplot(232); imshow(BW_combcell2);hold on
    hold on;plot(xy_cell2(:,1),xy_cell2(:,2),'r.','MarkerSize',5)
    colormap(gray);title(['Image-2:' ' ' num2str(num_cell2) ' cells']);axis on;axis normal
    %
    imwrite(Comb_cell2,[image_dir2,'/BaseImage.jpeg'])
    save([image_dir2 '/xy_cell.mat'],'xy_cell2')
%     save([Image_dir2 '/xy_cell'],'xy_cell2','-ascii')
    
    subplot(234);contour(BW_combcell1);hold on;contour(BW_combcell2);axis normal;view(0,-90)
    hold on;plot(xy_cell1(:,1),xy_cell1(:,2),'b.','MarkerSize',5);plot(xy_cell2(:,1),xy_cell2(:,2),'r.','MarkerSize',5);title('Merged');
    
    %%Sele
    xy1=zeros(length(xy_cell1),length(xy_cell1));
    for i=1:length(xy_cell1)
for k=1:length(xy_cell1)
xy1(i,k)=sqrt([power(xy_cell1(i,1) - xy_cell1(k,1),2) + power(xy_cell1(i,2) - xy_cell1(k,2),2)]);
end
    end
    
        xy2=zeros(length(xy_cell2),length(xy_cell2));
    for i=1:length(xy_cell2)
for k=1:length(xy_cell2)
xy2(i,k)=sqrt([power(xy_cell2(i,1) - xy_cell2(k,1),2) + power(xy_cell2(i,2) - xy_cell2(k,2),2)]);
end
    end
    
    min_intercell1=[];min_intercell2=[];
for i=1:length(xy1)
    temp=sort(xy1(i,:));
    min_intercell1(i)=temp(2);          %determine the min inter-cell distance for each cell
end
for i=1:length(xy2)
    temp=sort(xy2(i,:));
    min_intercell2(i)=temp(2);          %determine the min inter-cell distance for each cell
end
    

    
    
   minxy1= min(xy1(find(xy1>0)));
% [xmin,ymin]=find(xy==min(xy(find(xy>0))))

subplot(2,3,3);hist(min_intercell1);hold on;hist(min_intercell2);
xlabel('pix','FontSize',16);ylabel('#cells','FontSize',16);box off;


subplot(2,3,5);hist(min_intercell1);hold on;hist(min_intercell2);
xlabel('pix','FontSize',16);ylabel('#cells','FontSize',16);box off
set(get(gca,'child'),'FaceColor','none','EdgeColor','k');axis tight;box off;

%%
 xy=zeros(length(xy_cell1),length(xy_cell2));
   for i=1:length(xy_cell1)
for k=1:length(xy_cell2)
    xy(i,k)=sqrt([power(xy_cell1(i,1) - xy_cell2(k,1),2) + power(xy_cell1(i,2) - xy_cell2(k,2),2)]);
end
   end
   xy=xy';
% end
% 
% if(length(xy1)>length(xy))
% ll=length(xy1);
% reference_distances=xy;
% entire_distances=xy1;
% else
%     ll=length(xy);
%     reference_distances=xy1;
%     entire_distances=xy;
%     
% end

% -- Thresholding --
% subplot(2,3,4)
thresh_sel=menu('Threshold reference:', 'Min intercell in Image-1', 'Smallest cell radius', 'Manual')
if(thresh_sel==1)
max_dist_allow=minxy1;
elseif(thresh_sel==2)
max_dist_allow=min(mean(diameter1')/2);
else
    max_dist_allow=str2double(inputdlg('Enter a threshold value in pixels'));
end
    
max_dist_allow=max_dist_allow+add_shift;

if(MaxDist>0)
max_dist_allow=MaxDist;
end

ll=min(size(xy));

bb=zeros(1,ll);
for i=1:ll
if(min(xy(i,:))<max_dist_allow)
% plot(xy_cell2(i,1),xy_cell2(i,2),'ro','MarkerSize',8);hold on


% a=a+1
b=find(xy(i,:)==min(xy(i,:)));
% plot(xy_cell1(b,1),xy_cell1(b,2),'b.')
bb(i)=b
end
end
    overlaps=find(bb>0);
    
    matched_cells=[bb(find(bb>0))' find(bb>0)' ];

    Comb_cell=Comb_cell1;
    Comb_cell(find(Comb_cell>0))=3;    
    cell=imread([image_dir2 imagepath num2str(ii) format2]);
    if(ssize1(1)<ssize2(1))
        cell=cell(1:s1,1:s2);
    elseif(ssize1(1)>ssize2(1))
        Comb_cell=Comb_cell(1:s1,1:s2);
    end
        
           if(strcmp(class(Comb_cell),class(cell)));
          else
              Comb_cell=single(Comb_cell);
           end
          
      Comb_cell=imadd(Comb_cell,cell);
            Comb_cell(find(Comb_cell>3))=5;

    for ii=1:(length(xy_cell2)-1)
        cell=imread([image_dir2 imagepath num2str(ii) format2]);
           if(ssize1(1)<ssize2(1))
              cell=cell(1:s1,1:s2);
            elseif(ssize1(1)>ssize2(1))
                 Comb_cell=Comb_cell(1:s1,1:s2);
           end
           if(strcmp(class(Comb_cell),class(cell)))
          else
              Comb_cell=single(Comb_cell)
          end
      Comb_cell=imadd(Comb_cell,cell);
            Comb_cell(find(Comb_cell>3))=5;
    end
%        figure;imagesc(Comb_cell)
    
    
    
    for i=1:length(matched_cells)
        if(matched_cells(i,1)==1)
            cell=imread([image_dir imagepath num2str(i) format]);
        else
%               cell=imread([Image_dir1,'/ic',num2str(matched_cells(i,1)-1),'.tif']);
                cell=imread([image_dir imagepath num2str(matched_cells(i,1)-1) format]);
        end
           if(strcmp(class(Comb_cell),class(cell)))
          else
              Comb_cell=single(Comb_cell);
              cell=single(cell);
           end
             if(ssize1(1)>ssize2(1))
              cell=cell(1:s1,1:s2);
            elseif(ssize1(1)<ssize2(1))
                 Comb_cell=Comb_cell(1:s1,1:s2);
           end
        Comb_cell=imadd(Comb_cell,cell);
            Comb_cell(find(Comb_cell>5))=10;
    end
    
    for i=1:length(matched_cells)
        if(matched_cells(i,2)==1)
            cell=imread([image_dir2 imagepath num2str(i) format2]);
        else
              cell=imread([image_dir2 imagepath num2str(matched_cells(i,2)-1) format2]);
        end
        
           if(ssize1(1)<ssize2(1))
        cell=cell(1:s1,1:s2);
            elseif(ssize1(1)>ssize2(1))
        Comb_cell=Comb_cell(1:s1,1:s2);
           end
            
          if(strcmp(class(Comb_cell),class(cell)))
          else
              Comb_cell=single(Comb_cell)
          end
        Comb_cell=imadd(Comb_cell,cell);
            Comb_cell(find(Comb_cell>10))=20;
    end
    
    
    
    
   subplot(236);imagesc(Comb_cell);colormap gray

    
    
%     
%     Comb_cell=Comb_cell1;
%     Comb_cell(find(Comb_cell>0))=5;
%   for i=1:length(overlaps)
%         if(overlaps(i)==1)
%         cell=imread([Image_dir1,'/ic.tif']);
%         else   
%         cell=imread([Image_dir1,'/ic',num2str(overlaps(i)-1),'.tif']);
%         if(SaveIm=='y')
%         copyfile([Image_dir1,'/ic',num2str(overlaps(i)-1),'.tif'],[root_dir,'/stableICs/ic',num2str(overlaps(i)-1) '.tif'])
%         end
%         end
%         Comb_cell=imadd(Comb_cell,cell);
%   end
%     Comb_cell(find(Comb_cell>5))=20;
%     subplot(234);imagesc(Comb_cell);title(['Stably Monitored in two sessions: ' num2str(length(overlaps)) ' Cells'])

for i=1:length(xy1)-1
xxyy1(i)=min(xy1(i,i+1:end));
end
meanxy1=mean(xxyy1);

minxy=min(xy');
meanxy=mean(minxy);
mminxy=min(minxy);


xy1cell_loc=sqrt(xy_cell1(:,1).^2+xy_cell1(:,2).^2);
xy2cell_loc=sqrt(xy_cell2(:,1).^2+xy_cell2(:,2).^2);
for i=1:length(overlaps)
temp(i,1)=xy1cell_loc(matched_cells(i,1));
temp(i,2)=xy2cell_loc(matched_cells(i,2));
end
[h,p,k]=ttest2(temp(:,1),temp(:,2));
mmdiff=mean(abs(diff(temp')));

selected_shifts=abs(temp(:,1)-temp(:,2));

   tt1=sprintf(['Stably Monitored btw sessions:' num2str(length(overlaps)) ' cells' '\nMedianShifts=' num2str(median(selected_shifts))])
    title(tt1);axis tight

subplot(235);
% hist(xxyy1,50)
hold on;hist(minxy);
% set(get(gca,'child'),'FaceColor','none','EdgeColor','r');axis tight;box off;
hist(selected_shifts);
ylabel('pixels');
legend('Inter-cell','Shifts')

   tt2=sprintf([num2str(length(overlaps)) '  from  ' num2str(length(xy_cell2)) '  Cells'  '\nThresholded at ' num2str(max_dist_allow) 'pix' '\nImage offset:' num2str(add_shift) 'pix'])
    title(tt2)
    
    legend('Imaging-1','Imaging-2','Imaging 1-2 (all cells','Imaging 1-2 (qualified)')

subplot(233);
    titlebar=sprintf(['Mean dist#1:' ' ' num2str(meanxy) ' pix' '\nMean dist#2:' ' ' num2str(meanxy1) ' pix' '\nMin inter-cell dist:' num2str(minxy1) ' pix']);
title(titlebar)
    
% bar([1 2],[meanxy1 minxy1],'b') ;hold on;bar([3 4],[meanxy mminxy],'r');xlabel(['1.cells Mean-Min'  '   '  '1-2 Cells Mean-Min']);box off
% subplot(236);bar(2,[mmdiff+mean(xy2cell_loc)],0.2,'r');
% hold on;bar([1 2],[mean(xy1cell_loc) mean(xy2cell_loc)],0.2,'b');box off
% 
% if h>0
%     sstitle='Significant'
% else
%     sstitle='NOT Significant'
%     title([sstitle,' ','meanError= ',num2str(mmdiff),'µm'])
% end    

%%
% figure;subplot(211);hist(xxyy1,50)
% set(get(gca,'child'),'FaceColor','none','EdgeColor','b');axis tight;box off;
% hold on;hist(minxy,50);legend('Within','Between')
% subplot(212);ksdensity(xxyy1)
% hold on

% diameter_within=[diameter1;diameter2];
% diameter_between=[diameter3;diameter4];
% ksdensity(minxy);legend('Within','Between');axis tight;box off;;title('KS Distribution')
% save([root_dir '/cell2cell_dist' num2str(nn) '.mat'],'xy')
% save([root_dir '/minbetweenses_dist' num2str(nn) '.mat'],'minxy')
% save([root_dir '/matched_cells' num2str(nn) '.mat'],'overlaps')
% save([root_dir '/Within_diameters' num2str(nn) '.mat'],'diameter1')
% save([root_dir '/Between_diameters' num2str(nn) '.mat'],'diameter2')
% save([root_dir '/StableCells' num2str(nn) '.mat'],'matched_cells')


toc
end
end
%%
