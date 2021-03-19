time = [33
34
35
36
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
] - 33; 

n = time(end);

cost = [2154.805394
100420.8808
416395.8119
636259.4729
1111778.196
1997372.551
3255155.171
5010843.288
7466131.977
10778553.04
14258303.32
18091293.33
22368557.03
27934238.7
35848747.94
45586111.7
55271385.92
63381899
70300990.17
76504311.57
82597630.32
88667172.53
91582490.79]*10^-6;

%b1(1) = r
%b1(2) = K
%b1(3) = C0

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t)));
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;

r = 0.339358804498289;
K = 102.351962674673;
C0 = 0.356082927833283;
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
title('Procyon','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Accumulated cost, $C(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',20); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);
