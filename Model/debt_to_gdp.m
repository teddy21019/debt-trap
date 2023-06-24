% Creates mat file for debt to gdp data

opts = spreadsheetImportOptions("NumVariables", 5);

% Specify sheet and range
opts.Sheet = "Debt Stock";
opts.DataRange = "A2:E12";

% Specify column names and types
opts.VariableNames = ["Year", "SriLankaExclChina", "SriLanka", "PakistanExclChina", "Pakistan"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Import the data
debt_stock = readtable("C:\Users\tedb0\Documents\debt-trap\DATA\IDS_SRI+PAK_WORLD+CHINA.xlsx", opts, "UseExcel", false);
debt_stock = table2array(debt_stock);

save debt_stock.mat debt_stock