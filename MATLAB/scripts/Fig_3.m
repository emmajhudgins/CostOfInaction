%Damage paramters
r =  0.1;
K = 100;
A = 1;
D0 = r.*K./(1 + K./A);

%Management parameters 
rM = 0.1;
KM = 25;
AM = 0.5;
M0 = 0.5.*rM.*KM./(1 + KM./AM);

alp = 0.01;
E0 = 2;
E1 = 5;

t = 0:0.01:1000;
alpp = -alp;
tau = 0;
Damage_cost = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
Management_cost = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);

Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alpp.*(t-tau)));

Realized_damage1 = Damage_cost - Eff.*Management_cost;
Total_cost1 = Realized_damage1 + Management_cost;

subplot(2,2,1);
hold on;
h1 = plot(t,Management_cost,'b','linewidth',2.5);  
h2 = plot(t,Damage_cost,'k','linewidth',2.5);    
h3 = plot(t,Realized_damage1,'k-.','linewidth',2.5);
h4 = plot(t,Total_cost1,'r-.','linewidth',2.5);
plot(49.53, 1.63,'k*','linewidth',10);
plot(47.46, 2.14,'r*','linewidth',10);

axis on;
legend([h2 h4 h3 h1],'Damage cost, $D$','Total cost, $T$','Realized damage cost, $D^*$','Management cost, $M$','Location','northeast');
set(legend,'FontSize',18,'Interpreter','latex');
legend boxoff;
set(gca,'fontsize',16); %axis numbering font size 
title('(a) $\alpha=-0.01, \tau=0$','Fontsize',20,'Interpreter','latex')
ylabel('Marginal cost','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 120 0 3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpp = alp;
tau = 0;

t = 0:0.01:1000;
Damage_cost = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
Management_cost = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);

Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alpp.*(t-tau)));

Realized_damage2 = Damage_cost - Eff.*Management_cost;
Total_cost2 = Realized_damage2 + Management_cost;

subplot(2,2,2);
hold on;
h1 = plot(t,Management_cost,'b','linewidth',2.5);  
h2 = plot(t,Damage_cost,'k','linewidth',2.5);    
h3 = plot(t,Realized_damage2,'k-.','linewidth',2.5);
h4 = plot(t,Total_cost2,'r-.','linewidth',2.5);
plot(50.68, 1.27,'k*','linewidth',10);
plot(48.17, 1.76,'r*','linewidth',10);

axis on;
set(gca,'fontsize',16); %axis numbering font size 
title('(b) $\alpha=0.01, \tau=0$','Fontsize',20,'Interpreter','latex')
axis([0 120 0 3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


alpp = -alp;
tau = 20;

t = 0:0.01:1000;
Damage_cost = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
Management_cost = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);

Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alpp.*(t-tau)));

Realized_damage3 = Damage_cost - Eff.*Management_cost;
Total_cost3 = Realized_damage3 + Management_cost;

subplot(2,2,3);
hold on;
h1 = plot(t,Management_cost,'b','linewidth',2.5);  
h2 = plot(t,Damage_cost,'k','linewidth',2.5);    
h3 = plot(t,Realized_damage3,'k-.','linewidth',2.5);
h4 = plot(t,Total_cost3,'r-.','linewidth',2.5);
plot(42.70, 1.82,'k*','linewidth',10);
plot(44.65, 2.19,'r*','linewidth',10);

axis on;
title('(c) $\alpha=-0.01, \tau=20$','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Marginal cost','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 120 0 3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpp = alp;
tau = 20;

t = 0:0.01:1000;
Damage_cost = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
Management_cost = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);

Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alpp.*(t-tau)));

Realized_damage4 = Damage_cost - Eff.*Management_cost;
Total_cost4 = Realized_damage4 + Management_cost;

subplot(2,2,4);
hold on;
h1 = plot(t,Management_cost,'b','linewidth',2.5);  
h2 = plot(t,Damage_cost,'k','linewidth',2.5);    
h3 = plot(t,Realized_damage4,'k-.','linewidth',2.5);
h4 = plot(t,Total_cost4,'r-.','linewidth',2.5);
plot(41.67, 1.71,'k*','linewidth',10);
plot(43.51, 2.05,'r*','linewidth',10);

axis on;
set(gca,'fontsize',16); %axis numbering font size 
title('(d) $\alpha=0.01, \tau=20$','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 120 0 3]);





