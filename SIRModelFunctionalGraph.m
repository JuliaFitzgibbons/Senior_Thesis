function SIRModelFunctionalGraph()
%Initial Conditions and time span
global beta gamma

S0= 100;
I0= 1;
R0=0;
tmax = 400;

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
expForm = fittype('b*exp(r*x)');
expFit = fit(newt,yI(1:inflection_idx(1)), expForm,'StartPoint',[1,.1]);
coeffs = coeffvalues(expFit);
%get that exponential growth rate
r = coeffs(2);

%Plot SIR and exponential graph
% subplot(1,1,1);
% plot(t, y(:,2), newt, expFit(newt));
% title('SIR Model');
% legend('I(t)', 'I with exponential fit until first inflection point');
% xlabel('Time, t');
% ylabel('Population');


fprintf('%d is the R0 prospective value\n',exp(r));
fprintf('%d is the KM R0 value\n',beta*S0/gamma);
fprintf('%d is Heesterbeck paper general value\n',exp(r/gamma));
fprintf('%d is Heesterbeck paper small rTG value\n',1+(r/gamma));

%/////////////////////////////// variable  beta and gamma////////////////////////
%maxDiff = zeros(3,29); %First exp, then heesterbeek small, then heesterbeek large
%minDiff = 100*ones(3,29);
estimates = 100*ones(3,29);
count = 1;
for ChangingR0 = 1.2 :0.1:4.0
    beta = .005;
    gamma = beta/(ChangingR0 /100);
    [t,y] = ode45('systemofKM',[0 tmax],[S0; I0; R0]);
    yI = y(:,2);
    inflection_idx = find(diff(sign(gradient(gradient(yI)))));
    newt = t(1:inflection_idx(1));
    expForm = fittype('b*exp(r*x)');
    expFit = fit(newt,yI(1:inflection_idx(1)), expForm, 'StartPoint',[1,.1]);
    coeffs = coeffvalues(expFit);
    r = coeffs(2);
    
    estimates(1,count) = exp(r);
    estimates(2,count) =1+(r/gamma);
    estimates(3,count) = exp(r/gamma);
    count = count + 1;
    
%     subplot(2,1,1);
%     plot(t, y(:,2), newt, expFit(newt));
%     title('SIR Model');
%     legend('I(t)', 'I with exponential fit until first inflection point');
%     xlabel('Time, t');
%     ylabel('Population');
 
end

% Figure details
subplot(1,1,1);
plot(1.2 :0.1:4.0, 1.2 :0.1:4.0, 1.2 :0.1:4.0, estimates);
title('R0 vs Estimates');
legend('Perfect linear correspondance','e^{r}','1+(r/gamma)', 'e^{r/gamma}', 'Location','northwest');
xlabel('R0');
ylabel('R0 Estimates');

