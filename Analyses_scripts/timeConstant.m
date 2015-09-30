%%time constant - or - Integration
[b,a]=butter(2,0.2);
filtered_conv_vgat=filtfilt(b,a,vgat_conv);
filtered_conv_vhpc=filtfilt(b,a,conv_kernel_trans_norm);
des_signal=filtered_conv_vgat;
des_events=vgat_cell_events;
%%
clear meanstdTau
for ii=1:min(size(des_signal))
tt1=find(des_events(:,ii)>0);
TimeW=200;
 tau=1-0.63;
 clear Tau  
if(tt1>0)
     tt1(tt1+TimeW>3000)=[];
     
for i=1:length(tt1)
   
Tau(i)=min(find(des_signal(tt1(i):tt1(i)+TimeW,ii)<des_signal(tt1(i),ii)*tau));
end

% figure;bar(Tau)
meanstdTau(ii,:)=[mean(Tau) std(Tau)];
end

end

figure;bar(meanstdTau(:,1))
mean(meanstdTau)
%%
conv_vhpc_square=conv_kernel_trans_norm;
conv_vgat_square=vgat_conv;
meantime1=[];meantime2=[];
for i=1:min(size(conv_vhpc_square))
% conv_vhpc_square(find(conv_vhpc_square(:,i)>0.2),i)=1;
% conv_vhpc_square(find(conv_vhpc_square(:,i)<0.2),i)=0;
% meantime1(i)=sum(conv_vhpc_square(:,i))/length(find(vhpc_cell_events(:,i)>0))
meantime1(i)=trapz(abs(conv_kernel_trans_norm(:,i)))/length(find(vhpc_cell_events(:,i)>0));
end
meantime1(find(isnan(meantime1)))=0
figure;bar(meantime1)
for i=1:min(size(conv_vgat_square))
% conv_vgat_square(find(conv_vgat_square(:,i)>0.2),i)=1;
% conv_vgat_square(find(conv_vgat_square(:,i)<0.2),i)=0;
% meantime2(i)=sum(conv_vgat_square(:,i))/length(find(cell_events(:,i)>0))
meantime2(i)=trapz(abs(vgat_conv(:,i)))/length(find(cell_events(:,i)>0))
end
figure;bar(meantime2)
figure;bar([mean(meantime1),mean(meantime2)])
