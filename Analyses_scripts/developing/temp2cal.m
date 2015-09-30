%%vectoral computations

% zoneXtoY([2 10 13])=[]; %first make sure to include only right directionals

kk=ceil(sqrt(length(zoneYtoX)))

for k=2:length(zoneXtoY)
meanClose2openCell=[];

for ii=1:213

Close2open_cell1=[];

for i=1:length(zoneYtoX(1:k))
    Close2open_cell1(i,1)=sum(abs((Aligned_transients(zoneYtoX(i)-50:zoneYtoX(i),ii))));
    Close2open_cell1(i,2)=sum(abs(Aligned_transients(zoneYtoX(i):zoneYtoX(i)+50,ii)));
end
meanClose2openCell(ii,:)=mean(Close2open_cell1);
% figure(1);clf;compass(Close2open_cell1(:,1),Close2open_cell1(:,2),'r')
% pause(1)
end

meanClose2openCell_norm=meanClose2openCell./max(max(meanClose2openCell));

 q_cells=meanClose2openCell_norm(:,2)./meanClose2openCell_norm(:,1);
qq_cells=find(q_cells>1.5);
qq_cells2=find(q_cells<0.5);
figure(2);subplot(kk,kk,k-1);compass(-meanClose2openCell_norm(:,1),meanClose2openCell_norm(:,2),'b:')
hold on;compass(-meanClose2openCell_norm(qq_cells,1),meanClose2openCell_norm(qq_cells,2),'r')
hold on;compass(-meanClose2openCell_norm(qq_cells2,1),meanClose2openCell_norm(qq_cells2,2),'k')
end