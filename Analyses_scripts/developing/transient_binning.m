% bin_transients=zeros(size(norm_transients));
% % down_trans=downsample(norm_transients,5);
% TimeW=10;
% norm_threshold=0.4;
% for i=1:min(size(norm_transients))
% for ii=1:TimeW:length(norm_transients)/TimeW
% temp=any(norm_transients((ii-1)*TimeW+1:ii*TimeW,i)>norm_threshold);
% if(temp=='1')
% bin_transients((ii-1)*TimeW+1:ii*TimeW,i)=1;
% end
% end
% end

bin_transients=zeros(size(norm_transients));
down_trans=downsample(norm_transients,5);
TimeW=15;
norm_threshold=0.3;
for i=1:min(size(norm_transients))
for ii=1:TimeW:length(norm_transients)/TimeW
temp=any(norm_transients((ii-1)*TimeW+1:ii*TimeW,i)>norm_threshold);
if(temp==1)
bin_transients((ii-1)*TimeW+1:ii*TimeW,i)=1;
% bin_transients((ii-1)*TimeW+1:ii*TimeW,i)=sum(bin_transients((ii-1)*TimeW+1:ii*TimeW,i));
end
end
end

figure;subplot(121);imagesc(bin_transients')
mean_bintrans=mean(bin_transients');
subplot(122);plot((mean_bintrans))


