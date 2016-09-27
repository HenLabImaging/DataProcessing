function cell_centroids()

[FirstImage,Image_dir]=uigetfile('.*','Locate your 1.Cell');
imagerange=str2num(char(inputdlg('Enter the Image range (16 30 for cell16-cell30)')));
if(isempty(char(imagerange)))
    imagerange=[1 length(dir([Image_dir,'*.tif']))];
end
% imagerange=str2num(char(imagerange));
if(isempty(imagerange))
    errordlg('Make sure you enter the image range')
end
% [LastImage,Image_dir]=uigetfile('.*','Locate the First Cell Image')

    if(FirstImage>0)
    [pathImage,NameImage,ExtImage] = fileparts(FirstImage)
    end

  imagepath=char(inputdlg(['Is file tag without a number ending is true?:' ' '  NameImage]));
   if(isempty(imagepath))
       imagepath=namedata;
   end    
        NameImage=imagepath;

        
num_cell=diff(imagerange);
xy_cell=zeros(num_cell,2);
 
if(exist([Image_dir NameImage ExtImage]))
Comb_cell=imread([Image_dir NameImage ExtImage]); 
          BW=im2bw(Comb_cell);
          [x,y]=find(BW>0);
            xc=mean(y);yc=mean(x);
            xy_cell(1,1)=xc;xy_cell(1,2)=yc;
          imagerange(end)=imagerange(end)-1;
else
    Comb_cell=imread([Image_dir NameImage num2str(imagerange(1)) ExtImage]);
    Comb_cell=single(zeros(size(Comb_cell)));
  
end

% 



    for i=imagerange(1):imagerange(2)
        try
        cell=imread([Image_dir NameImage num2str(i) ExtImage]);
        catch
            errordlg(['Iteration exceeds your file size!!!' ,  '  '  'Actual N of images' '  ' ,num2str(i-1),  ' ; ' 'Entered images size:'  ' ', num2str(imagerange(2))] );
        end
    if(size(cell,3)>1)
        cell=rgb2gray(cell);
    end
    BW=im2bw(cell);
    [x,y]=find(BW>0);
    xc=mean(y);yc=mean(x);
    xy_cell(i,1)=xc;xy_cell(i,2)=yc;
    Comb_cell=imadd(Comb_cell,cell);
    end

    BW_combcell=im2bw(Comb_cell);
figure;imshow(BW_combcell);hold on
plot(xy_cell(:,1),xy_cell(:,2),'r.')
colormap(gray);title('Raw Cells')
    
%
imwrite(Comb_cell,[Image_dir,'/BaseImage.jpeg'])
save([Image_dir '/cell_coordinates.mat'],'xy_cell')
save([Image_dir '/cell_coordinates'],'xy_cell','-ascii')

pause(5);
close(gcf)

end

