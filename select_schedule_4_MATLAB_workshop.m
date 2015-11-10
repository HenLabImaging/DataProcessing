function select_schedule_4_MATLAB_workshop
name=char(inputdlg('Enter your name:'));
choice1 = menu('Choose a day','Mon','Tue','Wed','Th')
choice2= menu('Choose an available time','1:00''2:00-3:00pm','3:00-4:00pm','4:00-5:00pm')
    fin = fopen('eliminated.txt','r');
      fout = fopen('eliminated.txt','a');
switch choice1
   
    case 1
       switch choice2
           case 1
                 fprintf(fout,'%s\n','Monday, 10-11am',name);
           case 2
              fprintf(fout,'%s\n','Monday, 1-2pm',name);
                 disp(5)
           case 3
               fprintf(fout,'%s\n','Monday, 2-3pm',name);
           case 4
                fprintf(fout,'%s\n','Monday, 3-4pm',name);
       end
        
          case 2
       switch choice2
           case 1
                 fprintf(fout,'%s\n','Tue, 10-11am',name);
           case 2
              fprintf(fout,'%s\n','Tue, 1-2pm',name);
                 disp(5)
           case 3
               fprintf(fout,'%s\n','Tue, 2-3pm',name);
           case 4
                fprintf(fout,'%s\n','Tue, 3-4pm',name);
       end
        
       
         case 3
       switch choice2
           case 1
                 fprintf(fout,'%s\n','Wed, 10-11am',name);
           case 2
              fprintf(fout,'%s\n','Wed, 1-2pm',name);
                 disp(5)
           case 3
               fprintf(fout,'%s\n','Wed, 2-3pm',name);
           case 4
                fprintf(fout,'%s\n','Wed, 3-4pm',name);
       end
       
        case 4
       switch choice2
           case 1
                 fprintf(fout,'%s\n','Thursday, 10-11am',name);
           case 2
              fprintf(fout,'%s\n','Thursday, 1-2pm',name);
                 disp(5)
           case 3
               fprintf(fout,'%s\n','Thursday, 2-3pm',name);
           case 4
                fprintf(fout,'%s\n','Thursday, 3-4pm',name);
       end
       
       
       
       
       
       
end

fclose(fout)
end