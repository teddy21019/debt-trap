function gdp_table = read_gdp_data(data_file_path)
    
    opts = spreadsheetImportOptions("NumVariables", 17);
    opts.Sheet = "GDP";
    opts.DataRange = "A2:Q125";
    
    % Specify column names and types
    opts.VariableNames = ["year", "code", "r_gdp_agr", "r_gdp_ind", "r_gdp_trade", "r_gdp", "gdp_agr", "gdp_ind", "gdp_trade", "gdp", "pop", "pc_trade", "pc_gdp", "tb", "tbgdp", "r_tradegdp", "tradegdp"];
    opts.VariableTypes = ["double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];


    gdp_table = readtable(data_file_path, opts, "UseExcel", false);   
end

