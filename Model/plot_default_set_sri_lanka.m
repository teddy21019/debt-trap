%plot_default_set

% load default_1870s.mat
% load default_1920s.mat
% load default_sri_lanka.mat
load VFI_SRI_result.mat
%subplot(1,3,1)

figure
d_grid = repmat(d', [200 1]) * 100;
map=[0.9 0.9 0.9
    1 1 1
    ];
colormap(map)
contourf(yT,d_grid,f,'LineColor','None','ShowText','On') 

debt_data = read_debt_data("C:\Users\tedb0\Documents\debt-trap\DATA\ModelData.xlsx");

%%% Year from 2007 to 2017
% Sri Lanka started to receive loans from China since 2007
% The new election started in 2015, and the new government declared
% insolvency in 2016, 2017
year_mask = debt_data.year>=2007 & debt_data.year <=2017;
years = table2array(debt_data(year_mask,'year'));

y_cyclical = 1+y_cyclical(2007 - 1960 + 1: 2017 - 1960 + 1);         % y_cyclical start from 1960

debt_SRI_no_china = table2array(debt_data(year_mask, 'lka_x_china')) ...
                ./ table2array(debt_data(year_mask, 'lka_gdp')) * 100 * 0.37 * 4;
debt_SRI= table2array(debt_data(year_mask, 'lka_with_china')) ...
                ./ table2array(debt_data(year_mask, 'lka_gdp')) * 100 * 0.37 * 4;

for year_index = 1:numel(years)
    hold on
    plot(y_cyclical(year_index), debt_SRI(year_index), 'ko','MarkerFaceColor','k')
    text(y_cyclical(year_index), ceil(debt_SRI(year_index))+3, string(years(year_index)))

    plot(y_cyclical(year_index), debt_SRI_no_china(year_index), 'ko','MarkerFaceColor','r')
    text(y_cyclical(year_index), ceil(debt_SRI_no_china(year_index))+3, string(years(year_index)))
end
xlabel('$y_{t}^{T}$','interpreter','latex')
ylabel('Debt stock $d_{t}$','interpreter','latex')
title('Default set for Sri Lanka','interpreter','latex')
ylim([30 120])
xlim([0.85 1.4])

set(gcf,'color','w');
shg