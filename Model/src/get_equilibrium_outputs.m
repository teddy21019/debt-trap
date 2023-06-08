function [avg_debt, deafult_freqency, output_loss] = get_equilibrium_outputs(simulated_result_file)
    simulated_result_file = strcat(simulated_result_file, '.mat')
    load(simulated_result_file, '')
    

    tb = 8;                                             %periods before default
    ta = 8;                                             %periods after default

    load simu_SRI.mat YT YTA YTtilde B D CT P W Q F TAU DEV PM INFL PC T Tburn ygrid pai filename rstar betta theta yhat alfa hbar a sigg xi dupper dlower nd 


    C = (a*CT.^(1-1/xi) + (1-a)*1^(1-1/xi)).^(1/(1-1/xi));

    ER = W.^(-1);                                       %nominal exchange rate. Recall that under the particular optimal devaluation policy considered here, namely, dev_t = w_{t-1}/wf_t, the nominal wage is constant, so the nominal exchange rate is proportional to the inverse of the real wage rate.

    x1 = find(F==1);
    x1 = x1(x1>tb);
    x=x1;

    find(x>=tb+1);
    x = x(ans);
    find(x<=T-ta);
    x = x(ans);

    %pre-allocate arrays
    xlong = length(x);
    ylong = tb+ta+1;
    yT = zeros(xlong,ylong); 
    yTaut = zeros(xlong,ylong); 
    yTtilde = zeros(xlong,ylong); 
    b = zeros(xlong,ylong); 
    d = zeros(xlong,ylong); 
    cT = zeros(xlong,ylong); 
    c = zeros(xlong,ylong); 
    p = zeros(xlong,ylong); 
    w = zeros(xlong,ylong); 
    q = zeros(xlong,ylong); 
    f = zeros(xlong,ylong); 
    tau = zeros(xlong,ylong); 
    dev = zeros(xlong,ylong); 
    er = zeros(xlong,ylong); 
    pm = zeros(xlong,ylong); 
    infl = zeros(xlong,ylong); 
    pc = zeros(xlong,ylong); 

    for i=1:length(x)
        yT(i,1:tb+ta+1) =  YT(x(i)-tb:x(i)+ta)';
        yTaut(i,1:tb+ta+1) =  YTA(x(i)-tb:x(i)+ta)';
        yTtilde(i,1:tb+ta+1) =  YTtilde(x(i)-tb:x(i)+ta)';
        b(i,1:tb+ta+1) =  B(x(i)-tb:x(i)+ta)';
        d(i,1:tb+ta+1) =  D(x(i)-tb:x(i)+ta)';
        cT(i,1:tb+ta+1) =  CT(x(i)-tb:x(i)+ta)';
        c(i,1:tb+ta+1) =  C(x(i)-tb:x(i)+ta)';
        p(i,1:tb+ta+1) =  P(x(i)-tb:x(i)+ta)';
        w(i,1:tb+ta+1) =  W(x(i)-tb:x(i)+ta)';
        q(i,1:tb+ta+1) =  Q(x(i)-tb:x(i)+ta)';
        f(i,1:tb+ta+1) =  F(x(i)-tb:x(i)+ta)';
        tau(i,1:tb+ta+1) =  TAU(x(i)-tb:x(i)+ta)';
        dev(i,1:tb+ta+1) =  DEV(x(i)-tb:x(i)+ta)';
        er(i,1:tb+ta+1) =  ER(x(i)-tb:x(i)+ta)';
        er(i,:) = er(i,:)/er(i,1);
        pm(i,1:tb+ta+1) =  PM(x(i)-tb:x(i)+ta)';
        infl(i,1:tb+ta+1) =  INFL(x(i)-tb:x(i)+ta)';
        pc(i,1:tb+ta+1) =  PC(x(i)-tb:x(i)+ta)';
    end

    t = (-tb:ta);

    mean_dev =  (W(1)/W(end))^(1/(length(W)-1));
    mean_dev = (mean_dev^4-1)*100;

    f = @(x) median(x);
    f = @(x) mean(x);
    
    
end