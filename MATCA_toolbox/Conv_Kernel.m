function des_output=Conv_Kernel(des_transients,des_events)

%
norm_transients=des_transients;
for i=1:min(size(des_transients))

mincell=abs(min(des_transients(:,i)));
maxcell=abs(max(des_transients(:,i)));
if(maxcell>mincell)
    ref_baseline=maxcell;
else
    ref_baseline=mincell;
end 
% norm_transients(:,i)=norm_transients(:,i)/mean(norm_transients(:,i));
norm_transients(:,i)=norm_transients(:,i)/ref_baseline;
% norm_transients(:,i)=norm_transients(:,i)./abs(min(norm_transients(:,i)));
end




for ii=1:min(size(des_events))
timeind=find(des_events(:,ii)>0);
if(timeind>0)
pdSix = fitdist(timeind,'Kernel','BandWidth',20,'Kernel','normal');
tt = 1:length(des_events);
kernel_transients(:,ii)= pdf(pdSix,tt);
kernel_transients(:,ii)= kernel_transients(:,ii)/max(kernel_transients(:,ii)); %Add the normalization
conv_kernel_trans(:,ii)=kernel_transients(:,ii).*norm_transients(1:length(kernel_transients),ii); %Modified version Kernel Model
else
kernel_transients(:,ii)= zeros(length(des_events),1);
kernel_transients(:,ii)= kernel_transients(:,ii)/max(kernel_transients(:,ii)); %Add the normalization
conv_kernel_trans(:,ii)=kernel_transients(:,ii).*norm_transients(1:length(kernel_transients),ii);
end
% conv_kernel_trans_norm=conv_kernel_trans;

end


des_output=conv_kernel_trans;