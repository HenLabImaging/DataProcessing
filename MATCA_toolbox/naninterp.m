function X = naninterp(X,dir)
% Interpolate over NaNs
% See INTERP1 for more info
xx=X;
X(isnan(X)) = interp1(find(~isnan(X)), X(~isnan(X)), find(isnan(X)),'cubic');
figure;plot(X(:,3),X(:,4),'ro');hold on;plot(xx(:,3),xx(:,4),'bo');
saveentry=char(inputdlg('Would you like to save the new file? (y/n)'));
if(saveentry=='y')
       xlswrite([dir 'interpolated_behavior'],X)
end
return