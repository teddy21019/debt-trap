% plot_finland44.m
% Computes times series paths for Finland reparations after World War II
% and produces Figure 4.5 (1944-46) 
%   
% by Simon Hinrichsen (2020), a (sligthly) edited version of the code from Na et al. (2018)

format compact
clf
orient tall
rows = 3;
cols = 2; 

tb = 8;                                             %periods before default
ta = 8;                                             %periods after default

load simu_SRI.mat YT YTA YTtilde B D CT P W Q F TAU DEV PM INFL PC T Tburn ygrid pai rstar betta theta yhat alfa hbar a sigg xi dupper dlower nd 


C = (a*CT.^(1-1/xi) + (1-a)*1^(1-1/xi)).^(1/(1-1/xi));

ER = W.^(-1) * 1.109;                                       %nominal exchange rate. Recall that under the particular optimal devaluation policy considered here, namely, dev_t = w_{t-1}/wf_t, the nominal wage is constant, so the nominal exchange rate is proportional to the inverse of the real wage rate.

x1 = find(F==1);
x1 = x1(x1>tb);
x=x1;

find(x>=tb+1);
x = x(ans);
find(x<=T-ta);
x = x(ans);

%pre-allocate arrays
xlong = length(x);
ylong = tb+ta+1;
yT = zeros(xlong,ylong); 
yTaut = zeros(xlong,ylong); 
yTtilde = zeros(xlong,ylong); 
b = zeros(xlong,ylong); 
d = zeros(xlong,ylong); 
cT = zeros(xlong,ylong); 
c = zeros(xlong,ylong); 
p = zeros(xlong,ylong); 
w = zeros(xlong,ylong); 
q = zeros(xlong,ylong); 
f = zeros(xlong,ylong); 
tau = zeros(xlong,ylong); 
dev = zeros(xlong,ylong); 
er = zeros(xlong,ylong); 
pm = zeros(xlong,ylong); 
infl = zeros(xlong,ylong); 
pc = zeros(xlong,ylong); 

for i=1:length(x)
    yT(i,1:tb+ta+1) =  YT(x(i)-tb:x(i)+ta)';
    yTaut(i,1:tb+ta+1) =  YTA(x(i)-tb:x(i)+ta)';
    yTtilde(i,1:tb+ta+1) =  YTtilde(x(i)-tb:x(i)+ta)';
    b(i,1:tb+ta+1) =  B(x(i)-tb:x(i)+ta)';
    d(i,1:tb+ta+1) =  D(x(i)-tb:x(i)+ta)';
    cT(i,1:tb+ta+1) =  CT(x(i)-tb:x(i)+ta)';
    c(i,1:tb+ta+1) =  C(x(i)-tb:x(i)+ta)';
    p(i,1:tb+ta+1) =  P(x(i)-tb:x(i)+ta)';
    w(i,1:tb+ta+1) =  W(x(i)-tb:x(i)+ta)';
    q(i,1:tb+ta+1) =  Q(x(i)-tb:x(i)+ta)';
    f(i,1:tb+ta+1) =  F(x(i)-tb:x(i)+ta)';
    tau(i,1:tb+ta+1) =  TAU(x(i)-tb:x(i)+ta)';
    dev(i,1:tb+ta+1) =  DEV(x(i)-tb:x(i)+ta)';
    er(i,1:tb+ta+1) =  ER(x(i)-tb:x(i)+ta)';
    er(i,:) = er(i,:)/er(i,1);
    pm(i,1:tb+ta+1) =  PM(x(i)-tb:x(i)+ta)';
    infl(i,1:tb+ta+1) =  INFL(x(i)-tb:x(i)+ta)';
    pc(i,1:tb+ta+1) =  PC(x(i)-tb:x(i)+ta)';
end

t = (-tb:ta);

mean_dev =  (W(1)/W(end))^(1/(length(W)-1));
mean_dev = (mean_dev^4-1)*100;

f = @(x) median(x);
% f = @(x) mean(x);


nameOfEpisode='Sri Lanka';                                                      
i=1;                                                                                
lineType='-';                                                                           
tslineWidth=2;                                                                         

figure
%start subplots
subplot(rows,cols,i)                                                                    
x=f(yT);
plot(t,x,lineType,'linewidth',tslineWidth,'color',[0.4940 0.1840 0.5560])       
hold on 
x=f(yTtilde);
plot(t,x,'--','linewidth',tslineWidth,'color',[0.4940 0.1840 0.5560])       
hold on 
% plot(t,FinlandY,':','linewidth',tslineWidth,'Color',[0.4940 0.1840 0.5560]);    
% hold on
% plot(t,netFinlandY,'--','linewidth',tslineWidth,'Color',[0.4940 0.1840 0.5560]);    
set(gca,'xtick', -tb:4:ta)                                                           
h=title('Loss of tradable output');                         
set(h, 'Interpreter', 'Latex')                                                         
h=legend('Model estimate of ${y^T_t}$','Location','nw');
set(h, 'Interpreter', 'Latex')                                                      
xlim([-tb ta])                                                                       
xlabel('Quarters before a hypothetical default at {t_0}','FontSize',9);
ylim([0.70 1.1])
ylabel('Output normalised to 1','FontSize',9);
hold off

