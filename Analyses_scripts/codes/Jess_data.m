open_ind=find(cell1_epm_beh(:,17)==1|cell1_epm_beh(:,19)==1|cell1_epm_beh(:,22)==1);
 closed_ind=find(cell1_epm_beh(:,16)==1|cell1_epm_beh(:,18)==1); %same as above but for periph
 
raw=cell1_data;
% raw2=raw;
for k=1:min(size(raw))
raw(find(raw(:,k)>0),k)=k; %%for raster plot
end

figure;
fill([0 880 880 0], [0 0 120 120],[1 0 0])
hold on;fill([880 1750 1750 880], [0 0 120 120],[0 0 1])
% plot(raw,'b.','LineWidth',10) % all cells in raster

closed_ind_cut=closed_ind(214:214+length(open_ind)-1)
% figure;
plot(raw(open_ind,:),'bo','MarkerFaceColor','b')
% hold on;plot(length(open_ind)+closed_ind,raw(closed_ind,:),'ro','MarkerFaceColor','r')
% hold on;plot(closed_ind_cut,raw(closed_ind_cut,:),'ro','MarkerFaceColor','r')
closed_ind_cut2=closed_ind(220:700);
hold on;plot(closed_ind_cut2,raw(closed_ind_cut2,:),'ro','MarkerFaceColor','r')
axis([0 1750 0.2 110])

%%
novelob_ind=find(cell2_novel_beh(:,16)==1|cell2_novel_beh(:,18)==1);
oppfield_ind=find(cell2_novel_beh(:,17)==1);

raw2=cell2_novel;
% raw2=raw;
for k=1:min(size(raw2))
raw2(find(raw2(:,k)>0),k)=k; %%for raster plot
end

figure;
fill([1750 1920 1920 1750], [0 0 120 120],[0 0 1])
fill([1920 2090 2090 1920], [0 0 120 120],[0 1 1])

hold on;plot(1750:1918,raw2(oppfield_ind,2:end),'bo','MarkerFaceColor','b')
hold on;plot(1925:2093,raw2(novelob_ind_cut,2:end),'ro','MarkerFaceColor','r')

figure;plot(novelob_ind,raw2(novelob_ind,:),'bo')
hold on;plot(oppfield_ind,raw2(oppfield_ind,2:end),'ro','MarkerFaceColor','r')
%%overlappings

for i=1:length(novelob_ind)
if(find(novelob_ind(i)==open_ind)>0)
a(i)=find(novelob_ind(i)==open_ind)
end
end

length(find(a>0))
