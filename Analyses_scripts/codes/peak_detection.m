%%Runs with clusters.m

% raw_data=load('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG 1 August 28 Final extracted data/DG 4 stdev raw data.txt');
raw_data=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/DG 4 Aug 28 Final Extracted Data/dg4_356CELLS_SD.xlsx');
raw_data=raw_data(:,3:end); %discard the time information

%%simple peak detection...requires touch up.

peak_threshold=3*mean(std(raw_data))

for ll=1:Nevents
        raw_data(find(raw_data(:,ll)<peak_threshold),ll)=0;
end

%%
raw_dataA=raw_data(1:3000,2:end);
raw_dataB=raw_data(3001:6000,2:end);
raw_dataC=raw_data(6001:9000,2:end);


norm_rawdataA=raw_dataA/max(max(raw_dataA));
norm_rawdataB=raw_dataB/max(max(raw_dataB));
norm_rawdataC=raw_dataC/max(max(raw_dataC));

figure;

subplot(231);imagesc(Comb_cell2);view(-90,90);colormap(jet)
subplot(232);imagesc(Comb_cell3);view(-90,90);colormap(jet)
subplot(233);imagesc(Comb_cell4);view(-90,90);colormap(jet)

subplot(234);imagesc(norm_rawdataA(1:20:end,[CellA])');caxis([-0.2 0.5])
subplot(235);imagesc(norm_rawdataB(1:20:end,[CellB])');caxis([-0.2 0.5])
subplot(236);imagesc(norm_rawdataC(1:20:end,[CellC])');caxis([-0.2 0.5]);colormap parula
