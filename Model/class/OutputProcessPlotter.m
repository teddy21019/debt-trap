classdef OutputProcessPlotter
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        output_1        OutputProcess
        country_1       string
    
        output_2        OutputProcess
        country_2       string

        fig     
    end

    methods
        function obj = OutputProcessPlotter(country_1, output_process_1, country_2, output_process_2)
           obj.output_1 = output_process_1;
           obj.country_1 = country_1;

           obj.output_2  = output_process_2;
           obj.country_2 = country_2;
        end

        function fig = plot(obj, fig_title_left, y_label_left, fig_title_right, y_label_right )
            fig = figure;
            subplot(1,2,1);

            % original time series
            plot(obj.output_1.year_range , obj.output_1.y,'color',[0 0 0], 'LineWidth',1)
            hold on
            plot(obj.output_2.year_range ,obj.output_2.y,'color',[0.5 0.5 0.5],'LineWidth',1)
            
            % trend
            plot(obj.output_1.year_range ,obj.output_1.y_trend,'color',[0 0 0], 'LineWidth',0.5, 'LineStyle','--')
            hold on
            plot(obj.output_2.year_range ,obj.output_2.y_trend,'color',[0.5 0.5 0.5], 'LineWidth',0.5, 'LineStyle','--')

            set(gca, 'YScale','log')
            xlim([obj.output_1.year_range(1), obj.output_1.year_range(end)])
            ylabel(y_label_left,'interpreter','latex')
            xlabel('Year','interpreter','latex')
            title(fig_title_left,'fontweight','normal','interpreter','latex')
            legend(obj.country_1 + " $y_t$", obj.country_2+ " $y_t$",'Location','southeast','interpreter','latex')
            hold off
            
            %plot deviation
            subplot(1,2,2);
            plot(obj.output_1.year_range ,obj.output_1.y_cyclical * 100,'color',[0 0 0], 'LineWidth',1)
            hold on
            plot(obj.output_2.year_range ,obj.output_2.y_cyclical * 100,'color',[0.5 0.5 0.5], 'LineWidth',1)

            xlim([1960 2021])
            ylim([-20 20])
            ylabel(y_label_right,'interpreter','latex')
            xlabel('Year','interpreter','latex')
            hline=refline(0);
            hline.Color='Black';
            title(fig_title_right,'fontweight','normal','interpreter','latex')
            legend(obj.country_1 + " $y_t$", obj.country_2+ " $y_t$",'Location','southeast','interpreter','latex')
        end
    end
end