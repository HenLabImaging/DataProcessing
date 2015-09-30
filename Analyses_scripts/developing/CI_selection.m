%%% CI=%95 selecting subset pop
Sel_pop=[];ON_cells=[];ON_off_cells=[];OFF_cells=[];Sel_pop1=[];Sel_pop2=[];
for i=1:length(O2C_7mice_Rated)
    temp1=mean(O2C_7mice_Rated(1:50,i)); %pre-event subsets
%     temp2=mean(O2C_7mice_Rated(51:100,i)); %pre-event subsets
    CI1(i)=normcdf(temp1,mean(mean(O2C_7mice_Rated(1:50,:))),mean(std(O2C_7mice_Rated(1:50,:))));
%     CI2=normcdf(temp2,mean(mean(C2O_7mice_Rated(1:50,:))),mean(std(C2O_7mice_Rated(1:50,:))));
    if(CI1(i)>0.85)
        Sel_pop1(i)=1;
%     elseif(CI<0.1)
%         Sel_pop(i)=-1;
%     else
%         Sel_pop(i)=0;
    end
    if(CI1(i)<0.1)
        Sel_pop2(i)=1;
    end
end
figure;bar(Sel_pop)
    length(find(Sel_pop~=0))
    
    ON_cells=find(Sel_pop1>0)
    OFF_cells=find(Sel_pop2>0)
    ll=length(OFF_cells)
  
    ON_off_cells=[OFF_cells ON_cells]
    figure;pcolor(O2C_7mice_Rated(:,ON_off_cells)');shading flat;colormap parula(8)
    hold on;plot([1 100],[ll+1 ll+1],'w--','LineWidth',3)
    
    
    
    meanC2O_rated=mean(O2C_7mice_Rated);
    
     CI1_cells=meanC2O_rated((find(CI1>0.9)))
    figure;
    CI2_cells=meanC2O_rated((find(CI1<0.15)))
    for i=1:length(CI2_cells)
    temp=CI2_cells(i);
temp2=find(x<temp);

hold on;plot(CI1(i),y(1),'b*')
    end