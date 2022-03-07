tau1 = 10;
tau2 = 20;
tau3 = 30;
tau4 = 40;
tau5 = 50;
tau6 = 60;
tau7 = 1000;


t = 0:0.001:200;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau = tau1;

D = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
M = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);
M0 = (((KM.*rM).*(1+KM./AM).*exp(-rM.*t))./((1+(KM./AM).*exp(-rM.*t)).^2)).*heaviside(t);
Eff0 = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*t));
Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-tau)));

T = D - Eff.*M + M;
T(T<0) = 0;

T0 = D - Eff0.*M0 + M0;
T0(T0<0) = 0;

Cinac1 = T - T0;
Cinac1(Cinac1<0) = 0;

index = find(Cinac1 == max(Cinac1(Cinac1>0)));
tau_run = t(index);
Cinac1_run = Cinac1(index);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau = tau2;

D = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
M = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);
M0 = (((KM.*rM).*(1+KM./AM).*exp(-rM.*t))./((1+(KM./AM).*exp(-rM.*t)).^2)).*heaviside(t);
Eff0 = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*t));
Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-tau)));

T = D - Eff.*M + M;
T(T<0) = 0;

T0 = D - Eff0.*M0 + M0;
T0(T0<0) = 0;

Cinac2 = T - T0;
Cinac2(Cinac2<0) = 0;

index = find(Cinac2 == max(Cinac2(Cinac2>0)));
tau_run = t(index);
Cinac2_run = Cinac2(index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau = tau3;

D = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
M = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);
M0 = (((KM.*rM).*(1+KM./AM).*exp(-rM.*t))./((1+(KM./AM).*exp(-rM.*t)).^2)).*heaviside(t);
Eff0 = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*t));
Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-tau)));

%R = D - Eff.*M;
%R0 = D - Eff0.*M0;
T = D - Eff.*M + M;
T(T<0) = 0;

T0 = D - Eff0.*M0 + M0;
T0(T0<0) = 0;

Cinac3 = T - T0;
Cinac3(Cinac3<0) = 0;

index = find(Cinac3 == max(Cinac3(Cinac3>0)));
tau_run = t(index);
Cinac3_run = Cinac3(index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau = tau4;

D = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
M = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);
M0 = (((KM.*rM).*(1+KM./AM).*exp(-rM.*t))./((1+(KM./AM).*exp(-rM.*t)).^2)).*heaviside(t);
Eff0 = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*t));
Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-tau)));

%R = D - Eff.*M;
%R0 = D - Eff0.*M0;
T = D - Eff.*M + M;
T(T<0) = 0;

T0 = D - Eff0.*M0 + M0;
T0(T0<0) = 0;

Cinac4 = T - T0;
Cinac4(Cinac4<0) = 0;

index = find(Cinac4 == max(Cinac4(Cinac4>0)));
tau_run = t(index);
Cinac4_run = Cinac4(index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau = tau5;

D = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
M = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);
M0 = (((KM.*rM).*(1+KM./AM).*exp(-rM.*t))./((1+(KM./AM).*exp(-rM.*t)).^2)).*heaviside(t);
Eff0 = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*t));
Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-tau)));

T = D - Eff.*M + M;
T(T<0) = 0;

T0 = D - Eff0.*M0 + M0;
T0(T0<0) = 0;

Cinac5 = T - T0;
Cinac5(Cinac5<0) = 0;

index = find(Cinac5 == max(Cinac5(Cinac5>0)));
tau_run = t(index);
Cinac5_run = Cinac5(index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tau = tau6;

D = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
M = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);
M0 = (((KM.*rM).*(1+KM./AM).*exp(-rM.*t))./((1+(KM./AM).*exp(-rM.*t)).^2)).*heaviside(t);
Eff0 = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*t));
Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-tau)));

T = D - Eff.*M + M;
T(T<0) = 0;

T0 = D - Eff0.*M0 + M0;
T0(T0<0) = 0;

