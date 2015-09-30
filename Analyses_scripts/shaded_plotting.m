%         x=[0:1:1000];
%         y=x.*x;
%         std1=y*.1;
%         y1=y+std1; y2=y-std1;

         fill(xshade,yshade,[0.65,0.35,0.55],'EdgeColor',[0.45,0.45,0.45]);
        
        f = linspace(0,100,100);
%         logf = 10*log10(f);
%         logf(1) = 0;
        xshade = [f,fliplr(f)];
%         figure;
        coh   = Rated_matrix';
        
        meanC1 = mean(coh);
        stdC1 = std(coh)/sqrt(length(coh));
        
        figure;
%          meanC1 = y;
%         stdC1 = yy2;
        
        y1 = (meanC1  + stdC1);
        y2 = (meanC1  - stdC1);
        
        yshade = [y1,fliplr(y2)];
        
        fill(xshade,yshade,[0.65,0.35,0.55],'EdgeColor',[0.45,0.45,0.45]);
        hold on
        plot(f,meanC1,'b','LineWidth',1)