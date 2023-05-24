function dynamic_simulation(VFI_filename, sim_filename, save_file_bool)
    arguments
        VFI_filename string
        sim_filename string
        save_file_bool logical = true 
    end
    load(strcat(VFI_filename, '.mat'))
    

    cpai = cumsum(pai,2);

    %Initial conditions
    [~,i] = min(abs(y-1));                              %average endowment of tradables
    j = floor(nd/2);                                    %no external debt 
    b = 0;                                              %for any t, if b=1==>bad standing in t-1 and  b=1==>good standing in t-1
    pcb = 1/a;                                          %initial rel. price of c_t 
    wb = (1-a) / a *alfa;                               %initial past wage 

    %Length of simulation and burning period
    T = 1e6;
    Tburn = 1e5;

    %Initialize the variables 
    YT = zeros(Tburn+T,1);
    YTtilde = zeros(Tburn+T,1);
    YTA = zeros(Tburn+T,1);
    B = zeros(Tburn+T,1);
    D = zeros(Tburn+T,1);
    CT = zeros(Tburn+T,1);
    W = zeros(Tburn+T,1);
    Q = zeros(Tburn+T,1);
    F = zeros(Tburn+T,1);
    TAU = zeros(Tburn+T,1);
    H = zeros(Tburn+T,1);
    STATE = zeros(Tburn+T,1);
    CN = zeros(Tburn+T,1);
    C = zeros(Tburn+T,1);
    P = zeros(Tburn+T,1);
    PC = zeros(Tburn+T,1);                %price of final consumption in units of tradables; that is: PC = P^C/P^T
    INFL = zeros(Tburn+T,1);                  %inflation
    PM = zeros(Tburn+T,1);

    for t=1:T+Tburn

        STATE(t,1) = sub2ind([ny nd ],i,j);
        rr = rand;                                          %random number  determining reentry if applicable
        F(t,1) = f(i,j);


        if (b==0) && (F(t)==0)                              %choose to continue 
            B(t,1) = 0;                                         %B=0==>good standing at the beginning of current period
            D(t,1) = d(j);
            YT(t,1) = y(i);
            YTtilde(t,1) = y(i);
            YTA(t,1) = yTa(i,j); 
            CT(t,1) = cTc(i,j);
            Q(t,1) = q(i,dpix(i,j));
            TAU(t,1) = tauc(i,j)*100;

            %update state
            jp  = dpix(i,j);                                    %update debt state

        end                                                 %if b==0 & F(t) ==0

        if (b==0) && (F(t) ==1)                             %choose to default
            B(t,1) = 0;                                         %B=0==>good standing at the beginning of current period
            D(t,1) = d(j);
            YT(t,1)= y(i);
            YTtilde(t,1) = yTa(i,j);
            YTA(t,1) = yTa(i,j); 
            CT(t,1) = yTa(i,j);
            Q(t,1) = 0;
            TAU(t,1) = 0;

            %update state
            jp = nd0;                                           %update debt state

        end                                                 %if F(t) == 1 && b==0

        if (b==1) && (rr>theta)                             %==> autarky (bad standing and did not get to re-enter)
            B(t,1) = 1;                                         %bad standing in t
            D(t,1) = 0;
            YTtilde(t,1) = yTa(i,j);
            YTA(t,1) = yTa(i,j);
            YT(t,1) = y(i); 
            CT(t,1) = yTa(i,j);
            Q(t,1) = 0;
            TAU(t,1) = 0;

            %update state
            jp = nd0;                                           %update debt state

        end                                                 %if (b==1) && (rr>theta); % ==> autarky (bad standing and did not get to re-enter)

        if (b==1) && (rr<=theta)                            %reentry after having been in bad standing 
            B(t,1) = 0; 
            D(t,1) = d(nd0);
            YTtilde(t,1) = y(i);
            YT(t,1) = y(i);
            YTA(t,1) = yTa(i,j);
            CT(t,1) = cTc(i,nd0);
            Q(t,1) = q(i,dpix(i,nd0));
            TAU(t,1) = tauc(i,nd0)*100;

            %update state
            jp = dpix(i,nd0);                                   %update debt state

        end                                                 %if (b==1) && (rr<=theta); %reentry after having been in bad standing 

        H(t,1)  =  hbar; 
        CN(t,1) = H(t,1)^alfa;
        C(t,1) = (a*CT(t)^(1-1/xi) + (1-a)*CN(t)^(1-1/xi))^(1/(1-1/xi));
        P(t,1) = (1-a) / a * (CT(t)/CN(t))^(1/xi);
        PC(t,1) = 1/a * (CT(t)/C(t))^(1/xi);                %price of final consumption in units of tradables; that is: PC = P^C/P^T
        INFL(t,1) = ((PC(t)/pcb)^4-1)*100;                  %inflation
        PM(t,1) = ((1/Q(t,1)/(1+rstar))^4-1)*100;           %country risk premium

        find(cpai(i,:)>rand);
        i = ans(1);
        pcb = PC(t);

        b = B(t) + F(t);                                    %F(t) = 1  you choose to default; B(t) =1 means you were in bad standing at the end of the period. 

        j=jp; 

    end                        


    %create W(t), W(t-1), and DEV(t)
    W  = P.* alfa; 
    Wback = [wb; W(1:end-1)];
    DEV = Wback./W;

    %remove burn in 
    STATE = STATE(Tburn+1:end);
    YT = YT(Tburn+1:end);
    YTA = YTA(Tburn+1:end);
    YTtilde = YTtilde(Tburn+1:end);
    B = B(Tburn+1:end);
    D = D(Tburn+1:end);
    CT = CT(Tburn+1:end);
    P = P(Tburn+1:end);
    Q = Q(Tburn+1:end);
    F = F(Tburn+1:end);
    TAU = TAU(Tburn+1:end);
    PM = PM(Tburn+1:end);      
    INFL = INFL(Tburn+1:end);
    PC = PC(Tburn+1:end);
    CN = CN(Tburn+1:end);
    H = H(Tburn+1:end);
    W = W(Tburn+1:end);
    Wback = Wback(Tburn+1:end);
    DEV = DEV(Tburn+1:end); 

    %construct other variables 
    GDP = YTtilde+P.*CN;                                %GDP in terms of tradables
    D_O_GDP = D./(4*GDP); 
    DEV = (DEV.^4-1)*100;                               %devaluation rate

    output = [4*mean(F)  mean(PM(B==0&F==0))];

    %compute debt density
    for i=1:nd
        lad(i,1) = mean(D==d(i));
    end
    
    if save_file_bool
        save(strcat(sim_filename, '.mat'))
    end


    
end