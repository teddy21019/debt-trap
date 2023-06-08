function distance = calibration_target_distance(param_vec,fixed_calibration_param ,targets, fast_dynamic)
    switch nargin
        case 4
            fast_dynamic_bool = fast_dynamic;
        case 3
            fast_dynamic_bool = false;

    end
 

    calibration_param = fixed_calibration_param;
        calibration_param.betta = param_vec(1);
        calibration_param.delta_1 = param_vec(2);
        calibration_param.delta_2 = param_vec(3);
        
    VFI(calibration_param,...
        'temp_VFI_result', '');

    sym_results = fast_dynamic_simulation('temp_VFI_result', 'temp_simulation_result',fast_dynamic_bool);
    [debt_ratio, default_freq, output_loss] = ...
        extract_default_dynamic(sym_results);
    
    distance = norm( ...
        [targets.debt_ratio*10 targets.default_freq targets.output_loss*100] - ...
        [debt_ratio*10 default_freq output_loss*100]); 
end