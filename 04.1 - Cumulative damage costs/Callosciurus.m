time = [66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83] - 66;

n = time(end);

cost = [22781.97952
56431.99735
78793.46767
90286.89966
113062.5577
282209.6491
488818.6147
615145.2432
778919.535
953441.1744
1153166.996
1369718.654
1506506.18
1608270.227
1769435.591
1909512.439
1964893.417
1982724.11]*10^-6;

%b1(1) = r
%b1(2) = K
%b1(3) = C0

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t)));
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;

r = 0.403018179151914;
K = 2.06990284683158;
C0 = 0.0457554485442414;
CC = K./(1+(K./C0 - 1).*exp(-r.*t));

tnew = t';
[ynew,ynewci_B] = predict(mdl1,tnew);

hold on
plot(t,ynewci_B(:,1),'r-.','linewidth',1.5)
plot(t,ynewci_B(:,2),'r-.','linewidth',1.5)
jbfill(t,ynewci_B(:,2)',ynewci_B(:,1)','red','none',0,0.1);

hold on;
plot(t,CC,'k-',time,cost,'ko','linewidth',2);
axis([0 n 0 cost(end)*1.2]);
title('Callosciurus','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Accumulated cost, $C(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',20); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);
