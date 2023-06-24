% fmin_calibration.m
%
% Syntax candy to help me find the optimal calibration combination given 
% the boundary and distance function.
%
% Used in `main_*.m` files, in combination of `calibration_target_distance*.m`
%
% distance_func:
% The objective function that takes in an array of parameters and outputs a 
% real number.
%
% bound: n by k matrix of possible grids. n is the possible combination of
% grid, k is the number of arguments that distance_func takes. When not
% using grid search, the min and max of this bound matrix is extracted and
% used as the lower and upper bound of the search process.
%
% Chia-Wei, Chen (2023) All right reserved. 



function [optimal_calibration_grid, min_distance,exitflag, output, trials] = fmin_calibration(...
    bound, distance_func)
    
    min_search = min(bound);
    max_search = max(bound);
    %init_search = mean(bound);
    
    options = optimoptions('surrogateopt','PlotFcn','surrogateoptplot',...
                            'MaxFunctionEvaluations',150,'CheckpointFile','opt_checkfile.mat');

    
    [optimal_calibration_grid, min_distance, exitflag, output,trials] = surrogateopt(distance_func,min_search, max_search, options);



    
end