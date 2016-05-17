function CrossCorr(Data)
    figure;imagesc(corr(Data,'Type','Spearman'))
end