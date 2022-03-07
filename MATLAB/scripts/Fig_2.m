t = 0:0.1:100;

E0 = 3;
Einf = 9;
alp1 = 1;
alp2=-1;

E1A = 1+((E0-1)*(Einf-1))./((E0-1)+(Einf-E0).*exp(-alp1.*t));
E2A = 1+((E0-1)*(Einf-1))./((E0-1)+(Einf-E0).*exp(-alp2.*t));

n = 1001;
for i = 1:n;
y1(i) = Einf;
y2(i) = E0;
y3(i) = 1;
end

subplot(1,2,1)
hold on;
plot(t,E1A,'k',t,E2A,'k-','linewidth',2)
plot(t,y1,'k-.','linewidth',2)
plot(t,y3,'k-.','linewidth',2)
plot(0,E0,'k.','Markersize',25,'linewidth',2);
title('(a) Case I: $1<E<E_1$','Fontsize',18,'Interpreter','latex')
set(gca,'Fontsize',16)
set(gca,'Fontsize',16)
xlabel('time $t$ after $\tau$ years','Fontsize',18,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Management efficiency, $E$','Fontsize',18,'fontweight','bold','color','k','Interpreter','latex');

axis([0 10 0 10]);
axis square;
hold off;

t = 0:0.001:100;

E0 = 0.5;
Einf = 0.9;
alp1 = 0.1;
alp2=-0.1;

E1B = 1+((E0-1)*(Einf-1))./((E0-1)+(Einf-E0).*exp(-alp1.*t));
tt = 0:0.001:1.2;
E2B = 1+((E0-1)*(Einf-1))./((E0-1)+(Einf-E0).*exp(-alp2.*tt));

n = 100001;
for i = 1:n;
y1(i) = Einf;
y2(i) = E0;
y3(i) = 1;
end

subplot(1,2,2)
hold on;
plot(t,E1B,'k',tt,E2B,'k-','linewidth',2)
plot(t,y1,'k-.','linewidth',2)
plot(0,E0,'k.','Markersize',25,'linewidth',2);
plot(t(1178),E2B(1178),'k.','Markersize',25,'linewidth',2);
title('(b) Case II: $0<E<1$','Fontsize',18,'Interpreter','latex')
set(gca,'Fontsize',16)
set(gca,'Fontsize',16)
xlabel('time $t$ after $\tau$ years','Fontsize',18,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Management efficiency, $E$','Fontsize',18,'fontweight','bold','color','k','Interpreter','latex');

axis([0 10 0 1]);
axis square;
hold off;
