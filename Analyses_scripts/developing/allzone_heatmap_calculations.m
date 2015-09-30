%%

k=1;new_signal=[];
for i=1:min(size(Transient_Epoch_CentertoX))
figure(1);clf;subplot(211);area(squeeze(Transient_Epoch_CentertoX(i,:,1)));shading flat
subplot(212); imagesc(squeeze(Transient_Epoch_CentertoX(i,:,2:end)))
tt=char(inputdlg('keep?'))
if(tt=='y')
    new_signal(k,:,:)=Transient_Epoch_CentertoX(i,:,2:end);
    k=k+1;
end
% pause;
end

Close2close_mouse8=new_signal;

% for i=1:min(size(new_signal))
% figure(2);clf;subplot(211);area(squeeze(new_signal(i,1,:)));shading flat
% subplot(212); imagesc(squeeze(new_signal(i,2:end,:)))
% title(num2str(i))
% pause;
% end


figure;set(gcf,'Color','w')
for ii=1:min(size(XCenterY8))
    beh=squeeze(XCenterY8(ii,1,:));
    subplot(min(size(XCenterY8)),1,ii)
    title(['Crossing = ' num2str(ii)])
for i=1:length(beh)
    if(beh(i)==0)
        hold on;plot([i i],[0 0.25],'k','LineWidth',5)
    elseif(beh(i)==1)
        hold on;plot([i i],[0 0.25],'b','LineWidth',5)
    elseif(beh(i)==2)
        hold on;plot([i i],[0 0.25],'r','LineWidth',5)
    end
    axis tight
        
end
    axis off
    
subplot(min(size(XCenterY8)),1,ii); imagesc(squeeze(mean(XCenterY8(ii,2:end,:)))');shading flat;caxis([-0.01 0.01])
% pause(.4)
axis off;
colormap parula(30)
end
axis on





%    xshade=xshade';
mkdir('/Users/Machine/desktop/cell_allzones_HeatMAps/mouse1/')

for ii=1:min(size(new_signal))
figure(1);clf

beh=squeeze(new_signal(ii,1,:));
openbeh=find(beh==2);
subplot(8,1,1)
for i=1:length(beh)
    if(beh(i)==0)
        hold on;plot([i i],[0 1],'k','LineWidth',5)
    elseif(beh(i)==1)
        hold on;plot([i i],[0 1],'b','LineWidth',5)
    elseif(beh(i)==2)
        hold on;plot([i i],[0 1],'r','LineWidth',5)
    end
    axis tight
        
end
% temp_signal=squeeze(new_signal(ii,2:end,:))';


norm_signal=temp_signal';
for i=1:length(norm_signal)
    norm_signal(i,:)=norm_signal(i,:)-min(norm_signal(i,:));
    norm_signal(i,:)=norm_signal(i,:)./max(norm_signal(i,:));
end


temp_signal=norm_signal;
mean2bigXtoX=mean(temp_signal(:,51:end)');
Rated_bigXtoX=temp_signal;
sortedmeanbigXtoX=sort(mean2bigXtoX);
for i=1:max(size(temp_signal))
temp(i)=min(find(mean2bigXtoX==sortedmeanbigXtoX(i)));
Rated_bigXtoX(i,:)=temp_signal(temp(i),:);
end
figure;
% plot(mean(Rated_bigXtoX),'r');axis tight;axis off
% subplot(6,3,13)
% subplot(3,2,[1 3 5]);
pcolor(Rated_bigXtoX);shading flat;colormap parula(20);caxis([0 1])

subplot(3,2,[1 3 5]);hold on;plot([51 51],[0 length(Rated_bigXtoX)],'w--')
subplot(3,2,[2]);pcolor(Rated_bigXtoX(end-100:end,:));shading flat
subplot(3,2,[2]);hold on;plot([51 51],[0 100],'w--')
subplot(3,2,[6]);pcolor(Rated_bigXtoX(1:100,:));shading flat
subplot(3,2,[6]);hold on;plot([51 51],[0 100],'w--')
% subplot(6,3,2);hold on;plot([51 51],[0 length(Rated_bigXtoX)],'w--')


% pcolor(squeeze(new_signal(ii,2:end,:)));shading flat;colormap jet(4)
% figure;pcolor(Rated_bigXtoX');shading flat;colormap jet(4)


new_signal=mean_Close2OPEN_mouse4(find(coeff(:,2)<-0.02),:);

new_signal=Open2Open_7mice_4crossings_norm;
f = linspace(0,100,100);
xshade = [f fliplr(f)];
% figure;
subplot(3,2,[6]);hold on;    meanC1 = mean(new_signal)
    stdC1 = std(new_signal)/sqrt(min(size(new_signal)))
     y1 = (meanC1  + stdC1);
     y2 = (meanC1  - stdC1);
     
      yshade = [y1 fliplr(y2)];
        
        fill(xshade,yshade,[0.85,0.95,0.95],'EdgeColor',[0.45,0.45,0.45]);
        hold on
        plot(f,meanC1,'b','LineWidth',1)
        axis tight
        
        
        

saveas(gcf,['/Users/Machine/desktop/cell_allzones_HeatMAps/mouse1/cellmap' num2str(ii)]);
pause(1)
% plot(squeeze(mean(new_signal(ii,2:end,:))));axis tight
end


    figure;
for i=1:min(size(new_signal))
    temp=squeeze(new_signal(i,2:end,:))';
    
    h=pcolor(1:max(size(temp)),1:min(size(temp)),temp);
    hold on;
    h.ZData=ones(size(temp))*i;
    view(3)
    axis tight;shading interp;colormap(jet(10))
    pause(1)
%     averageMap=averageMap+squeeze(bigMap2(Cells_twolook(i),:,:))
end
%     h=pcolor(1:length(temp),1:length(temp),squeeze(averageMap));
%      h.ZData=ones(size(temp))*Cells_twolook(i)+100;
    view(3)
    axis tight;shading interp;colormap(jet)
%     pcolor(squeeze(averageMap))
    


    norm_transients=Close2OPEN_7mice_pool;
for i=1:max(size(norm_transients))

mincell=abs(min(norm_transients(i,:)));
maxcell=abs(max(norm_transients(i,:)));
if(maxcell>mincell)
    ref_baseline=maxcell;
else
    ref_baseline=mincell;
end 
% norm_transients(:,i)=norm_transients(:,i)/mean(norm_transients(:,i));
norm_transients(i,:)=norm_transients(i,:)/ref_baseline;
% norm_transients(:,i)=norm_transients(:,i)./abs(min(norm_transients(:,i)));
end
            
% figure;imagesc(norm_transients);shading flat
% figure;plot(mean(abs(norm_transients)))

Close2OPEN_7mice_pool=norm_transients;