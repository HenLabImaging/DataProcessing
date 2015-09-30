[xA]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextA-ethovision.xlsx','C:D');
[xB]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextB-ethovision.xlsx','C:D');
[xC]=xlsread('/Users/Gokhan_mac/Desktop/DG_data/FINAL_DG1_2_4/New DG imaging etho track/DG4_contextC-ethovision.xlsx','C:D');

Traj=xC;

N = 50^2; % select your bin size (max size/N)

% gridxy1=ceil(max(xC));
% gridxy2=floor(min(xC));

subplot(331)

% x = linspace(-24,16,sqrt(N)+1);         %smaller arena;C
% y = linspace(-8,16,sqrt(N)+1);

x = linspace(-25,25,sqrt(N)+1);       %bigger one;A
y = linspace(-25,25,sqrt(N)+1);

X=zeros(sqrt(N));
bin_size=max([x y])*2/sqrt(N);

% Horizontal grid 
for k = 1:length(y)
  line([x(1) x(end)], [y(k) y(k)])
end

% Vertical grid
for k = 1:length(x)
  line([x(k) x(k)], [y(1) y(end)])
end
hold on;
scatter(Traj(:,1),Traj(:,2),'b.');axis tight
% for ii=1:length(xC)
%     scatter(xC(ii,1),xC(ii,2),'b.');
%     pause(.1);
% end

roundTraj=round(Traj);
shift_Traj=roundTraj;
shift_Traj(:,1)=abs(min(roundTraj(:,1)))+roundTraj(:,1);
shift_Traj(:,2)=abs(min(roundTraj(:,2)))+roundTraj(:,2);

X=zeros(sqrt(N));
X2=X;
shift_Traj;
for k=1:length(X)
    for kk=1:length(X)
        aa=find(shift_Traj(:,1)==k&shift_Traj(:,2)==kk);
        X(kk,k)=length(find(diff(aa)>3));
        X2(kk,k)=length(find(diff(aa)==1));
    end
end
subplot(332);pcolor(X);colorbar;title('#Visit Map')
subplot(333);pcolor(X2);colorbar;title('Occupancy Map, (samples)')
