classdef Model < handle
    % Model for Debt-Trap Thesis
    %   A model encapsulates all the information including:
    %       - Calibration details
    %       - VFI function/ result
    %       - Simulation/ result
    %       - plots
    

    properties
        cal Calibration;
        output_proxy OutputProcess;
        vf ValueFunction;
        sim Simulation;
        targets struct;

        optimal_calibration_grid
        min_distance

    end

    properties(Dependent)
        estimated_target
    end


    methods
        function obj = Model(calibration, output_proxy)
            obj.cal = calibration;
            obj.output_proxy = output_proxy;
            obj.vf = ValueFunction(obj.cal, obj.output_proxy);
            obj.targets = struct();
        end

        function run(obj)
            if ~obj.cal.has_set_all
                keep_running = questdlg("The calibration parameters is not all set. Proceed to run estimation?", ...
                    "Run Estimation", ...
                      "Yes", "No", "Yes");
                switch keep_running
                    case "No"
                        disp("Model estimation terminated.")
                        return
                end
            
                % proceed to find the optimal calibration for beta, delta_1
                % and delta_2
                obj.tune_calibration()

            end
            obj.vf.VFI();
            obj.sim = Simulation(obj.vf).fast_simulation();
        end

        function set_targets(obj, targets)
            obj.targets = targets;
            
        end

        function tune_calibration(obj)
            min_search = [0.6   -0.6    0.2];
            max_search = [0.95  -0.2    0.6];

            distance_func = @(x) obj.search_objective_fn(x);


            options = optimoptions('surrogateopt','PlotFcn','surrogateoptplot',...
                            'MaxFunctionEvaluations',1000,'CheckpointFile','opt_checkfile.mat');
            f_opt = figure;
            [optimal_calibration_grid, min_distance, exitflag, output,trials] = ...
                    surrogateopt(distance_func,min_search, max_search, options);
            obj.optimal_calibration_grid = optimal_calibration_grid;

            obj.min_distance = min_distance;
            obj.cal = add_tuning_params(obj.cal, optimal_calibration_grid);
            obj.vf = ValueFunction(obj.cal, obj.output_proxy);
        end

        function distance = search_objective_fn(obj, param_vector)

            % must addpath('src')
            new_calibration = add_tuning_params(obj.cal, param_vector);
            temp_vf = ValueFunction(new_calibration, obj.output_proxy).VFI();
            temp_sim = Simulation(temp_vf).fast_simulation();
            distance = obj.distance_function(temp_sim);
        end

        function distance = distance_function(obj, simulation)
            targets = obj.targets;

            [debt_ratio, default_freq, output_loss] =  simulation.extract_default_moments();
%             distance = norm( ...
%                     [targets.debt_ratio*10 targets.default_freq targets.output_loss*100] - ...
%                     [debt_ratio*10 default_freq output_loss*100]); 
            disp([debt_ratio, default_freq, output_loss])
            distance = norm( [ 
                    (debt_ratio/targets.debt_ratio-1)*8 
                    (default_freq/targets.default_freq-1)*2
                    (output_loss/targets.output_loss-1)
                ]);

        end

        function estimated_target = get.estimated_target(obj)
            if ~obj.cal.has_set_all
                estimated_target = [0 0 0];
            else
                [debt_ratio, default_freq, output_loss] = obj.sim.extract_default_moments();
                estimated_target = [debt_ratio, default_freq, output_loss];
            end
        end

    end
end