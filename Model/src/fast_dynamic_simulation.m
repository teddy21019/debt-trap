function results = fast_dynamic_simulation(VFI_filename, sim_filename, save_file_bool)
    arguments
        VFI_filename string
        sim_filename string
        save_file_bool logical = true 
    end
    
    rng(0)
    load(strcat(VFI_filename, '.mat'))
    

    cpai = cumsum(pai,2);

    %Initial conditions
    [~,i_0] = min(abs(y-1));                              %average endowment of tradables
    j_0 = floor(nd/2);                                    %no external debt 

    %Length of simulation and burning period
    T = 1e6;
    Tburn = 1e5;

    %Initialize the variables 
    YT = zeros(Tburn,1);
    YTtilde = zeros(Tburn,1);
    D = zeros(Tburn,1);

    i = zeros(Tburn+T,1);
    j = zeros(Tburn+T,1);
    B = zeros(Tburn+T,1);
    F = zeros(Tburn+T,1);
    RR = zeros(Tburn+T,1);
    %% Initialize first period
    i(1) = i_0;                         % an initial y
    j(1) = j_0;                         %     
    B(1) = 0;
    
    for t=1:T+Tburn
        
        rr = rand();
        RR(t) = rr;
        F(t) = f(i(t), j(t));

        %% choose to continue 
        if (B(t) == 0) && (F(t) == 0)
            j(t+1) = dpix(i(t),j(t));
            B(t+1) = 0;

        end
        %% choose to default
        if (B(t)==0) && (F(t) == 1)                             %choose to default
            j(t+1) = nd0;                                           %update debt state4
            B(t+1) = 1;
        end
        %% autarky (bad standing and did not get to re-enter)
        if (B(t)==1) && (rr > theta)
            j(t+1) = nd0; 
            B(t+1) = 1;
        end
        %% reentry after having been in bad standing
        if (B(t)==1) && (rr <= theta)
            j(t+1) = dpix(i(t),nd0);
            B(t+1) = 0;
        end

        i(t+1) = find(cpai(i(t),:)>rand, 1);

    end


    % drop last
    i = i(Tburn+1:end-1);
    j = j(Tburn+1:end-1);
    B = B(Tburn+1:end-1);
    F = F(Tburn+1:end);           % only F and RR is not assigned the last one
    RR = RR(Tburn+1:end);

    state_num = length(y);

   %% choose to continue 
    t = (B == 0) & (F == 0);
    I = i(t); J = j(t);
    I_J = sub2ind([state_num state_num], I,J);
        D(t) = d(J);
        YT(t) = y(I);
        YTtilde(t) = y(I);
    %% choose to default
    t = (B==0) & (F == 1);                             
    I = i(t); J = j(t);
    I_J = sub2ind([state_num state_num], I,J);    
        D(t) = d(J);
        YT(t)= y(I);
        YTtilde(t) = yTa(I_J);

    %% autarky (bad standing and did not get to re-enter)
    t = (B ==1) & (RR>theta);
    I = i(t); J = j(t);
    I_J = sub2ind([state_num state_num], I,J); 
        D(t) = 0;
        YTtilde(t) = yTa(I_J);
        YT(t) = y(I); 

    %% reentry after having been in bad standing
    t = (B ==1) & (RR<=theta);
    I = i(t); J = j(t);
    I_J = sub2ind([state_num state_num], I,J); 
        D(t) = 0;
        YTtilde(t) = y(I);
        YT(t) = y(I);
    
    results = struct("I", I, "J", J, "B", B, "F", F, "D", D, "YT", YT, "YTtilde", YTtilde, "RR", RR, "T", T);
    if save_file_bool
        save(strcat(sim_filename, '.mat'), "I", "J", "B", "F", "D", "YT", "YTtilde", "RR", "T")
    end


    
end