% calibration_target_distance.m
%
% This function doeas the following four things:
% 1. Evaluate the value fucntion using value function iteration `VFI.m`
% 2. A simulation of 1e6 times of the model, using an optimized speed-up
%    version in `fast_dynamic_simulation.m`
% 3. Extract the dynamics and moments of the simulation, get default 
%    frequecy, average debt-to-yT ratio, and average output-loss-to-yT 
%    ratio in badstandings.
% 4. Calculate the distance between the extracted moments and the target
%    moment. Moments are weighted so that they range in 0 to 10, for a
%    better comparison and precision.
%
% Chia-Wei, Chen (2023) All right reserved. 


function distance = calibration_target_distance(param_vec,fixed_calibration_param ,targets, fast_dynamic)
    switch nargin
        case 4
            fast_dynamic_bool = fast_dynamic;
        case 3
            fast_dynamic_bool = false;

    end
 

    calibration_param = add_tuning_params(fixed_calibration_param, param_vec);
        
    VFI(calibration_param,...
        'temp_VFI_result');

    sym_results = fast_dynamic_simulation('temp_VFI_result', 'temp_simulation_result',fast_dynamic_bool);
    [debt_ratio, default_freq, output_loss] = ...
        extract_default_dynamic(sym_results);
    
    distance = norm( ...
        [targets.debt_ratio*10 targets.default_freq targets.output_loss*100] - ...
        [debt_ratio*10 default_freq output_loss*100]); 
end