firsthalfmean=mean(open2closeall_mean_2mice(:,1:50)')'
sorted=sort(firsthalfmean);
sorted_crosses=[];

for i=1:length(sorted)
    temp=find(sorted(i)==firsthalfmean)
    temp=temp(1);
    sorted_crosses(i,:)=open2closeall_mean_2mice(temp,:);
end

for i=1:length(sorted)
   maxs=max(sorted_crosses(i,:));
   mins=abs(min(sorted_crosses(i,:)));
   if(maxs>mins)
       thres=maxs;
   else
       thres=mins;
   end
    
sorted_norm_crosses(i,:)=sorted_crosses(i,:)./thres;
end

refminval= min(min(open2closeaa_2mice));
refmaxval=max(max(open2closeaa_2mice));

for i=1:416
    minabsval=abs(min(open2closeaa_2mice(i,:)));
     maxval=max(open2closeaa_2mice(i,:));
     if(minabsval>maxval)
        open2closeaa_2mice(i,:)= open2closeaa_2mice(i,:)./refminval;
     else
       open2closeaa_2mice(i,:)=  open2closeaa_2mice(i,:)./refmaxval;
     end
end

reshaped_aa_2mice=zeros(416,100);
sorted_aa_2mice=sort(max(open2closeaa_2mice'));
for i=1:416
    temp2=find(max2mice==sorted_aa_2mice(i))
    reshaped_aa_2mice(i,:)=open2closeaa_2mice(temp2,:);
%     figure(1);pcolor(reshaped_aa_2mice);shading flat;colormap jet;pause(.5);
% pause;
end





for i=1:416
    temp2=find(open2closeaa_2mice(i,:)==max(open2closeaa_2mice(i,:)))
    if(sorted_aa_2mice(temp2,:)==0)
        sorted_aa_2mice(temp2,:)=open2closeaa_2mice(i,:);
    else
        while(temp2<416)
            temp2=temp2+1;
            if(sorted_aa_2mice(temp2,:)==0)
                sorted_aa_2mice(temp2,:)=open2closeaa_2mice(i,:);
                temp2=416;
            end
        end
    end
    figure(1);pcolor(sorted_aa_2mice);shading flat;colormap jet;pause;
end