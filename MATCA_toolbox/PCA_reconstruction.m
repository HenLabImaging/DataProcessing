function PCA_reconstruction(DATA,fs)
    [coeff,score,latent,tsquared] = pca(DATA);
    
    var=1e2*cumsum(latent)./sum(latent);
    t=linspace(1,length(DATA)/fs,length(DATA))
    
    
  figure;subplot(131);bar(var);xlabel('PCs','FontSize',16);ylabel('%Explained data','FontSize',16);
    pc_entered=str2double(inputdlg('Enter the desired number of PC for the new dataset'))
    hold on;bar(var(1:pc_entered),'r')
%     a=[ find(coeff(1,:)>0) find(coeff(2,:)>0)]'
    subplot(133);plot(t,mean(score(:,1:pc_entered)'));xlabel('time (sec)','FontSize',16);ylabel('Magnitude','FontSize',16);title('Reconstructed from selected PCs','FontSize',16)
    subplot(132);imagesc(score(:,1:pc_entered)');xlabel('samples','FontSize',16);ylabel('PC','FontSize',16)
%     figure;plot(score(:,1),score(:,2),'bo');hold on;plot(score(:,1),score(:,3),'ro')
    %     figure;subplot(121);imagesc(DATA(:,find(coeff(1,:)>0))')
%     figure;subplot(121);imagesc(DATA(:,find(coeff(2,:)>0))')
%     subplot(122);imagesc(DATA(:,find(coeff(1,:)<0))')
    %     figure;imagesc(coeff)
end