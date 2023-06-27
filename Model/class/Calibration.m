classdef Calibration
    % Encapsuates all the calibration parameters

    properties
        betta;                  % discount factor 
        delta_1;                % linear parameter for lost function
        delta_2;                % quadratic parameter for lost function
        
        rstar;                  % quarterly risk-free interest rate
        theta;                  % probability of leaving 'bad standing' is 1-theta. When it is in bad standing, external obligations go to zero.
        alfa;                   % hours elasticity of nontraded output
        a;                      % share of tradables (as a % of total consumption)
        xi;                     % elasticity of substitution between traded and nontraded goods
        sigg; 
        hbar;                   % hours of work, usually normalized to 1
        gamma;                  % downward wage rigidity

        d_range (1,2) double = [0 1.5]
    end

    properties(Dependent)
        has_set_all logical
    end

    methods
        function obj = Calibration(rstar, theta, alfa, a, xi, sigg, hbar, betta, delta_1, delta_2)
            if nargin > 0
                obj.rstar = rstar;
                obj.theta = theta;
                obj.alfa = alfa;
                obj.a = a;
                obj.xi = xi;
                obj.sigg = sigg;
                obj.hbar = hbar;
                obj.betta = betta;
                obj.delta_1 = delta_1;
                obj.delta_2 = delta_2;
            end
        end

        function has_set = get.has_set_all(obj)
            has_set = ~isempty(obj.betta) & ...
                ~isempty(obj.delta_1) & ...
                ~isempty(obj.delta_2);
        end
    end
end