Cinac6 = T - T0;
Cinac6(Cinac6<0) = 0;

index = find(Cinac6 == max(Cinac6(Cinac6>0)));
tau_run = t(index);
Cinac6_run = Cinac6(index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau = tau7;

D = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
M = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-tau)))./((1+(KM./AM).*exp(-rM.*(t-tau))).^2)).*heaviside(t-tau);
M0 = (((KM.*rM).*(1+KM./AM).*exp(-rM.*t))./((1+(KM./AM).*exp(-rM.*t)).^2)).*heaviside(t);
Eff0 = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*t));
Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-tau)));

T = D - Eff.*M + M;
T(T<0) = 0;

T0 = D - Eff0.*M0 + M0;
T0(T0<0) = 0;

Cinac7 = T - T0;
Cinac7(Cinac7<0) = 0;

index7 = find(Cinac7 == max(Cinac7(Cinac7>0)));
tau_run = 21.59;
Cinac_run = 16.6703;

subplot(1,2,1)
hold on;
h1 = plot(t,Cinac1,'k:','linewidth',2.5);
h2 = plot(t,Cinac2,'k--','linewidth',2.5);
h3 = plot(t,Cinac3,'k-.','linewidth',2.5);
h4 = plot(t,Cinac4,'k','linewidth',2.5);
h5 = plot(t,Cinac5,':','Color', [0.5, 0.5, 0.5],'linewidth',2.5);
h6 = plot(t,Cinac6,'--','Color', [0.5, 0.5, 0.5],'linewidth',2.5);
h7 = plot(t,Cinac7,'-','Color', [0.5, 0.5, 0.5],'linewidth',2.5);
plot(40.46,0.85,'m*','linewidth',2.5,'MarkerSize',10); %max. marginal cost
 
axis on;
legend([h1 h2 h3 h4 h5 h6 h7],'$\tau=10$','$\tau=20$','$\tau=30$','$\tau=40$','$\tau=50$','$\tau=60$','$\tau\rightarrow\infty$','Location','northeast');
set(legend,'FontSize',20,'Interpreter','latex');
legend boxoff;
set(gca,'fontsize',18); %axis numbering font size 
title('Plot (a)','Fontsize',20,'Interpreter','latex')
xlabel('time, $t$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Marginal cost of inaction, $\phi$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([0 120 0 1.5]);

tau = [0
3
6
9
12
15
18
21
24
27
30
33
36
39
42
45
48
51
54
57
60
63
66
69
72
75
78
81
84
87
90
93
96
99
102
105
108
111
114
117
120];

Cinac1 =[0
2.5323
5.0364
7.4854
9.8545
12.1225
14.272
16.2898
18.1672
19.8994
21.4854
22.9274
24.2299
25.3998
26.4451
27.3746
28.1978
28.9242
29.5629
30.1231
30.6131
31.0408
31.4133
31.7372
32.0185
32.2625
32.4737
32.6566
32.8146
32.9426
33.0395
33.1128
33.1681
33.2099
33.2414
33.2651
33.2829
33.2964
33.3065
33.3141
33.3198];


tau_run = 21.59;
Cinac_run = 16.67;

subplot(1,2,2)
hold on;
h1 = plot(tau,Cinac1,'k*','linewidth',2.5,'MarkerSize',5);
plot(tau_run,Cinac_run,'r*','linewidth',2.5,'MarkerSize',10);
plot(40.46,25.92,'m*','linewidth',2.5,'MarkerSize',10); %point of inlection
plot(0.4,0.34,'b*','linewidth',2.5,'MarkerSize',10); %point of inlection

nn = 200001;
for i = 1:nn;
y1(i) = 33.34;
end

plot(t,y1,'k:','linewidth',3)

axis on;
set(gca,'fontsize',16); %axis numbering font size 
title('Plot (b)','Fontsize',20,'Interpreter','latex')
xlabel('Management delay, $\tau$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative cost of inaction, $\Phi$','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
xlim([0 120]);
ylim([0 35]);