%next plot
i=i+1; 
subplot(rows,cols,i)
x=pm;
plot(t,f(x),lineType,'linewidth',tslineWidth,'color',[0.4940 0.1840 0.5560])
hold on
% plot(t,FinlandSpread,':','linewidth',tslineWidth,'Color',[0.4940 0.1840 0.5560]);    
% hold on  
h=title('Credit spread on Finnish external debt');
set(h, 'Interpreter', 'Latex')
h=legend('Model estimate of credit spread','Location','nw');
set(h, 'Interpreter', 'Latex')  
ylabel('Percentage point spread','FontSize',9)
ylim([0 16])
xlim([-tb tb])
xlabel('Quarters before a hypothetical default at {t_0}','FontSize',9);
set(gca,'xtick', -tb:4:ta)

%next plot
i=i+1; 
subplot(rows,cols,i)
x=d*100;plot(t,f(x),lineType,'linewidth',tslineWidth,'color',[0.4940 0.1840 0.5560])
hold on

% plot(t,FinlandD,':','linewidth',tslineWidth,'Color',[0.4940 0.1840 0.5560]);    
% hold on  
h=title('Debt level');
set(h, 'Interpreter', 'Latex')
h=legend('Model estimate of ${d_t}$','Location','nw');
set(h, 'Interpreter', 'Latex')  
ylabel('Percent of GDP','FontSize',9)
ylim([0 90])
xlim([-tb tb])
xlabel('Quarters before a hypothetical default at {t_0}','FontSize',9);
set(gca,'xtick', -tb:4:ta)

%next plot
i=i+1;
subplot(rows,cols,i)
x=w;plot(t,f(x),lineType,'linewidth',tslineWidth,'color',[0.4940 0.1840 0.5560])
hold on
% plot(t,FinlandW,':','linewidth',tslineWidth,'Color',[0.4940 0.1840 0.5560]);    
% hold on  
h=title('Real wage');
set(h, 'Interpreter', 'Latex')
h=legend('Model estimate of ${w_t}$','Location','sw');
set(h, 'Interpreter', 'Latex')  
ylabel('Real wage','FontSize',9)
%ylim([0.95 1.5])
xlim([-tb tb])
xlabel('Quarters before a hypothetical default at {t_0}','FontSize',9);
set(gca,'xtick', -tb:4:ta)
set(gcf,'color','w','Name',nameOfEpisode);

%next plot
i=i+1; 
subplot(rows,cols,i)
x=er;plot(t,f(x),lineType,'linewidth',tslineWidth,'color',[0.4940 0.1840 0.5560])
hold on
% plot(t,FinlandNEER,':','linewidth',tslineWidth,'Color',[0.4940 0.1840 0.5560]);    
% hold on  
h=title('Nominal exchange rate');
set(h, 'Interpreter', 'Latex')
h=legend('Model estimate of ${\epsilon_t}$','Location','se');
set(h, 'Interpreter', 'Latex')  
ylabel('Nominal exchange rate normalised to 1','FontSize',9)
ylim([0.90 1.5])
xlim([-tb tb])
xlabel('Quarters before a hypothetical default at {t_0}','FontSize',9);
set(gca,'xtick', -tb:4:ta)
set(gcf,'color','w','Name',nameOfEpisode);

%next plot
i=i+1; 
subplot(rows,cols,i)
x=p;plot(t,f(x),lineType,'linewidth',tslineWidth,'color',[0.4940 0.1840 0.5560])
hold on
% plot(t,FinlandREER,':','linewidth',tslineWidth,'Color',[0.4940 0.1840 0.5560]);    
hold on  
h=title('Relative price of nontradables');
set(h, 'Interpreter', 'Latex')
h=legend('Model estimate of ${p_t}$','Location','sw');
set(h, 'Interpreter', 'Latex')  
ylabel('Real exchange rate','FontSize',9)
%ylim([0.95 1.5])
xlim([-tb tb])
xlabel('Quarters before a hypothetical default at {t_0}','FontSize',9);
set(gca,'xtick', -tb:4:ta)
set(gcf,'color','w','Name',nameOfEpisode);
hold off

shg