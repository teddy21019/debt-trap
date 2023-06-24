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
        targets struct;
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
                if ~keep_running
                    disp("Model estimation terminated.")
                    return
                end
            
                % proceed to find the optimal calibration for beta, delta_1
                % and delta_2
                obj.tune_calibration()

            end
            obj.vf.VFI()
        end

        function set_targets(obj, targets)
            obj.targets = targets;
            
        end

        function tune_calibration(obj)
            min_search = [0.6   -0.6    0.2];
            max_search = [0.95  -0.2    0.6];


            options = optimoptions('surrogateopt','PlotFcn','surrogateoptplot',...
                            'MaxFunctionEvaluations',150,'CheckpointFile','opt_checkfile.mat');
            [optimal_calibration_grid, min_distance, exitflag, output,trials] = ...
                    surrogateopt(distance_func,min_search, max_search, options);

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
            distance = norm( ...
                    [targets.debt_ratio*10 targets.default_freq targets.output_loss*100] - ...
                    [debt_ratio*10 default_freq output_loss*100]); 
        end

    end
end