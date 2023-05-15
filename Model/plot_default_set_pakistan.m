%plot_default_set

clear all
% load default_1870s.mat
% load default_1920s.mat
load default_pakistan.mat

%subplot(1,3,1)

contourf(yT,dpc*100,f,'LineColor','None','ShowText','On') 

load cyclic.mat y_cyclical_PAK
load debt_to_gdp.mat debt_to_gdp_ratio

%%% Year from 2007 to 2017
% Sri Lanka started to receive loans from China since 2007
% The new election started in 2015, and the new government declared
% insolvency in 2016, 2017
years = debt_to_gdp_ratio(:,1);
y_cyclical_PAK = 1+y_cyclical_PAK(years - 1980 + 1, :);
debt_PAK_no_china = debt_to_gdp_ratio(:,4) * 100;
debt_PAK = debt_to_gdp_ratio(:,5) * 100;

for year_index = 1:numel(years)
    hold on
    plot(y_cyclical_PAK(year_index), debt_PAK(year_index), 'ko','MarkerFaceColor','r')
    text(y_cyclical_PAK(year_index), ceil(debt_PAK(year_index))+3, string(years(year_index)))
end
xlabel('$y_{t}^{T}$','interpreter','latex')
ylabel('Debt stock $d_{t}$','interpreter','latex')
title('Default set for Pakistan','interpreter','latex')
ylim([30 120])
xlim([0.85 1.4])

set(gcf,'color','w');
shg