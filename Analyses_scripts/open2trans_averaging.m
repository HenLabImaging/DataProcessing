open2trans_all_3mice_mean=[open2trans1_mean;open2trans2_mean;open2trans3_mean;open2trans4_mean;open2trans5_mean;open2trans6_mean];
trans2open_all_3mice_mean=[trans2open1_mean;trans2open2_mean;trans2open3_mean;trans2open4_mean;trans2open5_mean;trans2open6_mean];
close2trans_all_3mice_mean =[close2trans1_mean;close2trans2_mean;close2trans3_mean;close2trans4_mean;close2trans5_mean;close2trans6_mean];
trans2close_all_3mice_mean=[trans2close1_mean;trans2close2_mean;trans2close3_mean;trans2close4_mean;trans2close5_mean;trans2close6_mean];

open2trans_aa_animal1=[open2trans1_aa+open2trans2_aa]/2;
open2trans_aa_animal2=[open2trans3_aa+open2trans4_aa]/2;
open2trans_aa_animal3=[open2trans5_aa+open2trans6_aa]/2;

trans2open_aa_animal1=[trans2open1_aa+trans2open2_aa]/2;
trans2open_aa_animal2=[trans2open3_aa+trans2open4_aa]/2;
trans2open_aa_animal3=[trans2open5_aa+trans2open6_aa]/2;

trans2open_aa_animal1_sorted

figure;subplot(321);pcolor(open2trans_aa_1animal_sorted);shading flat;hold on;stem(50,157,'w--');plot(1:100,linspace(1,157,100),'k')
subplot(323);pcolor(open2trans_aa_animal2_sorted);shading flat;hold on;stem(50,100,'w--');plot(1:100,linspace(1,100,100),'k')
subplot(325);pcolor(open2trans_aa_animal3_sorted);shading flat;hold on;stem(50,316,'w--');plot(1:100,linspace(1,316,100),'k')
subplot(322);pcolor(trans2open_aa_animal1_sorted);shading flat;hold on;stem(50,157,'w--');plot(1:100,linspace(1,157,100),'k')
subplot(324);pcolor(trans2open_aa_animal2_sorted);shading flat;hold on;stem(50,100,'w--');plot(1:100,linspace(1,100,100),'k')
subplot(326);pcolor(trans2open_aa_animal3_sorted);shading flat;hold on;stem(50,316,'w--');plot(1:100,linspace(1,316,100),'k')

open2trans_aa_all_3animals

temp=zeros(length(open2trans_aa_all_3animals),100);
clear ttemp

for i=1:length(open2trans_aa_all_3animals)
    ttemp(i)=find(open2trans_aa_all_3animals(i,:)==max(open2trans_aa_all_3animals(i,:)));
%     temp(ttemp,:)=open2closeaa_2mice(i,:)
%    figure(1);imagesc(temp);shading flat;colormap jet ;pause(0.1);
end
zz=1;
for ii=1:100
    aa=find(ttemp==ii)
    for kk=1:length(aa)
        temp(zz,:)=open2trans_aa_all_3animals(aa(kk),:);
            zz=zz+1;
    end
end

open2trans_aa_all_3animals_sorted=temp;