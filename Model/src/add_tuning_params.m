function augmented_calibration_params = add_tuning_params(...
    fixed_calibration_param, tuning_params)
    
    augmented_calibration_params = fixed_calibration_param;
    if (length(tuning_params) == 3)
        augmented_calibration_params.betta = tuning_params(1);
        augmented_calibration_params.delta_1 = tuning_params(2);
        augmented_calibration_params.delta_2 = tuning_params(3);
    elseif (length(tuning_params) == 2)
        augmented_calibration_params.betta = tuning_params(1);
        augmented_calibration_params.delta_1 = tuning_params(2);
        augmented_calibration_params.delta_2 = (1-calibration_param.delta_1)/(2*exp(max(calibration_param.ygrid)));        % The specification in Na et al.
    end
end