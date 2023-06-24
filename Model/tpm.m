%Discretizes the Scalar VAR(1) Process
%
%y_t = rho * y_t-1 + sigma_epsilon * epsilon_t, where epsilon_t follows a normal (0,1) distribution. 
%
%Output:
%ygrid is the grid  of y_t values
%pai  transition probability matrix, 
%sigma_epsilon parameter as per Hinrichsen (2020), rest based on (c) Mart?n Uribe, May 2014.
% Code replication from Hinrichsen (2020) and  Martin Uribe, May 2014.

%%%%%%%
%   For variables that follow an AR(1) process, it is difficult to directly
%   implement the stochastic nature during value function iteration.
%   Therefore, we discretize the AR(1) process into a transition
%   probability matrix that captures the prob. of the variable going from
%   one state into another.
 
clear all

yT_series = [
    "hp_tradable" "logq_tradable" "hp_gdp" "logq_gdp"
];



for yT = yT_series
    load(yT+".mat");

    %% SRI LANKA
    
        rho = p_SRI;
        sigma_epsilon = std_SRI;
        W = 4.2;                                %width of y_t grid  around its mean (0). The width is measured in terms of standard deviations 
         
        N_grid = 200; 
        T = 1e7; 
         
        %set randomization seed
        stdy = sigma_epsilon/sqrt(1-rho^2)      %unconditional variance of y_t
         
        UB = W*stdy;                            %highest value of y_t grid
        ygrid = -UB: 2*UB / (N_grid-1) : UB;    %grid for y_t
         
        PAI = zeros(N_grid);                    %initialize of transition probability matrix
         
        %Simulate time series for log(gdp_traded)
         
        %initialize simulation
        [~,i0] = min(abs(ygrid));
        y0 = ygrid(i0);
         
        %Drawing
        for t=2:T
            y1 = y0*rho + randn*sigma_epsilon;
            [~,i1] = min(abs(y1-ygrid));
        
            %assign draw to transition probability matrix
            PAI(i0,i1) = PAI(i0,i1) + 1;
            y0 = y1;
            i0 = i1;
        end
         
        %eliminate all rows and columns with all elements equal to zero
        pai = PAI(sum(PAI,2)~=0,sum(PAI,1)~=0);
        pai = pai ./ repmat(sum(pai,2),[1,size(pai,2)]);
        keep = find(sum(PAI,2)~=0);
        ygrid = ygrid(keep);
        ygrid = ygrid(:);
        N_grid = length(ygrid);
        y_cyclical = y_cyclical_SRI;
         
        save("tpm_SRI_"+yT+".mat", "pai", "ygrid", "y_cyclical")

      %% Pakistan

        rho = p_PAK;
        sigma_epsilon = std_PAK;

        stdy = sigma_epsilon/sqrt(1-rho^2)      %unconditional variance of y_t
         
        UB = W*stdy;                            %highest value of y_t grid
        ygrid = -UB: 2*UB / (N_grid-1) : UB;    %grid for y_t
         
        PAI = zeros(N_grid);                    %initialize of transition probability matrix
         
        %Simulate time series for log(gdp_traded)
         
        %initialize simulation
        [~,i0] = min(abs(ygrid));
        y0 = ygrid(i0);
         
        %Drawing
        for t=2:T
            y1 = y0*rho + randn*sigma_epsilon;
            [~,i1] = min(abs(y1-ygrid));
        
            %assign draw to transition probability matrix
            PAI(i0,i1) = PAI(i0,i1) + 1;
            y0 = y1;
            i0 = i1;
        end
         
        %eliminate all rows and columns with all elements equal to zero
        pai = PAI(sum(PAI,2)~=0,sum(PAI,1)~=0);
        pai = pai ./ repmat(sum(pai,2),[1,size(pai,2)]);
        keep = find(sum(PAI,2)~=0);
        ygrid = ygrid(keep);
        ygrid = ygrid(:);
        N_grid = length(ygrid);
        y_cyclical = y_cyclical_PAK;
        save("tpm_PAK_"+yT+".mat", "pai", "ygrid", "y_cyclical")

end

