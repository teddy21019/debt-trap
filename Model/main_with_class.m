addpath('src', 'reader', 'class')

data_file_source = "C:\Users\tedb0\Documents\debt-trap\DATA\ModelData.xlsx";
GDP_data = read_gdp_data(data_file_source);
debt_data = read_debt_data(data_file_source);
gdp_array = table2array(GDP_data(:, 'pc_gdp'));

SRI = log(gdp_array(GDP_data.code == 'LKA',:));

%% Configuration on Output, Calibration and Targets

% create OutputProcess instance for Sri Lanka
year_range = 1960:2021;
output_proxy_sri_gdp_hp = OutputProcess(SRI,year_range, "HP");

% baseline calibration
fixed_calibration = Calibration();
    fixed_calibration.rstar   = 0.01;                            %quarterly risk-free interest rate, using US 3-month treasury bill
    fixed_calibration.theta   = 0.0385;                          %probability of leaving 'bad standing' is 1-theta. When it is in bad standing, external obligations go to zero. Implies you're in bad standing for ~6.5 years, following Na et al. (2018)
    fixed_calibration.alfa    = 0.65;                            %hours elasticity of nontraded output (rough estimate based on exports as % of GDP)
    fixed_calibration.hbar    = 1;                               %full-employment hours (normalised to unity)
    fixed_calibration.a       = 0.4;                             %share of tradables (as a % of total consumption) (based on actual GDP data, tradable/GDP)
    fixed_calibration.xi      = 0.5;                             %elasticity of substitution between traded and nontraded goods (estimates vary considerably; 1/sigg (where sigg=2) is Na et al; 0.75 is Devereux and Smith.)
    fixed_calibration.sigg    = 1/fixed_calibration.xi;          %elasticity of substitution: inverse intertemporal (Na et al. 2018)

% Sri Lanka target using GDP proxy
    sri_gdp_targets = struct();
        sri_gdp_targets.debt_ratio               = 0.75;         % 75% per quarter
        sri_gdp_targets.default_freq             = 2.6;          % 2.6 times per centurty
        sri_gdp_targets.output_loss              = 0.07;         % 7% output loss per year

 %% Model Object        
% Sri Lanka, GDP_HP
model_1 = Model(fixed_calibration, output_proxy_sri_gdp_hp);
model_1.set_targets(sri_gdp_targets);

model_1.run();