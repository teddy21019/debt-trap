function grid_search_calibration(ygrid, pai, rstar, theta, alfa, a, xi, sigg, search_grid)
 
    for row_num = 1:size(search_grid, 1)
        
        betta = search_grid(row_num,1);
        delta_1 = search_grid(row_num, 2);
        delta_2 = search_grid(row_num, 3);
        
        % Conduct value function iteration based on the grid
        VFI(ygrid, pai, rstar, theta, alfa, a, xi, sigg, betta, delta_1, delta_2,...
            'temp_VFI_result', 'temp_VFI_result')
        dynamic_simulation('temp_VFI_result', 'temp_simulation_result', false)
        
         
        
    end
    
    
end