function optimal_calibration_grid = grid_search_calibration(...
    fixed_calibration_param, search_grid, targets)
    
    search_grid_row_n = size(search_grid,1);        % ex: total 60 purmutations
    search_grid_col_n = size(search_grid,2);        % ex: 3 parameters to searcg
    target_col_n = length(fieldnames(targets));     % ex: need to target 3 outcomes
    grid_result = [search_grid zeros(search_grid_row_n, target_col_n + 1)];     %  --  = grid + result + distance
    f = waitbar(0, 'Checking grid...');

    for row_num = 1:size(search_grid, 1)
        grid_text = strjoin(string(search_grid(row_num, :)), ', ');

        waitbar(row_num/size(search_grid, 1), f, grid_text)
        
        calibration_param = fixed_calibration_param;
        calibration_param.betta = search_grid(row_num,1);
        calibration_param.delta_1 = search_grid(row_num, 2);
        calibration_param.delta_2 = search_grid(row_num, 3);
        
        % Conduct value function iteration based on the grid
        waitbar(row_num/size(search_grid, 1), f, strcat("VFI on ",grid_text))
        
        tic
        VFI(calibration_param,...
            'temp_VFI_result', '');

        waitbar(row_num/size(search_grid, 1), f, strcat("Simulation on ",grid_text))

        dynamic_simulation('temp_VFI_result', 'temp_simulation_result',false, true);
        [debt_ratio, default_freq, output_loss] = ...
            extract_default_dynamic('temp_simulation_result');
        toc

        grid_result(row_num, search_grid_col_n + 1:search_grid_col_n+target_col_n) = ...
            [debt_ratio default_freq output_loss];
        grid_result(row_num, end) = norm( ...
            [targets.debt_ratio targets.default_freq targets.output_loss] - ...
            [debt_ratio default_freq output_loss]); 

    end
    
    save grid_loss.mat grid_result

    [~, minIndex] = min(grid_result(:, end));

    % Get the corresponding grid combination
    optimal_calibration_grid = grid_result(minIndex, 1:search_grid_col_n);

    
end