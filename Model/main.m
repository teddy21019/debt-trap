
% Main process that integrates  1) gird search for best calibration
%                               2) report and save VFI/ policy function
%                               3) show the equilibrium dynamic 
%
% This process is necessary since some parameters in the model is freely
% set to match certain equilibrium dynamics  outcomes, and the outcom 
% requires both value function iteration and the simulation for dynamic
% 
% Author: Chia-Wei, Chen (2023) All right reserved.
% Functions in subfolders are modified from Hinrichsen (2021) and 
%                                           Na et al.(2018)

clear all
addpath('src')                                      % Main function are stored here
addpath('reader')

%% Sri Lanka Case
%
%
    %% Specify whether need to grid-search for calibration params.
    
    country_name = 'sri_lanka';
    %% Config the fixed calibration that does not require search
    % load transition probability matrix

    transition_probability_matirx_file = 'tpm_SRI_hp_gdp.mat';

    % Calibrated parameters: 
    % I put them in a structure to pass them into a VFI function

    fixed_calibration_param = struct();
        fixed_calibration_param.rstar   = 0.01;                                 %quarterly risk-free interest rate, using US 3-month treasury bill
        fixed_calibration_param.theta   = 0.0385;                                   %probability of leaving 'bad standing' is 1-theta. When it is in bad standing, external obligations go to zero. Implies you're in bad standing for ~6.5 years, following Na et al. (2018)
        fixed_calibration_param.alfa    = 0.65;                                      %hours elasticity of nontraded output (rough estimate based on exports as % of GDP)
        fixed_calibration_param.hbar    = 1;                                        %full-employment hours (normalised to unity)
        fixed_calibration_param.a       = 0.4;                                     %share of tradables (as a % of total consumption) (based on actual GDP data, tradable/GDP)
        fixed_calibration_param.xi      = 0.5;                                     %elasticity of substitution between traded and nontraded goods (estimates vary considerably; 1/sigg (where sigg=2) is Na et al; 0.75 is Devereux and Smith.)
        fixed_calibration_param.sigg    = 1/fixed_calibration_param.xi;             %elasticity of substitution: inverse intertemporal (Na et al. 2018)
        fixed_calibration_param.dupper  = 1.5;
        %   Note: Calibration for betta, delta_1, and delta_2 is 
        %         conducted through matching three outcomes.
        %

    %% Assign targets

    targets = struct();
        targets.debt_ratio               = 0.75;             % 75% per quarter
        targets.default_freq             = 2.6;              % 2.6 times per centurty
        targets.output_loss              = 0.07;             % 7% output loss per year
    
    %% Assign search grids
    %
    %  Not used when not searching through grid
    %  Boundary is used instead for other global optimization tools
    
    beta_grid       = 0.6:0.05:0.95;
    delta_1_grid    = -0.2:-0.1:-0.6;
    delta_2_grid    = 0.2:0.01:0.6;
    search_grid = create_grid_permutation(beta_grid, delta_1_grid, delta_2_grid);
    
    %% Load transition probability matrix
    load(transition_probability_matirx_file)
    fixed_calibration_param.ygrid = ygrid;
    fixed_calibration_param.pai = pai;
    fixed_calibration_param.y_cyclical = y_cyclical;

    
    %% Set distance function and the search method. 
    % This is using the bridge pattern in design pattern

    distance_func = @(x) calibration_target_distance(x, fixed_calibration_param, targets);
    search_method = @(bound)fmin_calibration(bound, distance_func);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Note: This might look complicated, but this allows me to try out
    % different version of calculation the distance, and different version
    % of searching for the optimal calibration point
    %
    %
    
    %% Main Part
    % In case I want to run with just previous results
    answer = questdlg('Recalibrate parameters?', ...
	    'Double checking calibration', ...
	    'Yes', 'No', 'No');
    NEED_CALIBRATE_BETA_AND_LOSS = false;       % init default false
    
    switch answer
        case 'Yes'
            NEED_CALIBRATE_BETA_AND_LOSS = true;
        case 'No'
            NEED_CALIBRATE_BETA_AND_LOSS = false;
    end

    if NEED_CALIBRATE_BETA_AND_LOSS
        [optimal_calibration_grid, min_distance, exitflag, output, trials] = search_method(...
            search_grid);
        save optimal_grid.mat optimal_calibration_grid min_distance exitflag output trials;
        
    else
        load optimal_grid.mat optimal_calibration_grid
    end
    
    % Add the vector (beta, delta_1, delta_2) into the 
    calibration_param = add_tuning_params(...
        fixed_calibration_param, optimal_calibration_grid);

    VFI(calibration_param, 'VFI_SRI_result')
    simu_sri_lanka
    plot_sri_lanka
    plot_default_set_sri_lanka


