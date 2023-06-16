function [debt_ratio, default_freq, output_loss]  ...
    = extract_default_dynamic(simulation_result)
    
    if isstring(simulation_result)
        simulation_result = strcat(simulation_result, '.mat');
        load(simulation_result)
    else
        F = simulation_result.F;
        B = simulation_result.B;
        T = simulation_result.T;
        YT = simulation_result.YT;
        YTtilde = simulation_result.YTtilde;
        D = simulation_result.D;
    end
    
    %% get the debt ratio
    default_freq = mean(F) * 400;             % Frequency of default per century (400 quarters)
    
    %% get output loss
    % Implementation refers to https://www.joseeliasgallegos.com/uploads/7/5/1/4/75144577/ps2_solution.pdf
    % P21, line 16, and is checked on Na et al.(2018), Martin Uribe and
    % Stephanie Schmitt-Grohe (2014)
    
    bs = find(F==1|B==1);                               % default period & bad standings. By desing, a default is followed by a sereis of bas standings.
    output_loss = mean((YT(bs)-YTtilde(bs))./YT(bs));   % average output loss of tradable output of being in bas standings as share of total tradable output.


    %% Mean of t-1 for debt over all episode

    gs = find(F==0&B==0);                               % good standings = no default decision + not in bad
    debt_ratio = mean(D(gs)./YTtilde(gs));              % average debt to tradable GDP ratio, condition on being in good standings

end