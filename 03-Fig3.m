%CODE for Fig 3 plots

Km = 100; %Cost carrying capacity for cumulative management costs
C0 = 10; %Initial management cost
r = 0.1; %Intrinsic growth rate for management costs  

%Varying management effort;
gam1 = 0.2;
gam2 = 0.4;
gam3 = 0.6;
gam4 = 0.8;
gam5 = 1;

%Management delay
tau = 50;

for j = 1:101;
xaxis(j) = 0;
end

dt = 0.01;
T = 200;
for i = 1:T/dt + 1;
time(i) = dt.*(i - 1);
KM(i) = Km;
end

%Cumulative management costs with varying management effort
solution1M = gam1.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time - tau)))).*heaviside(time-tau);
solution2M = gam2.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time - tau)))).*heaviside(time-tau);
solution3M = gam3.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time - tau)))).*heaviside(time-tau);
solution4M = gam4.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time - tau)))).*heaviside(time-tau);
solution5M = gam5.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time - tau)))).*heaviside(time-tau);

%Cost of inaction with varying management effort (special case in the absence of management action, i.e., where management delay parameter (tau) approaches infinity)
solution1M0 = gam1.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time)))).*heaviside(time);
solution2M0 = gam2.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time)))).*heaviside(time);
solution3M0 = gam3.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time)))).*heaviside(time);
solution4M0 = gam4.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time)))).*heaviside(time);
solution5M0 = gam5.*(KM./(1+(KM./C0 - 1).*exp(-r.*(time)))).*heaviside(time);

%Cost of inaction for varying management efforts, with management delay fixed at tau = 50 
solution1 = solution1M0 - solution1M;
solution2 = solution2M0 - solution2M;
solution3 = solution3M0 - solution3M;
solution4 = solution4M0 - solution4M;
solution5 = solution5M0 - solution5M;

subplot(2,2,1);
hold on;
plot(time,solution1M,'k','linewidth',2.5);  
plot(time,solution2M,'k--','linewidth',2.5);  
plot(time,solution3M,'k-.','linewidth',2.5);
plot(time,solution4M,'k:','linewidth',2.5);  
plot(time,solution5M,'b','linewidth',2.5);  
axis on;
set(gca,'fontsize',14); %axis numbering font size 
title('Plot (a)','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative management cost','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 T 0 Km]);

subplot(2,2,2);
hold on;
plot(time,solution1M0,'k','linewidth',2.5);  
plot(time,solution2M0,'k--','linewidth',2.5);  
plot(time,solution3M0,'k-.','linewidth',2.5);
plot(time,solution4M0,'k:','linewidth',2.5);  
plot(time,solution5M0,'b','linewidth',2.5);  
axis on;
set(gca,'fontsize',14); %axis numbering font size 
title('Plot (b) $\tau\rightarrow\infty$','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cost of inaction','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 T 0 Km]);

subplot(2,2,3);
hold on;
h1 = plot(time,solution1,'k','linewidth',2.5);  
h2 = plot(time,solution2,'k--','linewidth',2.5);  
h3 = plot(time,solution3,'k-.','linewidth',2.5);
h4 = plot(time,solution4,'k:','linewidth',2.5);  
h5 = plot(time,solution5,'b','linewidth',2.5);  

axis on;
legend([h1 h2 h3 h4 h5],'$\gamma=0.2$','$\gamma=0.4$','$\gamma=0.6$','$\gamma=0.8$','$\gamma=1$','Location','NorthEastOutside')
set(legend,'FontSize',20,'Interpreter','latex');
legend boxoff;
set(gca,'fontsize',14); %axis numbering font size 
title('Plot (c) $\tau=50$','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cost of inaction','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 T 0 Km]);




