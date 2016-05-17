function tfout=TFIDF(fs,time1,time2,cell1,cell2,data)

thresh=0.3;fs_ca=fs;
shuffle_rep=1000;
% des_signal=DataRead(fs,time1,time2,cell1,cell2);
des_signal=data;
dess_signal=des_signal;

% figure(10);subplot(121);pcolor(des_signal');shading flat;title('Mag Norm Transients (Current Form)')

des_signal(find(des_signal<thresh))=0;
des_signal(find(des_signal>thresh))=1;
% figure(10);subplot(152);pcolor(des_signal');shading flat;title('Mag Norm Transients (Current Form)')

binned_signal=[];
binn=2;
%%binning sum

for t=1:max(size(des_signal))
for tt=1:(min(size(des_signal))/binn)
   binned_signal(t,tt)=sum(des_signal(t,(tt-1)*binn+1:binn*tt));
end
end

% for tt=1:shuffle_rep
% temp=[];sumtemp=zeros(min(size(des_signal)),1);
% for t=1:min(size(des_signal))
%     temp=des_signal(randi(max(size(des_signal))),t);
%     sumtemp(t)=temp+sumtemp(t);
% end
%     
%     shuffletemp(tt)=sum(sumtemp);
% end


% figure;subplot(211);stairs(sum(binned_signal'))
% hold on;plot([1 max(size(des_signal))],[mean(shuffletemp) mean(shuffletemp)],'r--')
% subplot(212);imagesc(binned_signal');colormap gray
% figure;bar(shuffletemp)

%%TF-IDF Normalization
nDoc=max(size(des_signal)); %time
nWords=min(size(des_signal));%cell
TF=mean(des_signal');
IDF=[];
for i=1:nWords
    IDF(i)=log10(nDoc/length(find(des_signal(:,i)>0)));
end

IDF(find(isinf(IDF)))=0;

TFIDF_signal=zeros(nDoc,nWords);
% for i=1:100
for ii=1:nDoc
    TFIDF_signal(ii,:)=des_signal(ii,:).*IDF;
% TFIDF_signal(:,i)=TFIDF_signal(:,i).*TF';
end
% end
for i=1:nWords
TFIDF_signal(:,i)=TFIDF_signal(:,i).*TF';
end




TFIDF=average_beh_epoch';Rated_bigXtoX=[];
temp22=0;
% TFIDF=dg1A';
mean2bigXtoX=max(TFIDF);
Rated_bigXtoX=TFIDF;
sortedmeanbigXtoX=sort(mean2bigXtoX,'ascend');
for i=1:min(size(TFIDF))
temp2=find(mean2bigXtoX==sortedmeanbigXtoX(i));
if(length(temp2)>1)
for k=1:length(temp22)
aa=find(temp2==temp22(k));
temp2(aa)=[];
end
end
temp22(i)=min(temp2);
Rated_bigXtoX(:,i)=TFIDF(:,temp22(i));
end
figure;pcolor(Rated_bigXtoX');shading flat;colormap jet(20);
% 
% Rated_bigXtoX=[];
% TFIDF=dg1B';
% for i=1:min(size(TFIDF))
%     
%     Rated_bigXtoX(:,i)=TFIDF(:,temp22(i));
% end
% figure;pcolor(Rated_bigXtoX');shading flat;colormap jet(20)


% %%
% hh=figure;
% % subplot(152);pcolor(des_signal');shading flat;title('Binned Transients');
% % subplot(153);pcolor(TFIDF_signal');shading flat;title('Freq Norm (TF-IDF) Transients');
% subplot(121);pcolor(dess_signal');shading flat;title('Mag Norm Transients (Current Form)')
% subplot(122);pcolor(Rated_bigXtoX');shading flat;title('Graded TF-IDF');set(gcf,'Color','w')
% colormap jet(15);
% 
% figure;subplot(221);spy(des_signal');title('Mag Norm');axis square;subplot(223);stairs(sum(dess_signal'));axis tight;subplot(222);spy(Rated_bigXtoX');title('TF-IDF binned form');axis xy square;subplot(224);stairs(sum(Rated_bigXtoX'),'r');axis tight
% % figure(10);subplot(155);bar([(mean(sum(binned_signal(:,1:50)))-mean(sum(binned_signal(:,51:100))))/mean(sum(binned_signal))*100 (mean(sum(TFIDF_signal(:,1:50)))-mean(sum(TFIDF_signal(:,51:100))))/mean(sum(TFIDF_signal))*100],0.4);box off;title('% Relevant content improvement');
% 
% % figure;bar(mean(TFIDF_signal))
% cos_sim_matrix=zeros(max(size(TFIDF_signal)));
% for i=1:max(size(cos_sim_matrix))
%     for ii=1:max(size(cos_sim_matrix))
%         cos_sim_matrix(i,ii)=cos_sim(TFIDF_signal(i,:), TFIDF_signal(ii,:));
%     end
% end
% 
% beh_inp=char(inputdlg('Would you like to correlate with behavior?:(y/n)','Behavioral Matched data'));
% if(beh_inp=='y')
% % figure;imagesc(cos_sim_matrix)        
%    [beh dir]=uigetfile('.*','Enter behavior data');
%     beh=xlsread([dir beh]);
%     xxyy=beh(:,[5 6]);  
%     xxyy=downsample(xxyy,6)
%     xxyy=xxyy(fs*time1+1:fs*time2,:);
%     size(xxyy)
% %     xxyy(find(isnan(xxyy)),:)=[];
%     
%     
% pv_dist=[];
% for i=1:max(size(cos_sim_matrix))
% % figure(10);clf;plot(xxyy(:,1),xxyy(:,2))
% temp=find(cos_sim_matrix(i,:)>0.5);
% % temp2=temp(find(abs(i-temp)>2*fs_ca));
% temp2=min(temp(find(abs(i-temp)>2*fs_ca))); % Only 2.visit
% if(temp2>0)
% % for k=1:length(temp2)
% pv_xxyydist=sqrt((xxyy(i,1)-xxyy(temp2(k),1))^2+(xxyy(i,2)-xxyy(temp2(k),2))^2);
% % end
% pv_dist(i)=mean(pv_xxyydist);
% else
%     pv_dist(i)=NaN;
% end
% % hold on;plot(xxyy(i,1),xxyy(i,2),'kx','LineWidth',5)
% % hold on;plot(xxyy(temp2,1),xxyy(temp2,2),'rx','LineWidth',5)
% % pause(2)
% end
% pv_dist2=pv_dist;
% pv_dist2(find(isnan(pv_dist2)))=[];
% 
% temp3=find(pv_dist<3);
% figure;plot(xxyy(:,1),xxyy(:,2),'b')
% hold on;plot(xxyy(temp3,1),xxyy(temp3,2),'rx','MarkerSize',15,'LineWidth',3)
% 
% shuff_xxyy=[];
% for ii=1:length(pv_dist)
% shuff_xxyy(ii)=sqrt((xxyy(ii,1)-xxyy(randi(length(pv_dist)),1))^2+(xxyy(ii,2)-xxyy(randi(length(pv_dist)),2))^2);
% end
% 
% shuff_xxyy(find(isnan(shuff_xxyy)))=[];
% 
% [mean(shuff_xxyy) std(shuff_xxyy)];
% 
% figure(hh.Number);subplot(122);hold on;plot(abs(xxyy(:,2)),'w','LineWidth',3);hold on;plot(abs(xxyy(:,1)),'k','LineWidth',3);
% 
% xxyy2=naninterp(xxyy);
% % xxyy2(:,2)=xxyy2(:,2)+3;
% C1=corrcoef(abs(xxyy2(:,1)),mean(TFIDF_signal'));
% C2=corrcoef(abs(xxyy2(:,2)),mean(TFIDF_signal'));
% [C1 C2]
% 
tfout=Rated_bigXtoX;
% end

end
