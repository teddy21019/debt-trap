function [debt_ratio, default_freq, output_loss]  ...
    = extract_default_dynamic(simulation_result)
    
    if isstring(simulation_result)
        simulation_result = strcat(simulation_result, '.mat');
        load(simulation_result)
    else
        F = simulation_result.F;
        T = simulation_result.T;
        YT = simulation_result.YT;
        YTtilde = simulation_result.YTtilde;
        D = simulation_result.D;
    end
    
    tb = 1;                                             %periods before default
    ta = 3; 

    x = find(F == 1);
    x = x(x > tb & x <= T - ta);
    
    %% get the debt ratio
    default_freq = size(x,1) / T * 400;             % Frequency of default per century (400 quarters)
    
    %% get output loss
    xlong = length(x);
    ylong = ta + 1;                                 % 4 periods, including default period
    yloss = zeros(xlong, ylong);                 

    for i=1:length(x)
        yloss(i,1:ylong) = YT(x(i):x(i)+ ta)' - YTtilde(x(i):x(i)+ta)';
    end

    % get the average of [average of output loss for 4 episodes]
    output_loss = mean(yloss, "all");


    %% Mean of t-1 for debt over all episode
    debt_ratio = mean(D(x-1));                      % D is 1e7 x 1, extract the period before default

end