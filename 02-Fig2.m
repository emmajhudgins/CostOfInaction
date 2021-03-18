%CODE for Fig 2 plots

K = 100; %Cost carrying capacity for cumulative damage costs
C0 = 10; %Initial damage cost
r = 0.1; %Intrinsic growth rate for cumulative damage/management costs   
gam = 0.5; %Management effort;

%Management delay
tau1 = 10;
tau2 = 20;
tau3 = 30;
tau4 = 40;
tau5 = 50;
tau6 = 60;

for j = 1:101;
xaxis(j) = 0;
end

dt = 0.01;
T = 200;
for i = 1:T/dt + 1;
time(i) = dt.*(i - 1);
KK(i) = K;
end

solutionD = K./(1+(K./C0 - 1).*exp(-r.*time)); %Cumulative damage cost

solution_dC_dt = r.*solutionD.*(1 - solutionD./K); %Marginal damage cost

%Cost in the absence of management action i.e., as tau approaches infinity, see equation (11) 
solution0M = gam.*(K./(1+(K./C0 - 1).*exp(-r.*(time))));

%cumulative management costs for varying management delay times (tau)
solution1M = gam.*(K./(1+(K./C0 - 1).*exp(-r.*(time - tau1)))).*heaviside(time-tau1); 
solution2M = gam.*(K./(1+(K./C0 - 1).*exp(-r.*(time - tau2)))).*heaviside(time-tau2);
solution3M = gam.*(K./(1+(K./C0 - 1).*exp(-r.*(time - tau3)))).*heaviside(time-tau3);
solution4M = gam.*(K./(1+(K./C0 - 1).*exp(-r.*(time - tau4)))).*heaviside(time-tau4);
solution5M = gam.*(K./(1+(K./C0 - 1).*exp(-r.*(time - tau5)))).*heaviside(time-tau5);
solution6M = gam.*(K./(1+(K./C0 - 1).*exp(-r.*(time-tau6)))).*heaviside(time-tau6);

%Cost of inaction for varying tau
solution1 = solution0M - solution1M;
solution2 = solution0M - solution2M;
solution3 = solution0M - solution3M;
solution4 = solution0M - solution4M;
solution5 = solution0M - solution5M;
solution6 = solution0M - solution6M;

subplot(2,2,1);
hold on;
h1 = plot(time,solutionD,'k','linewidth',2.5);  
axis on;
set(gca,'fontsize',14); %axis numbering font size 
title('Plot (a)','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative damage cost','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 T 0 K]);

subplot(2,2,2);
hold on;
h1 = plot(time,solution_dC_dt,'k','linewidth',2.5); 
axis on;
set(legend,'FontSize',20,'Interpreter','latex');
legend boxoff;
set(gca,'fontsize',14); %axis numbering font size 
title('Plot (b)','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Marginal damage cost','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 T 0 3]);

subplot(2,2,3);
hold on;
h1 = plot(time,solution1M,'k--','linewidth',2.5);  
h2 = plot(time,solution2M,'k-.','linewidth',2.5);  
h3 = plot(time,solution3M,'k','linewidth',2.5);
h4 = plot(time,solution4M,'b--','linewidth',2.5);  
h5 = plot(time,solution5M,'b-.','linewidth',2.5);  
h6 = plot(time,solution6M,'b','linewidth',2.5);
axis on;
set(legend,'FontSize',20,'Interpreter','latex');
legend boxoff;
set(gca,'fontsize',14); %axis numbering font size 
title('Plot (c)','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative management cost','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 T 0 K]);

%Point of inflection
tinflection = (1./r).*log(K./C0 - 1);
Cinflection = (1/2).*gam.*K;

subplot(2,2,4);
hold on;
h1 = plot(time,solution1,'k--','linewidth',2.5);  
h2 = plot(time,solution2,'k-.','linewidth',2.5);  
h3 = plot(time,solution3,'k','linewidth',2.5);
h4 = plot(time,solution4,'b--','linewidth',2.5);  
h5 = plot(time,solution5,'b-.','linewidth',2.5);  
h6 = plot(time,solution6,'b','linewidth',2.5);
h7 = plot(time,solution0M,'r','linewidth',2.5);
plot(tinflection,Cinflection,'r*','linewidth',4);
axis on;
legend([h1 h2 h3 h4 h5 h6 h7],'$\tau=10$','$\tau=20$','$\tau=30$','$\tau=40$','$\tau=50$','$\tau=60$','$\tau\rightarrow\infty$','Location','NorthEastOutside')
set(legend,'FontSize',20,'Interpreter','latex');
legend boxoff;
set(gca,'fontsize',14); %axis numbering font size 
title('Plot (d)','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cost of inaction','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 T 0 60]);

