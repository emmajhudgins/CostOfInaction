time = [0
1
2
3
4
5
8
9
10
11
12
13
14
15
16
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
30];

n = time(end);

cost = [741.6714041
4305.8162
5021.314697
5303.02658
5596.771815
5654.652461
12522.25368
19389.8549
924952.5512
1830515.248
2736077.944
3641640.64
4547203.336
5452766.033
6358328.729
7263891.425
8169454.122
9075016.818
9980579.514
9997415.874
10005584.31
10014636.05
10032665.43
10056139.94
10074184.55
10107018.05
10116719.8
10128284.71
10135152.31]*10^-6;

%b1(1) = r
%b1(2) = K
%b1(3) = C0

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t)));
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;

r = 0.459344813717825;
K = 10.2140418080708;
C0 = 0.0123115502575686;
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
title('Cenchrus','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative management cost, $M(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',20); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);
