%CODE for Fig 6 plots

%time for damage costs
time = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 32 36 43 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 91];

n = time(end);

cost = [375865310.2 %Cumulative damage costs
1859368038
1948802729
2489781122
3507956193
4440145251
5558662715
5968809140
6393118385
7938777526
9571315518
11161643901
11352288232
12879452602
14221567589
14296231740
15057230244
15209186600
16959341254
17066891130
17267380722
17943237207
18118002255
18176838822
18231275055
18821095939
18878176427
18903176954
18949895543
18965509275
18971250129
19014842721
19024729466
19049406928
19074084390
19098761853
19123439315
19148116777
19172794239
19197471701
19197922998
19222600460
19222980548
19223044247
19223295408
19223714942
19265074630
19271605592
19312965280
19313157649
19318649813
19410160430
19434837892]*10^-6;

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t))); %Logistic vurve non-linear regression fitting
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

%Estimated parameters
rD = 0.243593284247693; %Intrinsic growth rate for damage costs 
K = 19183.4809844632; %Cost carrying capacity for cumulative damage costs
C0 = 1450.53725635434; %Initial damage cost

t = 0:0.1:n; 
CC = K./(1+(K./C0 - 1).*exp(-rD.*t)); %Logistic curve

tnew = t';
[ynew,ynewci_B] = predict(mdl1,tnew); %Confidence regions

subplot(2,2,1)
hold on
plot(t,ynewci_B(:,1),'r-.','linewidth',1.5)
plot(t,ynewci_B(:,2),'r-.','linewidth',1.5)
jbfill(t,ynewci_B(:,2)',ynewci_B(:,1)','red','none',0,0.1);
hold on;
plot(t,CC,'k',time,cost,'ko','linewidth',2);
axis([0 n 0 cost(end)]);
title('Plot (a) Cumulative damage cost','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('$C(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',18); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);

%time for management costs
time = [0  1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 18 19 20 21 22 23 24 25 26 27 28 29 30 32 36 40];

n = time(end);

cost = [138950017 %Cumulative management costs
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

modelfun1 = @(b1,t) ((b1(1).*K)./(1+(K./C0 - 1).*exp(-b1(2).*t))); %Logistic vurve non-linear regression fitting
beta1 = [1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;
%Estimated parameters
K = 19183.4809844632; %Cost carrying capacity for cumulative management costs
C0 = 1450.53725635434; %Initial management cost
gam = 0.13020158362675; %Management effort
rM = 0.153294868601048; %Intrinsic growth rate for management costs 

t = 0:0.1:n;
CC = gam.*K./(1+(K./C0 - 1).*exp(-rM.*t)); %Logistic curve

tnew = t';
[ynew,ynewci_B] = predict(mdl1,tnew);

subplot(2,2,2)
hold on
plot(t,ynewci_B(:,1),'r-.','linewidth',1.5)
plot(t,ynewci_B(:,2),'r-.','linewidth',1.5)
jbfill(t,ynewci_B(:,2)',ynewci_B(:,1)','red','none',0,0.1);

hold on;
plot(t,CC,'k',time,cost,'ko','linewidth',2);
axis([0 n 0 3000]);
title('Plot (b) Cumulative management cost','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('$M(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',18); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);

K = 19183.4809844632;
C0 = 1450.53725635434;
rD = 0.243593284247693;
rM = 0.153294868601048;
gam = 0.13020158362675;

%Management delay times
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
T = 120;
for i = 1:T/dt + 1;
time(i) = dt.*(i - 1);
KK(i) = K;
end

solutionD = K./(1+(K./C0 - 1).*exp(-rD.*time)); %Cumulative damage cost

%Cost in the absence of management action i.e., as tau approaches infinity, see equation (11) 
solution0M = gam.*(K./(1+(K./C0 - 1).*exp(-rM.*(time)))).*heaviside(time);

%cumulative management costs for varying management delay times (tau)
solution1M = gam.*(K./(1+(K./C0 - 1).*exp(-rM.*(time - tau1)))).*heaviside(time-tau1);
solution2M = gam.*(K./(1+(K./C0 - 1).*exp(-rM.*(time - tau2)))).*heaviside(time-tau2);
solution3M = gam.*(K./(1+(K./C0 - 1).*exp(-rM.*(time - tau3)))).*heaviside(time-tau3);
solution4M = gam.*(K./(1+(K./C0 - 1).*exp(-rM.*(time - tau4)))).*heaviside(time-tau4);
solution5M = gam.*(K./(1+(K./C0 - 1).*exp(-rM.*(time - tau5)))).*heaviside(time-tau5);
solution6M = gam.*(K./(1+(K./C0 - 1).*exp(-rM.*(time-tau6)))).*heaviside(time-tau6);


solution0 = solutionD - solution0M;
solution1 = solutionD - solution1M;
solution2 = solutionD - solution2M;
solution3 = solutionD - solution3M;
solution4 = solutionD - solution4M;
solution5 = solutionD - solution5M;
solution6 = solutionD - solution6M;

%Cost of inaction for varying management delays (tau)
costinact1 = solution1 - solution0;
costinact2 = solution2 - solution0;
costinact3 = solution3 - solution0;
costinact4 = solution4 - solution0;
costinact5 = solution5 - solution0;
costinact6 = solution6 - solution0;

%Point of inflection
tinflection = (1./rM).*log(K./C0 - 1);
Cinflection = (1/2).*gam.*K;

subplot(2,2,3)
hold on;
h1 = plot(time,costinact1,'k--','linewidth',2.5);  
h2 = plot(time,costinact2,'k-.','linewidth',2.5);  
h3 = plot(time,costinact3,'k','linewidth',2.5);
h4 = plot(time,costinact4,'b--','linewidth',2.5);
h5 = plot(time,costinact5,'b-.','linewidth',2.5);
h6 = plot(time,costinact6,'b','linewidth',2.5);
h7 = plot(time,solution0M,'r','linewidth',2.5);
plot(tinflection,Cinflection,'r*','linewidth',4);
axis on;
legend([h1 h2 h3 h4 h5 h6 h7],'$\tau=10$','$\tau=20$','$\tau=30$','$\tau=40$','$\tau=50$','$\tau=60$','$\tau\rightarrow\infty$','Location','NorthEastOutside')
set(legend,'FontSize',20,'Interpreter','latex');
legend boxoff;
set(gca,'fontsize',20); %axis numbering font size 
title('Plot (c) Cost of inaction','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('$\Phi(t,\tau)$ (US\$ millions)','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 T 0 3000]);

