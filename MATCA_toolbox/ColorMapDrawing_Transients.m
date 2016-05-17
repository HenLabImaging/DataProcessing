function ColorMapDrawing_Transients(fs_Ca,time1,time2,DATA)
    [l,y]=size(DATA);
    t=linspace(time1,time2,length(DATA));
    figure;imagesc(t,1:y,DATA');colorbar;colormap jet(20);
    xlabel('seconds','FontSize',16);ylabel('cell','FontSize',16);
    set(gcf,'Color',[1 1 1])
end
