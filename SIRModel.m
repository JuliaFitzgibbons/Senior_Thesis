function SIRModel()
%Initial Conditions and time span
global beta gamma

S0= 100;
I0= 1;
R0=0;
tmax = 150;

%/////////////////////////////////INFLUENZA GRAPH/////////////////
beta = .0025; %.0025 influenza
gamma = 1/14; %1/14 influenza

%Solve SIR 
[t,y] = ode45('systemofKM',[0 tmax],[S0; I0; R0]);
yI = y(:,2);
%find inflection point
inflection_idx = find(diff(sign(gradient(gradient(yI)))));
newt = t(1:inflection_idx(1));
%Fit exponential to SIR up to inflection point
expForm = fittype('a+b*exp(r*x)');
expFit = fit(newt,yI(1:inflection_idx(1)), expForm,'StartPoint',[-1,1,.001]);
coeffs = coeffvalues(expFit);
%get that exponential growth rate
r = coeffs(3);

%Plot SIR and exponential graph
subplot(3,1,1);
plot(t, y(:,2), newt, expFit(newt));
title('SIR Model');
legend('I(t)', 'I with exponential fit until first inflection point');
xlabel('Time, t');
ylabel('Population');


fprintf('%d is the R0 prospective value\n',exp(r));
fprintf('%d is the KM R0 value\n',beta*S0/gamma);
fprintf('%d is Heesterbeck paper general value\n',exp(r/gamma));
fprintf('%d is Heesterbeck paper small rTG value\n',1+(r/gamma));

%/////////////////////////////// variable  beta and gamma////////////////////////
changingBetaAndGamma= zeros(3,98);
index = 1;
for i = .0001:0.00005:.005
    beta = i;
    gamma = beta/.015;
    [t,y] = ode45('systemofKM',[0 tmax],[S0; I0; R0]);
    yI = y(:,2);
    inflection_idx = find(diff(sign(gradient(gradient(yI)))));
    newt = t(1:inflection_idx(1));
    expForm = fittype('a-b*exp(r*x)');
    expFit = fit(newt,yI(1:inflection_idx(1)), expForm, 'StartPoint',[-1,1,.1]);
    coeffs = coeffvalues(expFit);
    r = coeffs(3);
    
    %fprintf('r estimated : %d\n',r);
    
    
    subplot(3,1,2);
    plot(t, y(:,2), newt, expFit(newt));
    title('SIR Model');
    legend('I(t)', 'I with exponential fit until first inflection point');
    xlabel('Time, t');
    ylabel('Population');
        
    changingBetaAndGamma(1,index)= exp(r); % e^r from the model
    changingBetaAndGamma(2,index)= beta*S0/gamma; %From Kermack-Mckendrick ???????
    changingBetaAndGamma(3,index)= exp(r/gamma); % from the Heesterbeek paper
    %changingBetaAndGamma(4,index)= 1+(r/gamma); %from the Heesterbeek paper, where r is exp growth and
    %TG is 1/beta by my calculation
    index = index + 1;
end

%Figure details
subplot(3,1,3);
%plot(.0001:0.0001:.01, [betachanging(2,:); betachanging(3,:)]);
plot(.0001:0.00005:.005, changingBetaAndGamma);
title('R0 values');
legend( 'Proposed R0','KM R0(constant 1.5)', 'Heesterbeek R0');
xlabel('Beta value');
ylabel('value');



