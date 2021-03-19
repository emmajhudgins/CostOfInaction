time = [0
1
2
3
4
5
6
7
8
9
10
11
12
13
14
17
18
19
20
21
22
23
24
25
26
27
28
29
30
32
36
40];

n = time(end);

cost = [138950017
166602601.6
176812347.1
187009400.7
203291901.2
503948603.4
660628421.4
663599878.3
663905402.7
664460724
664766248.3
665591064.2
754526763.2
766350331.5
796321633.7
1193635823
1214016313
1279209039
1393003438
1952463440
2002289313
2052020186
2101751059
2110857963
2120059442
2129657370
2139917069
2149023973
2158130876
2219159009
2232363884
2427863732]*10^-6;

%b1(1) = r
%b1(2) = K
%b1(3) = C0

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t)));
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;

r = 0.162582642305012;
K = 2474.18946060765;
C0 = 163.110940755348;
CC = K./(1+(K./C0 - 1).*exp(-r.*t));

tnew = t';
[ynew,ynewci_B] = predict(mdl1,tnew);

hold on
plot(t,ynewci_B(:,1),'r-.','linewidth',1.5)
plot(t,ynewci_B(:,2),'r-.','linewidth',1.5)
jbfill(t,ynewci_B(:,2)',ynewci_B(:,1)','red','none',0,0.1);

hold on;
plot(t,CC,'k',time,cost,'ko','linewidth',2);
axis([0 n 0 cost(end).*1.1]);
title('Aedes','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative management cost, $M(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',20); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);
