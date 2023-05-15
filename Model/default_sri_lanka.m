% default_1950s.m
% Optains the policy function of the model 
% Calibrated to Finland reparations after WWII
% Produces: default_1950s.mat
% Run-time: ~100 seconds  
%   
% by Simon Hinrichsen (2020), a (sligthly) edited version of the code from Na et al. (2018)

clear all
filename = 'default_sri_lanka';                         %output file needed to run simu_1950s.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Exogenous process for traded endowment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First run tpm.m in order to obtain the discretized AR(1) process of the output,
% in which the autocorrelation parameter and the variance is obtained via
% OLS. The output data is tpm.mat
%
% ygrid represents the gird that is generated during the discretization.
%       -- ( ny x 1 ) | column vector 
% pai represents the transition probability from one y value to another.
%       the y value corresponds to the one on the same index in ygrid
%       -- (ny x ny ) matrix
%

load tpm_SRI.mat ygrid pai                              %ygrid=endowment grid; associated pai=transition probability matrix
ny = numel(ygrid);                                  %number of grid points for log of tradable ouput
y = exp(ygrid(:));                                  %level of tradable output

%Calibrated parameters: 
rstar = 0.0012/4;                                   %quarterly risk-free interest rate, using US 3-month treasury bill
betta = 0.85;                                       %discount factor based on loss-function, using standard numbers (from Na et al. 2018)
theta = 0.0385;                                     %probability of leaving 'bad standing' is 1-theta. When it is in bad standing, external obligations go to zero. Implies you're in bad standing for ~6.5 years, following Na et al. (2018)
alfa = 0.9;                                         %hours elasticity of nontraded output (rough estimate based on exports as % of GDP)
hbar = 1;                                           %full-employment hours (normalised to unity)
a = 0.35;                                           %share of tradables (as a % of total consumption) (based on actual GDP data, imports/consumptions)
xi = 0.78;                                          %elasticity of substitution between traded and nontraded goods (estimates vary considerably; 1/sigg (where sigg=2) is Na et al; 0.75 is Devereux and Smith.)
sigg = 1/xi;                                        %elasticity of substitution: inverse intertemporal (Na et al. 2018)

% %Calibrated parameters: 
% rstar = 0.0096/4;                                   %quarterly risk-free interest rate, using US 3-month treasury bill
% betta = 0.9;                                       %discount factor based on loss-function, using standard numbers (from Na et al. 2018)
% theta = 0.0385;                                     %probability of leaving 'bad standing' is 1-theta. When it is in bad standing, external obligations go to zero. Implies you're in bad standing for ~6.5 years, following Na et al. (2018)
% alfa = 0.75;                                         %hours elasticity of nontraded output (rough estimate based on exports as % of GDP)
% hbar = 1;                                           %full-employment hours (normalised to unity)
% a = 0.26;                                           %share of tradables (as a % of total consumption) (based on actual GDP data, imports/consumptions)
% xi = 0.5;                                          %elasticity of substitution between traded and nontraded goods (estimates vary considerably; 1/sigg (where sigg=2) is Na et al; 0.75 is Devereux and Smith.)
% sigg = 1/xi;                                        %elasti

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
yhat_d0 = -0.32;                                    %the form of the loss-function is taken from Chatterjee and Eyigungor, AER 2012. It's the parameter of output loss function - CHECK NUMBER 
yhat_d1 = (1-yhat_d0)/2/max(y);                     %this makes sure that: (1) the autarkic output is always increasing. (2) the autarkic output has a slope of zero and reaches a maximum at y(end). 
yhat = y - max(0, yhat_d0*y + yhat_d1*y.^2); 

%AUTARKY
%tradable output under autarky
yTa = repmat(yhat, [1 nd]);
cTa = yTa;                                          %consumption of tradables under autarky
ua = (a * cTa.^(1-sigg) + (1-a) * hbar.^(alfa*(1-sigg))-1)  / (1-sigg); %utility under autarky 

%Initialize the value functions
vc = zeros(ny,nd);                                  %continue repaying
vcnew = vc;
vg = zeros(ny,nd);                                  %good standing
vb = zeros(ny,nd);                                  %bad standing
vr =  zeros(ny,nd);                                 %reentry
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

eval(['save ' filename ])