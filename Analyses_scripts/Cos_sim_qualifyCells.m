

temp=squeeze(mean(bigMatrix_3))';
difftemp=(mean(temp(:,1:50)')-mean(temp(:,51:100)'))
figure;bar(difftemp)
qual_cells=find(difftemp>0.01)

figure;pcolor(squeeze(mean(bigMatrix_3(:,1:100,qual_cells)))')
open2close_vhpc22=squeeze(mean(bigMatrix_3(:,1:100,qual_cells)))'

Anx_cells_open=[]
Anx_cells_close=[]

yy=norm_transients;
for i=1:min(size(yy))
Anx_cells_open(i)=sum(abs(yy(tempindy1,i)))/length(tempindy1)+sum(abs(yy(tempindy2,i)))/length(tempindy2)
   Anx_cells_close(i)=sum(abs(yy(tempindx1,i)))/length(tempindx1)+sum(abs(yy(tempindx2,i)))/length(tempindx2)

end

Anx_cells=[Anx_cells_open;Anx_cells_close]



l1=length([tempindx1 ;tempindx2])

l2=length([tempindy1 ;tempindy2])

L=l1/l2
Rate=[];
for i=1:213
    Rate(i,1)=[sum(conv_kernel_trans(tempindx1,i))+sum(conv_kernel_trans(tempindx2,i))]
    Rate(i,2)=[sum(conv_kernel_trans(tempindy1,i))+sum(conv_kernel_trans(tempindy2,i))]
%     Rate(i,:)=Rate(i,:)*5;
    Rate(i,2)=Rate(i,2)*L
end

 Rate(find(Rate==0))=1e-16
 Rate(find(isnan(Rate)==1))=1e-16
meanQRate=[];


qual_cells2=find(abs(Rate(:,2)./Rate(:,1))>2)
non_qual_cells2=find(abs(Rate(:,2)./Rate(:,1))<2)

for ii=1:length(qual_cells2)

Q_rate=[];
for i=1:length(qual_cells2)
    Q_rate(i)=cos_sim(Rate(qual_cells2(ii),:),Rate(qual_cells2(i),:));
end
meanQRate(ii)=mean(Q_rate)
end

meanQRate2=[];


for ii=1:length(qual_cells2)

Q2_rate=[];
for i=1:length(non_qual_cells2)
    Q2_rate(i)=cos_sim(Rate(qual_cells2(ii),:),Rate(non_qual_cells2(i),:));
end

meanQRate2(ii)=mean(Q2_rate)
end


mean(meanQRate)
mean(meanQRate2)

Rate=Rate/10;
figure;scatter(Rate(:,1),Rate(:,2),'bo','LineWidth',1)
hold on;scatter(Rate(qual_cells2,1),Rate(qual_cells2,2),'ro','LineWidth',2)


