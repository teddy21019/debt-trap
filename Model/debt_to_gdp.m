% Creates mat file for debt to gdp data

opts = spreadsheetImportOptions("NumVariables", 5);

% Specify sheet and range
opts.Sheet = "DTGDP";
opts.DataRange = "A2:E12";

% Specify column names and types
opts.VariableNames = ["Year", "SriLankaExclChina", "SriLanka", "PakistanExclChina", "Pakistan"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Import the data
debt_to_gdp_ratio = readtable("C:\Users\tedb0\Documents\debt-trap\DATA\IDS_SRI+PAK_WORLD+CHINA.xlsx", opts, "UseExcel", false);
debt_to_gdp_ratio = table2array(debt_to_gdp_ratio);

save debt_to_gdp.mat debt_to_gdp_ratio