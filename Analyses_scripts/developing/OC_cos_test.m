% open_arm_range=[min(xxyy(:,2)) max(xxyy(:,2))]
% close_arm_range=[min(xxyy(:,1)) max(xxyy(:,1))]
% 
cum_threshold=10;
figure;plot(xxyy(:,1),xxyy(:,2));
trans1=ginput(4)
xydist1=[];
for i=1:length(trans1)
xydist1(:,i)=sqrt((xxyy(:,1)-(trans1(i,1))).^2+(xxyy(:,2)-trans1(i,2)).^2);
end


active_cells= find(sum(cell_events)>cum_threshold);

ss=ceil(sqrt(length(active_cells)));
for k=1:length(active_cells)
temp_ind=find(cell_events(:,active_cells(k))>0);

Close_arm_dist=min(xydist1(temp_ind,1:2)');
Open_arm_dist=min(xydist1(temp_ind,3:4)');
CO_event=[];
cells_pref=[];
for ii=1:length(temp_ind)
    CO_event(ii,1)=cell_events(temp_ind(ii),active_cells(k))/Close_arm_dist(ii);
    CO_event(ii,2)=cell_events(temp_ind(ii),active_cells(k))/Open_arm_dist(ii);
end

figure(10);
subplot(121);hold off;
% subplot(ss,ss,k);
compass(CO_event(:,1),CO_event(:,2),'bo');axis
hold on;compass(mean(CO_event(:,1)),mean(CO_event(:,2)),'r-')

pause(1)
% hold off
cells_pref(k)=atan2(mean(CO_event(:,2)),mean(CO_event(:,1)))*180/pi;
if(cells_pref(k)>45)
subplot(122);hold on;scatter(mean(CO_event(:,1)),mean(CO_event(:,2)),'ro')
else
    subplot(122);hold on;scatter(mean(CO_event(:,1)),mean(CO_event(:,2)),'ko')
end

end