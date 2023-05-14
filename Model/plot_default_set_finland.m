%plot_default_set

clear
% load default_1870s.mat
% load default_1920s.mat
 load default_sri_lanka.mat

%subplot(1,3,1)

contourf(yT,dpc*100,f,'LineColor','None','ShowText','On') 

hold on  
plot(0.9055,61,'ko','MarkerFaceColor','r') %debt, not including reparation
text(0.907,62,'1945')
hold on  
plot(0.9456,52,'ko','MarkerFaceColor','r') %debt, not including reparation
text(0.9456,54,'1946','Color','White')
hold on  
plot(0.9291,48,'ko','MarkerFaceColor','r') %debt, not including reparation
text(0.91,50,'1947')
hold on  
plot(0.9661,36,'ko','MarkerFaceColor','r') %debt, not including reparation
text(0.9661,38,'1948','Color','White')
hold on  
plot(0.9055,81,'ko','MarkerFaceColor','k') %debt, including reparation
text(0.9055,83,'1945')
plot(0.9456,69.9,'ko','MarkerFaceColor','k') %debt, including reparation
text(0.9456,72,'1946')
plot(0.9291,63.9,'ko','MarkerFaceColor','k') %debt, including reparation
text(0.914,66,'1947')
plot(0.9661,49.9,'ko','MarkerFaceColor','k') %debt, including reparation
text(0.9661,52,'1948','Color','White')
xlabel('$y_{t}^{T}$','interpreter','latex')
ylabel('Debt stock $d_{t}$','interpreter','latex')
title('Default set for Finland','interpreter','latex')
ylim([30 120])
xlim([0.8 1.2])

set(gcf,'color','w');
shg