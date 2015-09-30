close all

trans_ind_clockw=trans_ind_epm1;
trans_ind_c_clockw=trans_ind_epm2;
newtrans_ind_c_clockw=trans_ind_c_clockw(find(diff(trans_ind_c_clockw)>1))
newtrans_ind_clockw=trans_ind_clockw(find(diff(trans_ind_clockw)>1))
xxyy_down=downsample(xxyy,Sampling_factor);
TimeWindow=20; %sec
TimeW=TimeWindow*Fs_Im;


% norm_transients=zscore_transients;
% hold on;plot(xxyy_down(newtrans_ind_clockw,1),xxyy_down(newtrans_ind_clockw,2),'r.')
% hold on;plot(xxyy_down(newtrans_ind_c_clockw,1),xxyy_down(newtrans_ind_c_clockw,2),'k.')


figure;plot(xxyy(:,1),xxyy(:,2));
% gginput=char(inputdlg('How many transition point like to add?'));
trans1=ginput(4)
tempindx1=find(xxyy_down(:,1)<trans1(1,1));
tempindx2=find(xxyy_down(:,1)>trans1(2,1));
tempindy1=find(xxyy_down(:,2)<trans1(3,2));
tempindy2=find(xxyy_down(:,2)>trans1(4,2));
hold on;plot(xxyy_down(tempindx1,1),xxyy_down(tempindx1,2),'co')
hold on;plot(xxyy_down(tempindx2,1),xxyy_down(tempindx2,2),'co')
hold on;plot(xxyy_down(tempindy1,1),xxyy_down(tempindy1,2),'ro')
hold on;plot(xxyy_down(tempindy2,1),xxyy_down(tempindy2,2),'ro')

%%
zoneXXYY=zeros(length(xxyy_down),1);
tempzonexxyy=zeros(length(zoneXXYY),1);
zoneXXYY(tempindx1)=1; zoneXXYY(tempindx2)=1; zoneXXYY(tempindy1)=2; zoneXXYY(tempindy2)=2;
zoneXXYY2=zoneXXYY;
CenterPoints=find(zoneXXYY2==0); % removing the transition centers to include only passes
% zoneXXYY2(CenterPoints)=[];
diffzoneXXYY2=diff(zoneXXYY2);

% diffzoneXXYY2=cumsum(diff(zoneXXYY2));
% diff2zoneXXYY2=diff(diffzoneXXYY2);


% zoneXtoX=find(diffzoneXXYY2==-1 | diffzoneXXYY2==1);
% zoneYtoY=find(diffzoneXXYY2==-4 | diffzoneXXYY2==4);
% zoneYtoX=find(diffzoneXXYY2==-7 | diffzoneXXYY2==-11 | diffzoneXXYY2==-6 | diffzoneXXYY2==-10);
% zoneXtoY=find(diffzoneXXYY2==7 | diffzoneXXYY2==11 | diffzoneXXYY2==6 | diffzoneXXYY2==10);



zoneCentertoX=find(diffzoneXXYY2==1);
zoneCentertoY=find(diffzoneXXYY2==2);
zoneYtoCenter=find(diffzoneXXYY2==-2);



if(any(find(zoneCentertoY<TimeW)) || any(find(zoneCentertoY>length(working_transients)-TimeW)))
zoneCentertoY(zoneCentertoY<TimeW)=[]
zoneCentertoY(zoneCentertoY>length(working_transients)-TimeW)=[]
end

if(any(find(zoneYtoCenter<TimeW)) || any(find(zoneYtoCenter>length(working_transients)-TimeW)))
zoneYtoCenter(zoneYtoCenter<TimeW)=[]
zoneYtoCenter(zoneYtoCenter>length(working_transients)-TimeW)=[]
end


if(any(find(zoneCentertoX<TimeW)) || any(find(zoneCentertoX>length(working_transients)-TimeW)))
zoneCentertoX(zoneCentertoX<TimeW)=[]
zoneCentertoX(zoneCentertoX>length(working_transients)-TimeW)=[]
end




