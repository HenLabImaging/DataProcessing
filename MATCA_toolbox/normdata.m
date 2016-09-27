function outdata=normdata(rawdata)  


norm_transients=rawdata;
        for i=1:min(size(rawdata))
        mincell=abs(min(rawdata(:,i)));
        maxcell=abs(max(rawdata(:,i)));
            if(maxcell>mincell)
            ref_baseline=maxcell;
             else
            ref_baseline=mincell;
            end 
        % norm_transients(:,i)=norm_transients(:,i)/mean(norm_transients(:,i));
            norm_transients(:,i)=norm_transients(:,i)/ref_baseline;
% norm_transients(:,i)=norm_transients(:,i)./abs(min(norm_transients(:,i)));
        end
        outdata=norm_transients;
end