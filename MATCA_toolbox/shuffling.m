function ssdata=shuffling(fs,time1,time2,cell1,cell2,DATA)
    shuffling_choice=menu('Type of shuffling','Across variables (cell)','Across time');
   if(shuffling_choice==1)
       
       Ncells=cell2-cell1+1;
       global shuffled_data
       shuffle_X=randperm(Ncells)
       
       for i=1:Ncells
       shuffled_data(:,i)=DATA(:,shuffle_X(i));
       end
       ssdata=shuffled_data;
   end
       