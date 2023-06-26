classdef DefaultSetPlotter < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        model Model
        debt_series
        plot_year_range (1,:) int16
        fig
    end

    properties(Dependent)
        output_process OutputProcess
        year_range (1,:) int16
    end

    methods

        function obj = DefaultSetPlotter(model, debt_series, plot_year_range)
            obj.model = model;
            obj.debt_series = debt_series;
            obj.plot_year_range = plot_year_range;
        end

        function fig = plot(obj)
            fig = figure;
            obj.fig = fig;
            
            yT = obj.model.vf.yT;
            d  = obj.model.vf.d;
            f  = obj.model.vf.f;

            y_cyclical = obj.output_process.y_cyclical;
            ny = size(yT, 1);

            d_grid = repmat(d', [ny 1]) * 100;
            map=[0.9 0.9 0.9
                1 1 1
                ];
            colormap(map)
            contourf(yT,d_grid,f,'LineColor','None','ShowText','On') 

            [~,~, y_cyclical] = obj.output_process.get_range(obj.plot_year_range);
            y_cyclical = 1 + y_cyclical;
            
            debt_array = obj.debt_series * 0.37 * 4 * 100;
            for year_index = 1:length(obj.plot_year_range)
                hold on
                plot(y_cyclical(year_index), debt_array(year_index), 'ko','MarkerFaceColor','k')
                text(y_cyclical(year_index), ceil(debt_array(year_index))+1, string(obj.plot_year_range(year_index)))
            end
            xlabel('$y_{t}^{T}$','interpreter','latex')
            ylabel('Debt stock $d_{t}$','interpreter','latex')
            title('Default set','interpreter','latex')
            %ylim([30 120])
            %xlim([0.85 1.4])
            set(gcf,'color','w');


        end
        
        function op = get.output_process(obj)
            op = obj.model.output_proxy;
        end
        function yr = get.year_range(obj)
            yr = obj.output_process.year_range;
        end
        
    end
end