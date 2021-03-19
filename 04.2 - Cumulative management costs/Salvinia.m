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
27];

n = time(end);

cost = [78353.19113
155859.1404
231887.9686
335757.4769
439626.9851
543496.4934
571337.1734
599177.8534
627018.5334
654859.2134
682699.8935
710540.5735
738381.2535
766221.9335
794062.6135
821903.2935
849743.9735
877584.6536
905425.3336
933266.0136
961106.6936
988947.3736
1016788.054
1044628.734
1072469.414
1100310.094
1128150.774
1155991.454]*10^-6;

%b1(1) = r
%b1(2) = K
%b1(3) = C0

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t)));
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;

r = 0.166801187564529;
K = 1.12583974235545;
C0 = 0.238968675270115;
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
title('Salvinia','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative management cost, $M(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',20); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);
