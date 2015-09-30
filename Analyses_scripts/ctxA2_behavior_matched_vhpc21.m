norm_dist_clocw=dist_clockw./max(dist_clockw); %far point gets the higher rank
norm_dist_c_clocw=dist_c_clockw./max(dist_c_clockw);



for i=1:min(size(newTrans1))
cc=corrcoef(newTrans1(:,i),norm_dist_clocw)
corrC1(i)=cc(1,2)
end
figure;plot(corrC1,'o-')
for i=1:min(size(newTrans1))
cc=corrcoef(newTrans2(:,i),norm_dist_c_clocw)
corrC2(i)=cc(1,2)
end
hold on;plot(corrC2,'ro-')

% figure;plot([corrC1+corrC2]/2,'o-')



nReps=1000;     %shuffle repetition
bootstrap1=zeros(nReps,min(size(newTrans1)));
for ii=1:nReps
    for i=1:min(size(newTrans1))
       cc=corrcoef(newTrans1(:,randi(min(size(newTrans1)))),norm_dist_clocw);
       corr_boot(i)=cc(1,2);
    end
% figure(1);clf;plot(corr_boot,'o-')
% pause (.5)
bootstrap1(ii,:)=corr_boot;
end

figure; plot(mean(bootstrap1),'o-')
hold on;
plot(mean(bootstrap1)+std(bootstrap1)*2,'r--')
plot(mean(bootstrap1)-std(bootstrap1)*2,'r--')
plot([corrC1+corrC2]/2,'o-')



% figure;histfit(bootstrap1)



% for i=1:min(size(newTrans1))
% anx_cells(i)=mean(norm_dist_clocw.*newTrans1(:,i))
% end
% figure;bar(anx_cells)
% Q_anxcells=anx_cells(find(anx_cells>Threshold));
% hold on;plot(find(anx_cells>Threshold),Q_anxcells,'ro')
% 
% for i=1:min(size(newTrans2))
% anx_cells2(i)=mean(norm_dist_c_clocw.*newTrans2(:,i))
% end
% figure;bar(anx_cells2)
% Q_anxcells2=anx_cells2(find(anx_cells2>Threshold));
% hold on;plot(find(anx_cells2>Threshold),Q_anxcells2,'ro')
