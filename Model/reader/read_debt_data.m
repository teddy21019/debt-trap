function debt_table = read_debt_data(data_file_path)

    opts = spreadsheetImportOptions("NumVariables", 9);
     
    opts.Sheet = "Adjusted Debt";
    opts.DataRange = "A2:I12";
    
    % Specify column names and types
    opts.VariableNames = ["year", "lka_x_china", "lka_with_china", "pak_x_china", "pak_with_china", "lka_gdp_trade", "pak_gdp_trade", "lka_gdp", "pak_gdp"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double"];


    debt_table = readtable(data_file_path, opts, "UseExcel", false);   
end

