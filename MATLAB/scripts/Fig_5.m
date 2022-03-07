timeM = [55
59
62
63
64
65
66
67
68
69
70
71
72
73
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
92
93
94
96]-48;

nM = timeM(end);

costM = [22466850.38
132412287.8
544348.1775
544348.1775
544348.1775
35060637.14
544348.1775
544348.1775
544348.1775
544348.1775
544348.1775
544348.1775
8601832.798
167011413.9
3649569.658
3649569.658
99242294.17
151967183.8
222624012.9
189844450.7
190695931.6
205517386.6
117243729.3
110672429
93860859.39
76618236.82
148110167.9
146604955.9
84113051.28
95000
49692331
62321135.78
1427090.393]*10^-6;

%b1(1) = rM
%b1(2) = KM
%b1(3) = AM
options = optimset('Algorithm','trust-region-reflective','MaxFunEvals',1e6,'MaxIter',1e8)
modelfun1 = @(b1,t) ((((b1(2).*b1(1)).*(1 + b1(2)./b1(3)).*exp(-b1(1).*(t-timeM(1))))./((1+(b1(2)./b1(3)).*exp(-b1(1).*(t-timeM(1)))).^2)).*heaviside(t-timeM(1)));
beta1 = [1 10000 1];
lb = [0,0,0];
ub = [10,100000,10];
mdl1 = lsqcurvefit(modelfun1,beta1,timeM,costM,lb,ub,options);

rM = mdl1(1)
KM = mdl1(2)
AM = mdl1(3)

M0 = 0.5.*rM.*KM./(1 + KM./AM)

time = [48
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
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95]-48;

n = time(end);

cost = [115853.9678
147709.7136
188324.6635
240107.2889
306128.3059
390302.7688
497622.2335
634450.7574
808902.2886
1031321.824
1314898.87
1676449.579
2137413.953
2725127.235
3474440.895
4429789.324
5647824.801
7200776.978
9180736.108
11705114.01
14923606.6
19027070.89
24258842.8
30929167.05
39433594.68
50276439.29
14422390.91
21187518.2
15398028.89
15566401.2
2230033879
3358135301
3548502587
3640363911
3640066048
3671123014
4595874663
4606322131
2419348371
2390471685
3385523407
2361060761
2319347933
514506343.6
101554217.1
134938021
271930304.1
235542971.8]*10^-6;

%b2(1) = r
%b2(2) = K
%b2(3) = A;
%b2(4) = E0
%b2(5) = E1
%b2(6) = alpha

modelfun2 = @(b2,t) (  (((b2(2).*b2(1)).*(1 + b2(2)./b2(3)).*exp(-b2(1).*t))./((1+(b2(2)./b2(3)).*exp(-b2(1).*t)).^2)) - (1 + ((b2(4)-1)*(b2(5)-1))./((b2(4) - 1) + (b2(5) - b2(4)).*exp(-b2(6).*(t-timeM(1))))).*(((KM.*rM).*(1 + KM./AM).*exp(-rM.*(t-timeM(1))))./((1+(KM./AM).*exp(-rM.*(t-timeM(1)))).^2)).*heaviside(t-timeM(1)));
beta2 = [0.3 100000 1 1 2 0.3];
lb= [0,0,0,1,1,-10];
ub= [10, 100000,10,100,100,10];
mdl2 = lsqcurvefit(modelfun2,beta2,time,cost,lb,ub,options);


t = 0:0.1:120;

r = mdl2(1);
K = mdl2(2);
A = mdl2(3);
D0 = r.*K./(1 + K./A)

E0 = mdl2(4)
E1 = mdl2(5)
alp = mdl2(6)

hold on;
CC = (((K.*r).*(1 + K./A).*exp(-r.*(t)))./((1+(K./A).*exp(-r.*(t))).^2)) - (1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-timeM(1))))).*(((KM.*rM).*(1 + KM./AM).*exp(-rM.*(t-timeM(1))))./((1+(KM./AM).*exp(-rM.*(t-timeM(1)))).^2)).*heaviside(t-timeM(1));



tnew = t;
hold on
Damage_cost = ((K.*r).*(1+K./A).*exp(-r.*t))./((1+(K./A).*exp(-r.*t)).^2);
Management_cost = (((KM.*rM).*(1+KM./AM).*exp(-rM.*(t-timeM(1))))./((1+(KM./AM).*exp(-rM.*(t-timeM(1)))).^2)).*heaviside(t-timeM(1));

Eff = 1 + ((E0-1)*(E1-1))./((E0 - 1) + (E1 - E0).*exp(-alp.*(t-timeM(1))));

Realized_damage = Damage_cost - Eff.*Management_cost;
Total_cost = Realized_damage + Management_cost;


%%%R2 and RMSE for management costs
yM = costM;
yfitM = Management_cost(10.*timeM + 1);

SStotM = sum((yM-mean(yM)).^2);                            % Total Sum-Of-Squares
SSresM = sum((yM(:)-yfitM(:)).^2);                         % Residual Sum-Of-Squares
Rsq_M = 1-SSresM/SStotM                                    % R^2
RMSE_M = sqrt(SSresM./numel(costM))

%%%R2 and RMSE for realized damage costs
yD = cost;
yfitD = Realized_damage(10.*time + 1);

SStotD = sum((yD-mean(yD)).^2);                            % Total Sum-Of-Squares
SSresD = sum((yD(:)-yfitD(:)).^2);                         % Residual Sum-Of-Squares
Rsq_D = 1-SSresD/SStotD                                    % R^2
RMSE_D = sqrt(SSresD./numel(cost))

hold on;
tt = t + 48;
h1 = plot(tt,Management_cost./10^3,'b','linewidth',2.5);  
h2 = plot(tt,Realized_damage./10^3,'k-.','linewidth',2.5);  
h3 = plot(tt,Total_cost./10^3,'r-.','linewidth',2.5);  
h4 = plot(tt,Damage_cost./10^3,'k','linewidth',2.5);
plot(timeM+48,costM./10^3,'bo','linewidth',2);
plot(time+48,cost./10^3,'ko','linewidth',2);


axis on;
legend([h4 h3 h2 h1],'Damage cost, $D$','Total cost, $T$','Realized damage cost, $D^*$','Management cost, $M$','Location','northeast');
set(legend,'FontSize',18,'Interpreter','latex');
legend boxoff;
set(gca,'fontsize',16); %axis numbering font size 
xlabel('time, $t$ (years)','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Marginal cost, (\$US billions)','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([48 120 0 10]);


