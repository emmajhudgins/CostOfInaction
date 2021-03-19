time = [0
1
2
3
4
5
7
8
9
10
23
44
46
61
62
89
91
95
96
97
101
128
138
147
148
154
262
267
311];

n = time(end);

cost = [41362581.05
43334465.92
46077960.89
46533011.25
148919341
409359827.1
594868688.2
934639619.4
1517255756
1828358515
1926497708
1928317910
1929834744
1957137765
2107759433
3025444314
3425281892
3439691820
3439843503
4950155629
6115539586
6247959239
6272683642
6362099167
6738577493
6784442549
6787491314
6789159831
6789311515]*10^-6;

%b1(1) = r
%b1(2) = K
%b1(3) = C0

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t)));
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;

r = 0.0322386298645813;
K = 7094.85080052044;
C0 = 463.605448139073;
CC = K./(1+(K./C0 - 1).*exp(-r.*t));

tnew = t';
[ynew,ynewci_B] = predict(mdl1,tnew);

hold on
plot(t,ynewci_B(:,1),'r-.','linewidth',1.5)
plot(t,ynewci_B(:,2),'r-.','linewidth',1.5)
jbfill(t,ynewci_B(:,2)',ynewci_B(:,1)','red','none',0,0.1);

    

plot(t,CC,'k-',time,cost,'ko','linewidth',2);
axis([0 n 0 cost(end)*1.2]);
title('Ambrosia','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Accumulated cost, $C(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',20); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);
