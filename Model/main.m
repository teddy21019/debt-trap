clear all
% Main process that integrates  1) gird search for best calibration
%                               2) report and save VFI/ policy function
%                               3) show the equilibrium dynamic 
%
% This process is necessary since some parameters in the model is freely
% set to match certain equilibrium dynamics  outcomes, and the outcom 
% requires both value function iteration and the simulation for dynamic
% 
% Author: Chia-Wei, Chen.
% Functions in subfolders are modified from Hinrichsen (2021) and 
%                                           Na et al.(2018)


%% Sri Lanka Case
%
%
    %% Specify whether need to grid-search for calibration params.
    
    NEED_CALIBRATE_BETA_AND_LOSS = true;

    country_name = 'sri_lanka';
    addpath('src')                                      % Main function are stored here
    
    %% Config the fixed calibration that does not require search
    % load transition probability matrix
    transition_probability_matirx_file = 'tpm_SRI.mat';

    % Calibrated parameters: 
    % I put them in a structure to pass them into a VFI function
    rstar = 0.0012/4;                                   %quarterly risk-free interest rate, using US 3-month treasury bill
    theta = 0.0385;                                     %probability of leaving 'bad standing' is 1-theta. When it is in bad standing, external obligations go to zero. Implies you're in bad standing for ~6.5 years, following Na et al. (2018)
    alfa = 0.9;                                         %hours elasticity of nontraded output (rough estimate based on exports as % of GDP)
    hbar = 1;                                           %full-employment hours (normalised to unity)
    a = 0.35;                                           %share of tradables (as a % of total consumption) (based on actual GDP data, imports/consumptions)
    xi = 0.78;                                          %elasticity of substitution between traded and nontraded goods (estimates vary considerably; 1/sigg (where sigg=2) is Na et al; 0.75 is Devereux and Smith.)
    sigg = 1/xi;                                        %elasticity of substitution: inverse intertemporal (Na et al. 2018)
    %   Note: Calibration for betta, delta_1, and delta_2 is 
    %         conducted through matching three outcomes.
    %
    
    %% Assign search grids
    beta_grid       = 0.8:0.005:0.95;
    delta_1_grid    = -0.2 : -0.05: -0.4;
    delta_2_grid    = 0.3 : 0.05: 0.5;
    search_grid = create_grid_permutation(beta_grid, delta_1_grid, delta_2_grid);
    
    %% Load transition probability matrix
    load(transition_probability_matirx_file, 'ygrid', 'pai' )
    
    if NEED_CALIBRATE_BETA_AND_LOSS
        grid_search_calibration( ...
            ygrid, pai, ...
            rstar, theta, alfa, a, xi, sigg, search_grid ...
            )
        
    else
        load(  ...
            strcat('policy_functions_', country_name, '.mat') ...
        )
    end

