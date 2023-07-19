classdef DefaultSetPlotter < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        model Model
        debt_series
        plot_year_range (1,:) int16
        fig
        xrange = [-1 -1]
        yrange = [-1 -1]
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

        function obj = add_range(obj, xrange, yrange)
            obj.xrange = xrange;
            obj.yrange = yrange;
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
            xlabel('$y_{t}^{T}$','interpreter','latex')
            ylabel('Debt-to-Tradable-GDP(\%) $d_{t}$','interpreter','latex')
            title('Default Set','interpreter','latex')
            if obj.yrange ~= [-1 -1]
                ylim(obj.yrange)
            end
            if obj.xrange ~= [-1 -1]
                xlim(obj.xrange) 
            end
            set(gcf,'color','w');
            set(gca,'fontname','times')  % Set it to times
            set(gca,'fontsize', 12)


            [~,~, y_cyclical] = obj.output_process.get_range(obj.plot_year_range);
            y_cyclical = 1 + y_cyclical;
            
            debt_array = obj.debt_series * 0.37 * 4 * 100;
            for year_index = 1:length(obj.plot_year_range)
                hold on
                plot(y_cyclical(year_index), debt_array(year_index), 'ko','MarkerFaceColor','k')
                text(y_cyclical(year_index), ceil(debt_array(year_index))+3, string(obj.plot_year_range(year_index)),...
                    "FontName","times")
            end
            


        end

        function fig = add_comparison(obj, comparison_array, fig_old)
            if nargin == 2
                obj.fig;
            elseif nargin == 3
                fig_old;
            end
            ax = gca;
            map= colormap;

            fig = figure;
            ax2 = copyobj(ax, fig);

            colormap(map)
            [~,~, y_cyclical] = obj.output_process.get_range(obj.plot_year_range);
            y_cyclical = 1 + y_cyclical;
            comparison_array = comparison_array * 0.37 * 4 * 100;

            for year_index = 1:length(obj.plot_year_range)
                hold on
                plot(y_cyclical(year_index), comparison_array(year_index), 'ko','MarkerFaceColor',[0.7 0.7 0.7])
                text(y_cyclical(year_index), ceil(comparison_array(year_index))+3, string(obj.plot_year_range(year_index)),...
                    "FontName","times")
            end
        end
        
        function fig = plot_prob(obj)

            fig = figure;
            
            yT = obj.model.vf.yT;
            d  = obj.model.vf.d;
            f  = obj.model.vf.f;
            pai = obj.model.output_proxy.pai;

            y_cyclical = obj.output_process.y_cyclical;
            ny = size(yT, 1);

            d_grid = repmat(d', [ny 1]) * 100;
            map= repmat(0.7:0.005:1, 3,1); map = map';
            colormap(map)

            contourf(yT,d_grid,pai*f,5,'LineColor','None','ShowText','Off') 
            xlabel('$y_{t}^{T}$','interpreter','latex')
            ylabel('Debt-to-Tradable-GDP(\%) $d_{t}$','interpreter','latex')
            title('Default Probability','interpreter','latex')
            if obj.yrange ~= [-1 -1]
                ylim(obj.yrange)
            end
            if obj.xrange ~= [-1 -1]
                xlim(obj.xrange) 
            end
            set(gcf,'color','w');
            set(gca,'fontname','times')  % Set it to times
            set(gca,'fontsize', 12)


            [~,~, y_cyclical] = obj.output_process.get_range(obj.plot_year_range);
            y_cyclical = 1 + y_cyclical;
            
            debt_array = obj.debt_series * 0.37 * 4 * 100;
            for year_index = 1:length(obj.plot_year_range)
                hold on
                plot(y_cyclical(year_index), debt_array(year_index), 'ko','MarkerFaceColor','k')
                text(y_cyclical(year_index), ceil(debt_array(year_index))+3, string(obj.plot_year_range(year_index)),...
                    "FontName","times")
            end
            


        end

        function op = get.output_process(obj)
            op = obj.model.output_proxy;
        end
        function yr = get.year_range(obj)
            yr = obj.output_process.year_range;
        end
        
    end
end