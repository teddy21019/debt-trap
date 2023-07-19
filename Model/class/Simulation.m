classdef Simulation < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        vf      ValueFunction
        T       int64 = 1.1e6
        T_burn  int64 = 0.1e6     
        
        % Essential simulations
        B
        F
        D
        YT
        YTtilde
        RR
    end


    methods
        function obj = Simulation(vf)
           obj.vf = vf;
        end

        function obj = fast_simulation(obj)
            % Conduct a fast simulation for variables specifically for
            % calibration tuning: "I", "J", "B", "F", "D", "YT", "YTtilde", "RR", "T"
            
            pai     = obj.vf.output_process.pai;
            y       = obj.vf.y;
            yTa      = obj.vf.yTa;
            d       = obj.vf.d;
            f       = obj.vf.f;
            [~,nd0] = min(abs(d));
            dpix    = obj.vf.dpix;
            nd      = length(d);
            theta   = obj.vf.calibration.theta;
            yT      = obj.vf.yT;

            cpai = cumsum(pai,2);

            %Initial conditions
            [~,i_0] = min(abs(y-1));                              %average endowment of tradables
            j_0 = floor(nd/2);                                    %no external debt 
        
            %Length of simulation and burning period
            T = obj.T;
            Tburn = obj.T_burn;
        
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
                
                % For each loop, only the state variables (j:debt, B:standing
                % indicator, and i:output) is important. Other endogenous
                % variables can be extracted throught the state.

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
        
            state_num_y = length(y);
            state_num_d = length(d);
        
           %% choose to continue 
            t = (B == 0) & (F == 0);
            I = i(t); J = j(t); 
            I_J = sub2ind([state_num_y state_num_d], I,J);
                D(t) = d(J);
                YT(t) = y(I);
                YTtilde(t) = y(I);
            %% choose to default
            t = (B==0) & (F == 1);                             
            I = i(t); J = j(t);
            I_J = sub2ind([state_num_y state_num_d], I,J);
                D(t) = d(J);
                YT(t)= y(I);
                YTtilde(t) = yTa(I_J);
        
            %% autarky (bad standing and did not get to re-enter)
            t = (B ==1) & (RR>theta);
            I = i(t); J = j(t);
            I_J = sub2ind([state_num_y state_num_d], I,J);
                D(t) = 0;
                YTtilde(t) = yTa(I_J);
                YT(t) = y(I); 
        
            %% reentry after having been in bad standing
            t = (B ==1) & (RR<=theta);
            I = i(t); J = j(t);
            I_J = sub2ind([state_num_y state_num_d], I,J);
                D(t) = 0;
                YTtilde(t) = y(I);
                YT(t) = y(I);
                        
            obj.B = B;
            obj.F = F;
            obj.D = D;
            obj.YT = YT;
            obj.YTtilde = YTtilde;
            obj.RR = RR;
           
        end

        function [debt_ratio, default_freq, output_loss] = extract_default_moments(obj)

            % simplify notations first by creating copies
            F = obj.F;
            B = obj.B;
            T = obj.T;
            YT = obj.YT;
            YTtilde = obj.YTtilde;
            D = obj.D;

            %% get the debt ratio
                default_freq = mean(obj.F) * 400;             % Frequency of default per century (400 quarters)
                
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
        
    end
end