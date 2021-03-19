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
14];

n = time(end);

cost = [84928253.41
254033241.8
423841415.6
593649589.4
763457763.1
934389985.6
1062791102
1191192219
1314510209
1437828200
1560952646
1600376523
1639324234
1639572368
1639820503]*10^-6;

%b1(1) = r
%b1(2) = K
%b1(3) = C0

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t)));
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;

r = 0.436592380713455;
K = 1679.51303769119;
C0 = 194.263938618992;
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
title('Anoplophora','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative management cost, $M(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',20); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);
