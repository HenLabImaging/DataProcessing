
c=[];cc=[];ccc=[];
for i=1:length(matched_cells)
    for k=1:length(xy_cell1)
cc=corrcoef(cells_transients_epm(:,matched_cells(i,2)),cells_transients_ref(:,k));
c(k,i)=cc(1,2);
    end
end
for ii=1:min(size(c))
    ccc(ii)=find(c(:,ii)==max(c(:,ii)))
end

matched_cells_new=[matched_cells ccc'];
sl=length(find(matched_cells_new(:,1)==matched_cells_new(:,3)))/length(matched_cells_new)*100;


%%
% for i=1:length(matched_cells)
% figure(2);clf;plot(xcorr2(cells_transients_ref(:,matched_cells(i,1)),cells_transients_epm(:,matched_cells(i,2))))
% pause(.2)
% end


for i=1:length(matched_cells)
ccc=corrcoef(cells_transients_ref(:,matched_cells(i,1)),cells_transients_epm(:,matched_cells(i,2)));
CC(i)=ccc(1,2);
end
subplot(2,3,6);bar(CC);
tt3=sprintf(['Median Corr:' num2str(median(CC)) '\n ' num2str(sl)  '|100 of cells matched with the highest correlation\n in the temporal analysis'])
title(tt3)
axis([0 length(matched_cells) 0 1])

save([root_dir '/StableCells_wTemporal' num2str(nn) '.mat'],'matched_cells_new')