Transient_Epoch_CentertoY=[];Transient_Epoch_YtoCenter=[];Transient_Epoch_CentertoX=[];
for ki=1:length(zoneCentertoY)
%     
Transient_Epoch_CentertoY(ki,:,:)=[zoneXXYY2(zoneCentertoY(ki)-TimeW+1:zoneCentertoY(ki)+TimeW)' ; working_transients(zoneCentertoY(ki)-TimeW+1:zoneCentertoY(ki)+TimeW,:)'];
% figure(1);clf;imagesc(Transient_Epoch_CentertoY')
% pause(1)
end
Transient_Epoch_YtoCenter=[];
for ki=1:length(zoneYtoCenter)
Transient_Epoch_YtoCenter(ki,:,:)=[zoneXXYY2(zoneYtoCenter(ki)-TimeW+1:zoneYtoCenter(ki)+TimeW) working_transients(zoneYtoCenter(ki)-TimeW+1:zoneYtoCenter(ki)+TimeW,:)];
end

Transient_Epoch_CentertoX=[];
for ki=1:length(zoneCentertoX)
Transient_Epoch_CentertoX(ki,:,:)=[zoneXXYY2(zoneCentertoX(ki)-TimeW+1:zoneCentertoX(ki)+TimeW) working_transients(zoneCentertoX(ki)-TimeW+1:zoneCentertoX(ki)+TimeW,:)];
end




%%
for i=1:length(zoneYtoCenter)
figure(1);clf;subplot(211);plot(squeeze(mean(Transient_Epoch_CentertoY(i,2:end,:))));shading flat
subplot(212); area(squeeze(Transient_Epoch_CentertoY(i,1,:)))
pause(1)
end

%



% 
% xxyy_down_aligned=xxyy_down;
% xxyy_down_aligned(CenterPoints,:)=[];
% Aligned_transients=working_transients;
% % Aligned_transients(CenterPoints,:)=[];
% Aligned_kernel_transients=conv_kernel_trans;
% % Aligned_kernel_transients(CenterPoints,:)=[];
% plot(xxyy_down_aligned(zoneXtoX,1),xxyy_down_aligned(zoneXtoX,2),'wo','MarkerSize',10)
% plot(xxyy_down_aligned(zoneYtoY,1),xxyy_down_aligned(zoneYtoY,2),'go','MarkerSize',10)
% plot(xxyy_down_aligned(zoneXtoY,1),xxyy_down_aligned(zoneXtoY,2),'mo','MarkerSize',10)
% plot(xxyy_down_aligned(zoneYtoX,1),xxyy_down_aligned(zoneYtoX,2),'ko','MarkerSize',10)
% 
% 
% 
% if(any(find(zoneXtoX<TimeW)) || any(find(zoneXtoX>length(Aligned_transients)-TimeW)))
% zoneXtoX(zoneXtoX<TimeW)=[]
% zoneXtoX(zoneXtoX>length(Aligned_transients)-TimeW)=[]
% end
% if(any(find(zoneYtoY<TimeW)) || any(find(zoneYtoY>length(Aligned_transients)-TimeW)))
% zoneYtoY(zoneYtoY<TimeW)=[]
% zoneYtoY(zoneYtoY>length(Aligned_transients)-TimeW)=[]
% end
% if(any(find(zoneXtoY<TimeW)) || any(find(zoneXtoY>length(Aligned_transients)-TimeW)))
% zoneXtoY(zoneXtoY<TimeW)=[]
% zoneXtoY(zoneXtoY>length(Aligned_transients)-TimeW)=[]
% end
% 
% 
% 
% 
% %%
% 
% bigMatrix_1=[];
% bigMatrix1=[];
% % 
% % 
% % for i=1:length(zoneXtoX)
% % %     figure(1);subplot(221);pcolor(Aligned_transients(zoneXtoX(i)-TimeW:zoneXtoX(i)+TimeW,:)');shading flat
% % %     pause(1)
% % if(matched_open_temp(i,2)==-7)
% % ii=ii+1
% % %         subplot(10,1,k);hold on;plot(i,mean(norm_transients(matched_open_temp(i,1),:)'),'r.','markersize',20);
% % bigMatrix1(ii+500,k)=mean(Aligned_transients(matched_open_temp(i,1),:)');
% % else
% % %    bigMatrix1(451:500,k)=mean(norm_transients(matched_open_temp(ll(k))-49:matched_open_temp(ll(k)),:)');
% %    if(k==length(ll))
% %        k=k;
% %    else
% % % subplot(10,1,k);hold on;plot(i-10:i,mean(norm_transients(matched_open_temp(i,1)-10:matched_open_temp(i,1),:)'),'b.','markersize',20);
% %         k=k+1;
% %    end
% % i=1;
% % ii=1;
% % %     pause(.1);
% % end
% % end
% 
% 
% 
% 
% 
% for i=1:length(zoneXtoX)
% %     figure(1);subplot(221);pcolor(Aligned_transients(zoneXtoX(i)-TimeW:zoneXtoX(i)+TimeW,:)');shading flat
% %     pause(1)
% bigMatrix_1(i,:,:)=Aligned_transients(zoneXtoX(i)-TimeW:zoneXtoX(i)+TimeW,:);
% bigMatrix1(i,:)=mean(Aligned_transients(zoneXtoX(i)-TimeW+1:zoneXtoX(i)+TimeW,:)');
% end
% meanbigXtoX=squeeze(mean(bigMatrix_1));
% mean2bigXtoX=mean(meanbigXtoX(1:TimeW,:));
% Rated_bigXtoX=meanbigXtoX;
% sortedmeanbigXtoX=sort(mean2bigXtoX);
% for i=1:min(size(working_transients))
% temp=find(mean2bigXtoX(i)==sortedmeanbigXtoX)
% Rated_bigXtoX(:,i)=meanbigXtoX(:,temp);
% end
% 
% figure(1);subplot(221);imagesc(Rated_bigXtoX');shading flat;colormap jet;colorbar;caxis([0 0.5])
% figure(2);subplot(221);pcolor(bigMatrix1);shading faceted;
% hold on;stem(TimeW+0.5,min(size(working_transients))+1,'w:','LineWidth',5);title('X to X','Fontsize',14);
% 
% 
% bigMatrix2=[];
% bigMatrix_2=[];
% 
% for i=1:length(zoneYtoY)
% %     figure(1);subplot(222);pcolor(Aligned_transients(zoneYtoY(i)-TimeW:zoneYtoY(i)+TimeW,:)');shading flat
% bigMatrix_2(i,:,:)=Aligned_transients(zoneYtoY(i)-TimeW:zoneYtoY(i)+TimeW,:);
% bigMatrix2(i,:)=mean(Aligned_transients(zoneYtoY(i)-TimeW+1:zoneYtoY(i)+TimeW,:)');
% end
% for i=1:min(size(working_transients))
% temp=min(find(mean2bigYtoY(i)==sortedmeanbigYtoY))
% Rated_bigYtoY(:,i)=meanbigYtoY(:,temp);
% end
% meanbigYtoY=squeeze(mean(bigMatrix_2));
% mean2bigYtoY=mean(meanbigYtoY(1:TimeW,:));
% Rated_bigYtoY=meanbigYtoY;
% sortedmeanbigYtoY=sort(mean2bigYtoY);
% for i=1:min(size(working_transients))
% temp=min(find(mean2bigYtoY(i)==sortedmeanbigYtoY))
% Rated_bigYtoY(:,i)=meanbigYtoY(:,temp);
% end
% figure(1);subplot(222);imagesc(Rated_bigYtoY');shading flat;colormap jet;colorbar;caxis([0 0.5])
% hold on;stem(TimeW+0.5,min(size(working_transients))+1,'w:','LineWidth',5);title('Y to Y','Fontsize',14);
% figure(2);subplot(222);pcolor(bigMatrix2);shading faceted;
% 
% bigMatrix_3=[];
% bigMatrix3=[];
% for i=1:length(zoneXtoY)
% bigMatrix_3(i,:,:)=Aligned_transients(zoneXtoY(i)-TimeW:zoneXtoY(i)+TimeW,:);
% bigMatrix3(i,:)=mean(Aligned_transients(zoneXtoY(i)-TimeW+1:zoneXtoY(i)+TimeW,:)');
% end
% meanbigXtoY=squeeze(mean(bigMatrix_3));
% mean2bigXtoY=mean(meanbigXtoY(TimeW:end,:));
% Rated_bigXtoY=meanbigXtoY;
% sortedmeanbigXtoY=sort(mean2bigXtoY);
% for i=1:min(size(working_transients))
% temp=find(mean2bigXtoY(i)==sortedmeanbigXtoY)
% Rated_bigXtoY(:,i)=meanbigXtoY(:,temp);
% end
% figure(1);subplot(223);imagesc(Rated_bigXtoY');shading flat;colormap jet;colorbar;caxis([0 0.5])
% hold on;stem(TimeW+0.5,min(size(working_transients))+1,'w:','LineWidth',5);title('X to Y','Fontsize',14);
% figure(2);subplot(223);pcolor(bigMatrix3);shading faceted;
% 
% bigMatrix4=[];
% bigMatrix_4=[];
% for i=1:length(zoneYtoX)
% bigMatrix_4(i,:,:)=Aligned_transients(zoneYtoX(i)-TimeW:zoneYtoX(i)+TimeW,:);
% bigMatrix4(i,:)=mean(Aligned_transients(zoneYtoX(i)-TimeW+1:zoneYtoX(i)+TimeW,:)');
% end
% meanbigYtoX=squeeze(mean(bigMatrix_4));
% mean2bigYtoX=mean(meanbigYtoX(1:TimeW,:));
% Rated_bigYtoX=meanbigYtoX;
% sortedmeanbigYtoX=sort(mean2bigYtoX);
% for i=1:min(size(working_transients))
% temp=find(mean2bigYtoX(i)==sortedmeanbigYtoX)
% Rated_bigYtoX(:,i)=meanbigYtoX(:,temp);
% end
% figure(1);subplot(224);imagesc(Rated_bigYtoX');shading flat;colormap jet;colorbar;caxis([0 0.5])
% hold on;stem(TimeW+0.5,min(size(working_transients))+1,'w:','LineWidth',5);title('Y to X','Fontsize',14);
% figure(2);subplot(224);pcolor(bigMatrix4);shading faceted;