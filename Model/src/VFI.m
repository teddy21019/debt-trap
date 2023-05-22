function VFI(ygrid, pai, rstar, theta, alfa, a, xi, sigg, betta, delta_1, delta_2, output_file_name, init_value_function)

    ny = numel(ygrid);                                  %number of grid points for log of tradable ouput
    y = exp(ygrid(:));                                  %level of tradable output
    
    hbar = 1;                                           % since this is universal for all model, I put the calibration here instead of main file
        
    % Debt grid
    dupper = 1.5;                                       %upper bound debt range
    dlower = 0;                                         %lower bound debt range
    nd = 200;                                           %# of grid points for debt 
    d = dlower:(dupper-dlower)/(nd-1):dupper;           % create a 200 vector of debt space
    d = d(:);                                           % reshape as one column (1 x 200) to (200 x 1)

    [~,nd0]=min(abs(d)); 
    d(nd0) = 0; 

    n = ny*nd;

    %grid for d_t
    dtry = repmat(d',[ny 1  nd]);                       
    dtry = reshape(dtry,n,nd);                          

    %grid for d_{t+1} try
    dptryix = repmat(1:nd,n,1);
    dptry = d(dptryix);

    %grid for yT_t
    yTix = repmat((1:ny)',1,nd);
    yT = y(yTix);

    %grid for yT_t try
    yTtryix = repmat(yTix,nd,1);
    yTtry = y(yTtryix);

    %Punishment Function
    yhat = y - max(0, delta_1*y + delta_2*y.^2); 

    %AUTARKY
    %tradable output under autarky
    yTa = repmat(yhat, [1 nd]);
    cTa = yTa;                                          %consumption of tradables under autarky
    ua = (a * cTa.^(1-sigg) + (1-a) * hbar.^(alfa*(1-sigg))-1)  / (1-sigg); %utility under autarky 
    
    init_value_function = strcat(init_value_function, '.mat');
    if isfile(init_value_function)
        load(init_value_function, 'vc', 'vg', 'vb', 'vr')
    else
        %Initialize the value functions
        vc = zeros(ny,nd);                                  %continue repaying
        vg = zeros(ny,nd);                                  %good standing
        vb = zeros(ny,nd);                                  %bad standing
        vr = zeros(ny,nd); 
    end
    
    vcnew = vc;
    dpix = vc; 

    f = vc<vb;                                          %default indicator 1 if default, 0 otherwise; f maps (yT_t,d_t)--->{1,0}
    q = (1- pai*f)/(1+rstar);

    Itry = sub2ind([ny nd],yTtryix,dptryix);

    dpixold = 0;

    dist = 1;
    while dist>1e-8
        qtry = repmat(q,[nd 1]);
        cTtry =  dptry .* qtry - dtry + yTtry;              %consumption of tradables
        utry = (a * cTtry.^(1-sigg)  + (1-a) * hbar.^(alfa*(1-sigg)) -1)  / (1-sigg);
        utry(cTtry<=0) = -inf;
        evgptry = pai *  vg;
        Evgptry = evgptry(Itry);

        clear evgptry evbptry evrptry

        [vcnew(:), dpix(:)] = max(utry+betta*Evgptry,[],2);     % state space is suppose to be (ny x nd) x nd, but dpix(:) preserves the shape
        vbnew = ua+betta*pai*(theta*vr + (1-theta) * vb);
        f = vc<vb;                                          %default indicator 1 if default, 0 otherwise; f maps (yT_t,d_t)--->{1,0}
        qnew = (1- pai*f)/(1+rstar);
        fnew = vcnew<vbnew; 
        dist = max(abs(qnew(:)-q(:))) + max(abs(vcnew(:)-vc(:))) + max(abs(vbnew(:)-vb(:))) + max(abs(dpix(:)-dpixold(:)))   + max(abs(fnew(:)-f(:)));

        clear fnew 

        q = qnew;
        vc = vcnew;
        vb = vbnew;
        vg = max(vc,vb);
        vc = reshape(vc,ny,nd);
        vb = reshape(vb,ny,nd);
        vg = reshape(vg,ny,nd);
        vr = repmat(vg(:,nd0),1,nd);
        dpix = reshape(dpix,ny,nd);
        dpixold = dpix;
    end 

    %Policy functions under continuation;

    %debt choice under continuation
    dpc = d(dpix);

    %consumption of tradables under continuation
    I = sub2ind([ny nd],yTix,dpix);
    cTc = q(I).*dpc+yT-repmat(d',ny,1); 

    %consumption of tradables  under good standing
    cTg = cTa.*f + cTc.*(1-f); 

    %marginal utility of consumption of tradabels under continuation
    lac = a*cTc.^(-sigg);

    %marginal utility of consumption of tradabels in good standing
    lag = a*cTg.^(-sigg);

    %Elagp=E_tla_{t+1} if continuation in t
    pai*lag;
    Elagp =  ans(I);

    %capital controls under continuation
    betta* Elagp ./ lac ./q(I);
    tauc = 1-ans;

    clear ans yTtry cTtry cTatry dtry dptry Itry qtry  utry uatry Evgptry Evbptry Evrptry
    
    save(strcat(output_file_name,'.mat'))

end