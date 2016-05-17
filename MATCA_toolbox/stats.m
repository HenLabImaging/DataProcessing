function stats(DATA,fs)
mm=menu('Select a statistic','I-) Descriptive','II-) 1-Way Anova','III-) Correlate','IV-) Regress');
t=1/fs:1/fs:length(DATA)/fs;
data=DATA';
if(mm==1)
    stats=[mean(DATA);std(DATA);var(DATA);max(DATA);median(DATA)];
     stats2=[mean(data);std(data);var(data);max(data);median(data)];
        figure;subplot(121);plot(stats');xlabel('cell','FontSize',16);ylabel('Val','FontSize',16);box off
       set(gcf,'Color','w')
        subplot(122);plot(t,stats2); legend('mean','std','var','max','med');xlabel('time (sec)','FontSize',16);ylabel('Val','FontSize',16);box off
elseif(mm==2)
    anova1(DATA);
elseif(mm==3)
    figure;imagesc(corr(DATA,'Type','Spearman'));xlabel('cell','FontSize',16);ylabel('cell','FontSize',16);colormap bone;colorbar;set(gcf,'Color','w')
elseif(mm==4)
    b=regress(t',DATA);
    figure;bar(b);box off;xlabel('cell','FontSize',16);ylabel('Regression coeff','FontSize',16);set(gcf,'Color','w')
end


end
