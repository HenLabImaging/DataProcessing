function newdata=export_data(DATA,filen,dir)
saveformat=menu('select saving format','Excel','text','mat','ASCII')

switch saveformat

    case 1
    xlswrite([dir filen],DATA)
    case 2
        save([dir filen '.txt'],'DATA','-ascii')
    case 3
        save([dir filen '.mat'],'DATA','-mat')
    case 4
        save([dir filen],'DATA','-ascii')     
        
end

end