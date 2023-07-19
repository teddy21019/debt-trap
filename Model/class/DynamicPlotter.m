classdef DynamicPlotter < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        simulation Simulation
        fig

        yT
        yTtilde
        d
    end

    methods
        function obj = DynamicPlotter(sim)
            obj.simulation = sim;
        end

        function obj = extract_episode(obj, tb, ta)
            F = obj.simulation.F;
            T = obj.simulation.T;
            D = obj.simulation.D;
            YT = obj.simulation.YT;
            YTtilde = obj.simulation.YTtilde;

            x1 = find(F == 1);
            x1 = x1(x1 > tb);
            x = x1(x1 >= tb + 1);
            x = x(x <= T - ta);
            xlong = length(x);
            ylong = tb+ta+1;

            % preallocation
            yT = zeros(xlong,ylong);
            yTtilde = zeros(xlong,ylong);
            d = zeros(xlong,ylong); 


            for i=1:length(x)
                yT(i,1:tb+ta+1) =  YT(x(i)-tb:x(i)+ta)';
                yTtilde(i,1:tb+ta+1) =  YTtilde(x(i)-tb:x(i)+ta)';
                d(i,1:tb+ta+1) =  D(x(i)-tb:x(i)+ta)';
            end

            obj.yT = yT;
            obj.yTtilde = yTtilde;
            obj.d = d;
                        
        
        end

        function fig = plot(obj, tb, ta)
            fig = figure;
            obj.fig = fig;
            lineType='-';                                                                           
            tslineWidth=2;  
            set(findall(gcf,'-property','FontName'),'FontName','times')

            obj.extract_episode(tb, ta);

            f = @(x) median(x);
            t = (-tb:ta);

            %% Output
            subplot(1,2,1)                                                                    
            x=f(obj.yT);
            plot(t,x,lineType,'linewidth',tslineWidth,'color','k');       
            hold on 
            x=f(obj.yTtilde);
            plot(t,x,'--','linewidth',tslineWidth,'color','k');    
            hold on 
            set(gca,'xtick', -tb:5:ta)                                                           
            h=title('Loss of tradable output');                         
            set(h, 'Interpreter', 'Latex')                                                         
            h=legend('${y^T_t}$','Location','nw');
            set(h, 'Interpreter', 'Latex')                                                      
            xlim([-tb ta])                                                                       
            xlabel('Quarters before a hypothetical default at {t_0}','FontSize',9);
            ylim([0.70 1.1])
            ylabel('Output normalised to 1','FontSize',9);
            xline(0,'--','LineWidth',1,'HandleVisibility','off')
            hold off

            %% Debt
            subplot(1,2,2)
            x=obj.d*100;
            plot(t,f(x),lineType,'linewidth',tslineWidth,'color','k');
            hold on 
            h=title('Debt level');
            set(h, 'Interpreter', 'Latex')
            h=legend('${d_t}$','Location','ne');
            set(h, 'Interpreter', 'Latex')  
            ylabel('Percent of GDP','FontSize',9)
%             ylim([0 90])
            xlim([-tb tb])
            xlabel('Quarters before a hypothetical default at {t_0}','FontSize',9);
            xline(0,'--','LineWidth',1,'HandleVisibility','off')

            set(gca,'xtick', -tb:5:ta)
        end


    end
end