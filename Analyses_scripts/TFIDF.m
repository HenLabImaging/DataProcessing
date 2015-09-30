%%population vector
% clear IDF,TFIDF_signal
% clear all
% close all
thresh=0.3; %For [0 1] norm signals typical one is 3Xs.d

des_signal=squeeze(open2close_5cross_mouse4(:,:,2));
dess_signal=des_signal;

figure(10);subplot(151);pcolor(des_signal);shading flat;title('Mag Norm Transients (Current Form)')
set(gcf,'Color','w')
des_signal(find(des_signal<thresh))=0;
des_signal(find(des_signal>thresh))=1;


% figure;bar(sum(des_signal))

binned_signal=[];
binn=1;
%%binning sum

for t=1:max(size(des_signal))
for tt=1:(min(size(des_signal))/binn)
   binned_signal(t,tt)=sum(des_signal(t,(tt-1)*binn+1:binn*tt));
end
end

% figure;bar(sum(binned_signal))


%%reshuffling - determining sign synch for pop vector
for tt=1:1000
temp=[];sumtemp=zeros(max(size(des_signal)),1);
for t=1:max(size(des_signal))
    temp=des_signal(t,randi(100));
    sumtemp(t)=temp+sumtemp(t);
end
    
    shuffletemp(tt)=sum(sumtemp);
end

    
figure;subplot(211);stairs(sum(binned_signal))
hold on;plot([1 100],[mean(shuffletemp) mean(shuffletemp)],'r--')
subplot(212);imagesc(binned_signal);colormap gray
% figure;bar(shuffletemp)
% [mean(shuffletemp) std(shuffletemp)]


%%TF-IDF Normalization
nDoc=min(size(des_signal))
nWords=max(size(des_signal))
TF=mean(des_signal);

for i=1:nWords
    IDF(i)=log10(nDoc/length(find(des_signal(i,:)>0)));
end

 IDF(find(isinf(IDF)))=0;

TFIDF_signal=zeros(nWords,nDoc);
% for i=1:100
    for ii=1:nDoc

TFIDF_signal(:,ii)=des_signal(:,ii).*IDF';
% TFIDF_signal(:,i)=TFIDF_signal(:,i).*TF';
    end
% end
for i=1:nWords
TFIDF_signal(i,:)=TFIDF_signal(i,:).*TF;
end

TFIDF=[];Rated_bigXtoX=[];
temp22=0;
TFIDF=TFIDF_signal';
mean2bigXtoX=mean(TFIDF(1:50,:));
% Rated_bigXtoX=TFIDF;
sortedmeanbigXtoX=sort(mean2bigXtoX,'ascend');
for i=1:max(size(TFIDF))
temp2=find(mean2bigXtoX==sortedmeanbigXtoX(i));
for k=1:length(temp22)
aa=find(temp2==temp22(k));
temp2(aa)=[];
end
temp22(i)=min(temp2);
Rated_bigXtoX(:,i)=TFIDF(:,temp22(i));
end
% figure;pcolor(Rated_bigXtoX');shading flat


figure(10)
subplot(152);pcolor(des_signal);shading flat;title('Binned Transients');hold on;plot([51 51],[1 max(size(des_signal))],'w--');
subplot(153);pcolor(TFIDF_signal);shading flat;title('Freq Norm (TF-IDF) Transients');hold on;plot([51 51],[1 max(size(des_signal))],'w--');
subplot(154);pcolor(Rated_bigXtoX');shading flat;title('Graded TF-IDF');hold on;plot([51 51],[1 max(size(des_signal))],'w--');
colormap jet(15);

figure;subplot(221);spy(des_signal);title('Mag Norm');axis square;subplot(223);stairs(sum(dess_signal));hold on;plot([51 51],[min(sum(dess_signal)) max(sum(dess_signal))],'k--');axis tight;subplot(222);spy(Rated_bigXtoX');title('TF-IDF binned form');axis xy square;subplot(224);stairs(sum(Rated_bigXtoX'),'r');hold on;plot([51 51],[min(sum(TFIDF_signal)) max(sum(TFIDF_signal))],'k--');axis tight
figure(10);subplot(155);bar([(mean(sum(binned_signal(:,1:50)))-mean(sum(binned_signal(:,51:100))))/mean(sum(binned_signal))*100 (mean(sum(TFIDF_signal(:,1:50)))-mean(sum(TFIDF_signal(:,51:100))))/mean(sum(TFIDF_signal))*100],0.4);box off;title('% Relevant content improvement');

% figure;bar(mean(TFIDF_signal))

for i=1:99
coss(i)=cos_sim(TFIDF_signal(:,i)',TFIDF_signal(:,i+1)');
end

for i=1:49 
    coss1(i)=coss(50-i);
end

%Shuffle cos similarity

for k=1:50
for i=1:1000
coss_shuffle(i)=cos_sim(TFIDF_signal(:,k+50)',TFIDF_signal(:,randi(min(size(TFIDF_signal))))');
end
meancoss_shuffle(k)=mean(coss_shuffle);
end


[b,a]=butter(2,0.2);
filt_coss1=filtfilt(b,a,coss1);
filt_coss2=filtfilt(b,a,coss(51:end));

figure;subplot(3,2,[5 6]);semilogx(filt_coss1,'b');hold on;semilogx(filt_coss2,'r');axis tight;
% semilogx(meancoss_shuffle,'k');

subplot(321);bar(coss)
subplot(322);bar([mean(coss(1:50)) mean(coss(51:end))])

for i=1:1000
aa(i)=cos_sim(TFIDF_signal(:,randi([1 ,50]))',TFIDF_signal(:,randi([1 ,50]))');
bb(i)=cos_sim(TFIDF_signal(:,randi([50 ,100]))',TFIDF_signal(:,randi([50 ,100]))');
cc(i)=cos_sim(TFIDF_signal(:,randi([1,50]))',TFIDF_signal(:,randi([50,100]))');


end
bb(find(bb==1))=[];
aa(find(aa==1))=[];

subplot(3,2,[3 4]);bar(1,mean(aa),0.5,'b');hold on;bar(2,mean(bb),0.5,'r');bar(3,mean(cc),0.5,'g')


synch_times=find(sum(Rated_bigXtoX')>max(sum(Rated_bigXtoX'))*.5)
figure;subplot(121);imagesc(Rated_bigXtoX(synch_times,:)');shading flat;colormap bone


synch_times1=synch_times(synch_times<50)
synch_times2=synch_times(synch_times>50)

close_open_cells=zeros(length(Rated_bigXtoX),3);
for i=1:length(synch_times1)
close_open_cells(find(Rated_bigXtoX(synch_times1(i),:)>0),1)=1;
end
for i=1:length(synch_times2)
close_open_cells(find(Rated_bigXtoX(synch_times2(i),:)>0),2)=1;
end

close_open_cells(:,3)= close_open_cells(:,1).*close_open_cells(:,2);
subplot(122);imagesc(close_open_cells);
vennX([length(find(close_open_cells(:,1)>0)) length(find(close_open_cells(:,3)>0)) length(find(close_open_cells(:,2)>0))],.05)