TopActiveCells=find(all(Active_cells(1:num_cell,:)'>10)>0)




acells=find(Active_cells(:,1)>5)
stdab=3.44+2*1.89;
A_Bcells=find(Active_cells(acells,1)>stdab+Active_cells(acells,2))
A_Bcells=acells(A_Bcells)

bcells=find(Active_cells(:,2)>5)
meanba=mean(std(Active_cells(bcells,1:2)')')
stdba=std(std(Active_cells(bcells,1:2)')')
stdBA=meanba+2*stdba
B_Acells=find(Active_cells(bcells,2)>stdBA+Active_cells(bcells,1))
B_Acells=bcells(B_Acells)

ABcommon=ABtotal;
aa=zeros(length(A_Bcells),1)
for i=1:length(A_Bcells)
bb=any(A_Bcells(i)==ABtotal)
bbb=find(A_Bcells(i)==ABtotal)
if(bb>0)
aa(i)=bb
ABcommon(bbb)=[];
end
end

onlyA=A_Bcells(find(aa>0))

aa=zeros(length(B_Acells),1)

for i=1:length(B_Acells)
bb=any(B_Acells(i)==ABtotal)
bbb=find(A_Bcells(i)==ABtotal)
if(bb>0)
aa(i)=bb
ABcommon(bbb)=[];
end
end

onlyB=B_Acells(find(aa>0))

ccells=find(Active_cells(:,3)>5)
aa=zeros(length(ABcommon),1)

for i=1:length(ABcommon)
bb=any(ABcommon(i)==ccells)
% bbb=find(A_Bcells(i)==ABcommon)
if(bb>0)
aa(i)=bb
% ABcommon(bbb)=[];
end
end

