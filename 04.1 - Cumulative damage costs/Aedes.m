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
27
28
29
30
32
36
43
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
57
58
59
60
61
62
91];

n = time(end);

cost = [375865310.2
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

%b1(1) = r
%b1(2) = K
%b1(3) = C0

modelfun1 = @(b1,t) (b1(2)./(1+(b1(2)./b1(3) - 1).*exp(-b1(1).*t)));
beta1 = [1 1 1];
mdl1 = fitnlm(time,cost,modelfun1,beta1)

t = 0:0.1:n;

r = 0.243593284247693;
K = 19183.4809844632;
C0 = 1450.53725635434;
CC = K./(1+(K./C0 - 1).*exp(-r.*t));

tnew = t';
[ynew,ynewci_B] = predict(mdl1,tnew);

hold on
plot(t,ynewci_B(:,1),'r-.','linewidth',1.5)
plot(t,ynewci_B(:,2),'r-.','linewidth',1.5)
jbfill(t,ynewci_B(:,2)',ynewci_B(:,1)','red','none',0,0.1);

hold on;
plot(t,CC,'k',time,cost,'ko','linewidth',2);
axis([0 n 0 cost(end)*1.1]);
title('Aedes','FontSize',18,'color','k','Interpreter','latex')
xlabel('time, $t$','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative damage cost, $C(t)$ (US\$ millions)','Fontsize',25,'fontweight','bold','color','k','Interpreter','latex');
set(gca,'fontsize',20); %axis numbering font size

ci = round(coefCI(mdl1,0.4),2);
