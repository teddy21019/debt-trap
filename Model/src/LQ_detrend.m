
% LQ_detrend.m
% =======================================================================
% Linear-quadratic filter
% Coded by:         Andres Fernandez and Santiago Téllez
% This version:     January, 2017
% =======================================================================


function X_cycl = LQ_detrend(X, type)
        X_cycl = nan(size(X));
    if strcmp(type, 'log_dif')
        lq_trend            = (1:sum(~isnan(X)))';
        b                   = [ones(length(lq_trend), 1), lq_trend, lq_trend.^2]\log(X(~isnan(X)));
        fit_val             = [ones(length(lq_trend), 1), lq_trend, lq_trend.^2]*b;
        X_cycl(~isnan(X))   = log(X)-fit_val;
    elseif strcmp(type, 'difference')
        lq_trend            = (1:sum(~isnan(X)))';
        b                   = [ones(length(lq_trend), 1), lq_trend, lq_trend.^2]\X(~isnan(X));
        fit_val             = [ones(length(lq_trend), 1), lq_trend, lq_trend.^2]*b;
        X_cycl(~isnan(X))   = X-fit_val;
    end

end
