%%Confirm the crossings
close all
for i=1:length(zoneYtoX)
figure;plot(xxyy(:,1),xxyy(:,2));
hold on;plot(xxyy_down_aligned(zoneYtoX(i)-10:zoneYtoX(i),1),xxyy_down_aligned(zoneYtoX(i)-10:zoneYtoX(i),2),'ko','MarkerSize',10)
hold on;plot(xxyy_down_aligned(zoneYtoX(i):zoneYtoX(i)+10,1),xxyy_down_aligned(zoneYtoX(i):zoneYtoX(i)+10,2),'ro','MarkerSize',10)
end


for i=1:length(zoneYtoCenter)
figure;plot(xxyy(:,1),xxyy(:,2));
hold on;plot(xxyy_down(zoneYtoCenter(i)-50:zoneYtoCenter(i),1),xxyy_down(zoneYtoCenter(i)-50:zoneYtoCenter(i),2),'ko')
hold on;plot(xxyy_down(zoneYtoCenter(i):zoneYtoCenter(i)+50,1),xxyy_down(zoneYtoCenter(i):zoneYtoCenter(i)+50,2),'ro')

end


%% Concatenate the crosses and cells
TimeW=50;
bigMatrix=[];
BigMatrix=[];
Rated_bigXtoX=[];
temp=[];

des_signal=norm_transients;
des_crosses=zoneYtoX;
for i=1:length(des_crosses)
%     figure(1);subplot(221);pcolor(Aligned_transients(zoneXtoX(i)-TimeW:zoneXtoX(i)+TimeW,:)');shading flat
%     pause(1)
    bigMatrix(i,:,:)=des_signal(des_crosses(i)-TimeW+1:des_crosses(i)+TimeW,:);
    BigMatrix(i,:)=mean(des_signal(des_crosses(i)-TimeW+1:des_crosses(i)+TimeW,:)');
end
    meanbigXtoX=squeeze(mean(bigMatrix));
    mean2bigXtoX=mean(meanbigXtoX(TimeW:2*TimeW,:));
    Rated_bigXtoX=meanbigXtoX;
    sortedmeanbigXtoX=sort(mean2bigXtoX);
for i=1:min(size(working_transients))
temp=min(find(mean2bigXtoX==sortedmeanbigXtoX(i)))
Rated_bigXtoX(:,i)=meanbigXtoX(:,temp);
end
        
        figure(1);subplot(221);pcolor(Rated_bigXtoX');shading flat;colormap jet;colorbar;
        figure(2);subplot(221);pcolor(BigMatrix);shading faceted;
        hold on;stem(TimeW+0.5,min(size(working_transients))+1,'w:','LineWidth',5);title('X to X','Fontsize',14);
%%


% figure;imagesc(diaz_32_ZM_close2open_cross_all) %check the dominant crossings
% figure; plot(mean((squeeze(mean(bigMatrix_3([1:end],:,:)))')))
% figure; imagesc(squeeze(mean(bigMatrix_3([1:end],:,:)))')


% des_data=squeeze(mean(diaz_32_ZM_open2close_all([1:end],:,:)));
des_data_norm=[];
des_data=o2o_first5_7mice_trimmed;
for i=1:max(size(des_data))
    des_data_norm(:,i)=des_data(:,i)-min(des_data(:,i));
    des_data_norm(:,i)=des_data_norm(:,i)./max(des_data_norm(:,i));
end

% des_data_norm=des_data-min(min(des_data));
% des_data_norm=des_data_norm./mean(mean(des_data_norm));


temp_matrix=des_data_norm;
Rated_matrix=[];
meantemp=sum(temp_matrix(1:50,:))
sortedmeantemp=sort(meantemp)
% sortt=[];
for i=1:length(sortedmeantemp)
% temp=min(find(meantemp==sortedmeantemp(i)))
% sortt(i)=temp;
temp=sortt(i);
Rated_matrix(:,i)=temp_matrix(:,temp);
end
% figure;
subplot(2,4,4);pcolor(Rated_matrix(:,[1:20,end-20:end])');shading flat;colormap parula(4);axis tight

hold on;plot([1 100],[20 20],'w--','LineWidth',2)
hold on;plot([50 50],[1 40],'w:','LineWidth',2);title(['Ranked Cells, N= ', num2str(length(temp_matrix))])
% subplot(312);plot(mean(Rated_matrix'))

%%
        f = linspace(0,100,100);

        shade_plot=Rated_matrix(1:100,[1:20]);
        logf(1) = 0;
        xshade = [f,fliplr(f)];
%         figure;
        coh   = shade_plot';
        
        meanC1 = mean(coh);
        stdC1 = std(coh)/sqrt(length(coh));
        
subplot(2,4,8);
%          meanC1 = y;
%         stdC1 = yy2;
        
        y1 = (meanC1  + stdC1);
        y2 = (meanC1  - stdC1);
        
        yshade = [y1,fliplr(y2)];
        
        fill(xshade,yshade,[0.65,0.35,0.55],'EdgeColor',[0.45,0.45,0.45]);
        hold on
        plot(f,meanC1,'b','LineWidth',1)
        %%
        
        
        des_data=vhpc_2mice_zm_open2close_cross_all';

des_data_norm=des_data-min(min(des_data));
des_data_norm=des_data_norm./max(max(des_data_norm));


temp_matrix=des_data_norm;
Rated_matrix=[];
meantemp=sum(temp_matrix(1:50,:))
sortedmeantemp=sort(meantemp)
sortt=[];
for i=1:min(size(temp_matrix))
temp=min(find(meantemp==sortedmeantemp(i)))
sortt(i)=temp;
% temp=sortt(i);
Rated_matrix(:,i)=temp_matrix(:,temp);
end
        
subplot(313);pcolor( Rated_matrix') ;shading flat      



%%
