classdef OutputProcess < handle
    % Transfers an output sequence into filtered verion

    properties
        filter_type     string {mustBeMember(filter_type, ["HP", "log-q"])}
        y               (:,1) double
        y_cyclical      (:,1) double
        y_trend         (:,1) double
        year_range      (:,1) int16

        p               double                      % rho for AR(1) process
        sigg            double                      % sigma for AR(1) process
        unconditional_std   double

        pai             double {mustBeNonnegative}
        ygrid           double
    end

    methods
        function obj = OutputProcess(y, year_range, filter_type)
            obj.y = y;
            obj.year_range = year_range;
            obj.filter_type = filter_type;

            if length(y) ~= length(year_range)
                error("Year range does not match output process !!")
            end
    
            disp("Filtering...")
            obj.filter();
            disp("Constructing transition prob. matrix...")
            obj.tpm();
        end

        function filter(obj)
            if obj.filter_type == "HP"
                [obj.y_trend, obj.y_cyclical] = hpfilter(obj.y, 100);
            elseif obj.filter_type == "log-q"
                obj.y_cyclical = LQ_detrend(obj.y, 'difference');
                obj.y_trend = obj.y - obj.y_cyclical;
            else
                error("Wrong filtering method!!")
            end
            autocorr_par= autocorr(obj.y_cyclical,'NumLags',1);
            
            obj.p = 1-(1-autocorr_par(2))/4;
            obj.sigg = std(obj.y_cyclical)/sqrt(4);
            obj.unconditional_std = obj.sigg / sqrt(1 - obj.p^2);
        end

        function tpm(obj)
            rho = obj.p;
            sigma_epsilon = obj.sigg;
            W = 4.2;                                %width of y_t grid  around its mean (0). The width is measured in terms of standard deviations 
             
            N_grid = 200; 
            T = 1e7; 
                  
            UB = W*obj.unconditional_std;  %highest value of y_t grid. Must not less than 1.5
            ygrid_ = -UB: 2*UB / (N_grid-1) : UB;    %grid for y_t
             
            PAI = zeros(N_grid);                    %initialize of transition probability matrix
             
            %Simulate time series for log(gdp_traded)
             
            %initialize simulation
            [~,i0] = min(abs(ygrid_));
            y0 = ygrid_(i0);
             
            %Drawing
            for t=2:T
                y1 = y0*rho + randn*sigma_epsilon;
                [~,i1] = min(abs(y1-ygrid_));
            
                %assign draw to transition probability matrix
                PAI(i0,i1) = PAI(i0,i1) + 1;
                y0 = y1;
                i0 = i1;
            end
             
            %eliminate all rows and columns with all elements equal to zero
            pai_ = PAI(sum(PAI,2)~=0,sum(PAI,1)~=0);
            pai_ = pai_ ./ repmat(sum(pai_,2),[1,size(pai_,2)]);
            keep = sum(PAI,2)~=0;
            ygrid_ = ygrid_(keep);
            ygrid_ = ygrid_(:);

            obj.pai = pai_;
            obj.ygrid = ygrid_;
        end

        function plot_filter(obj, year_range, fig_object)
            figure(fig_object)
            subplot(1,2,1);
            plot(year_range, obj.y,'color','[0.8500, 0.3250, 0.0980]')
            hold on
            plot(year_range, obj.y_trend,'--','color','[0.8500, 0.3250, 0.0980]')
            set(gca, 'YScale','log')
            ylabel('Log of real GDP per capita','interpreter','latex')
            xlabel('Year','interpreter','latex')
            title('Real GDP per capita and secular trend component','fontweight','normal','interpreter','latex')
            legend('$y_t$','Location','southeast','interpreter','latex')
            hold off
            
            %plot deviation
            subplot(1,2,2);
            plot(year_range, obj.y_cyclical*100,'color','[0.8500, 0.3250, 0.0980]')
            hold on
            xlim([1960 2021])
            ylim([-20 20])
            ylabel('Percent deviation from secular trend of $y_t$','interpreter','latex')
            xlabel('Year','interpreter','latex')
            hline=refline(0);
            hline.Color='Black';
            title('Cyclical compotent of real GDP per capita','fontweight','normal','interpreter','latex')
            legend('Sri Lanka $y_t$', 'Location','southwest','interpreter','latex')

        end
    
        function [y, y_t, y_c] = get_range(obj, get_year_range)
            % 1960 ~ 2021 -> 2007 ~ 2013
            %    1 ~   62 ->   48 ~   54
            i_start = get_year_range(1) - obj.year_range(1) + 1;
            i_end   = get_year_range(end) - obj.year_range(1) + 1;
            y = obj.y(i_start:i_end);
            y_t = obj.y_trend(i_start:i_end);
            y_c = obj.y_cyclical(i_start:i_end);

        end
    end
end