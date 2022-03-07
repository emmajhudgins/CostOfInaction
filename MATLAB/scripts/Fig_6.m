tau = [0
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
31
32
33
34
35
36
37
38
39
40];

Cinac1 =[0
0.0006
0.0017
0.0035
0.0692
0.6024
2.077
4.5676
7.4153
10.0801
12.5317
14.7721
16.8067
18.644
20.2948
21.7712
23.0863
24.2533
25.2857
26.1963
26.9975
27.7008
28.3169
28.8558
29.3264
29.7367
30.094
30.4048
30.6749
30.9094
31.1127
31.2887
31.441
31.5725
31.686
31.7836
31.8673
31.939
32.0002
32.0521
32.0961];

hold on;
plot(tau+48,Cinac1,'k*','linewidth',2.5,'MarkerSize',5);  

a = 4.63+48;
b = 11.67+48;
c = 7+48;
d = 29.3220 + 48;

plot(a,0.3203,'b*','linewidth',10);  %1% of no-action cost
plot(b,16.1575,'r*','linewidth',10);  %50% of no-action cost
plot(c,4.5676,'g*','linewidth',10);  %observed scenario
plot(d,30.978,'m*','linewidth',10);  %point of inflection

nn = 200001;
dt = 0.001;
for i = 1:nn;
    t(i) = (i-1).*dt;
y1(i) = 32.31;
end
plot(t,y1,'k:','linewidth',3)

axis on;
set(gca,'fontsize',16); %axis numbering font size 
xlabel('Management delay, $\tau$ (years)','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
ylabel('Cumulative cost of inaction, $\Phi$ (\$US billions)','Fontsize',20,'fontweight','bold','color','k','Interpreter','latex');
axis([48 90 0 35]);


