%lqtrend_p2.m
%log-quadratic detrend of real GDP per capita 

clear all

%data from World Bank
tradable_per_capita = table2array(readtable('/Users/abc/Desktop/論文3/DATA/GDP.per.capita.csv'));
tradable_per_capita = tradable_per_capita(2:end, :);
SRI = log(tradable_per_capita(:,2));
PAK = log(tradable_per_capita(:,3));
% 
% y_cyclical_SRI = LQ_detrend(SRI, 'difference');
% y_cyclical_PAK = LQ_detrend(PAK, 'difference');
[ys_SRI, y_cyclical_SRI] = hpfilter(SRI, 100);
[ys_PAK,y_cyclical_PAK] = hpfilter(PAK, 100);
% ys_SRI = SRI - y_cyclical_SRI;
% ys_PAK = PAK - y_cyclical_PAK;

subplot(1,2,1);
plot(tradable_per_capita(:,1), SRI,'color','[0.8500, 0.3250, 0.0980]')
hold on
plot(tradable_per_capita(:,1), PAK,'color','[0.4940, 0.1840, 0.5560]')
plot(tradable_per_capita(:,1), ys_SRI,'--','color','[0.8500, 0.3250, 0.0980]')
plot(tradable_per_capita(:,1), ys_PAK,'--','color','[0.4940, 0.1840, 0.5560]')
set(gca, 'YScale','log')
ylabel('Log of real GDP per capita','interpreter','latex')
xlabel('Year','interpreter','latex')
xlim([1960 2021]);
title('Real GDP per capita and secular trend component','fontweight','normal','interpreter','latex')
legend('Sri Lanka $y_t$', 'Pakistan $y_t$','Location','southeast','interpreter','latex')
hold off

%plot deviation
subplot(1,2,2);
plot(tradable_per_capita(:,1), y_cyclical_SRI*100,'color','[0.8500, 0.3250, 0.0980]')
hold on
plot(tradable_per_capita(:,1), y_cyclical_PAK*100,'color','[0.4940, 0.1840, 0.5560]')
xlim([1960 2020])
ylim([-15 15])
ylabel('Percent deviation from secular trend of $y_t$','interpreter','latex')
xlabel('Year','interpreter','latex')
hline=refline(0);
hline.Color='Black';
title('Cyclical compotent of real GDP per capita','fontweight','normal','interpreter','latex')
legend('Sri Lanka $y_t$', 'Pakistan $y_t$', 'Location','southwest','interpreter','latex')

SRI_autocorr=autocorr(y_cyclical_SRI,'NumLags',1);
PAK_autocorr=autocorr(y_cyclical_PAK,'Numlags',1);

p_SRI=1-(1-SRI_autocorr(2))/4;
p_PAK=1-(1-PAK_autocorr(2))/4;

std_SRI=std(y_cyclical_SRI)/sqrt(4);
std_PAK=std(y_cyclical_PAK)/sqrt(4);

set(gcf,'color','w');

save cyclic.mat y_cyclical_SRI y_cyclical_PAK p_SRI p_PAK std_SRI std_PAK
