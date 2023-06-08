function [optimal_calibration_grid, min_distance,exitflag, output, trials] = fmin_calibration(...
    fixed_calibration_param, search_grid, targets, distance_func)
    
    min_search = min(search_grid);
    max_search = max(search_grid);
    %init_search = mean(search_grid);
    
    options = optimoptions('surrogateopt','PlotFcn','surrogateoptplot',...
                            'MaxFunctionEvaluations',120,'CheckpointFile','opt_checkfile.mat');

    
    [optimal_calibration_grid, min_distance, exitflag,output,trials] = surrogateopt(distance_func,min_search, max_search, options);



    
end