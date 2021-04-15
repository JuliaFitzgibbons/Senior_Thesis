function SIRModel()
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
subplot(4,1,1);
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
    maxDiff = zeros(3,29); %First exp, then heesterbeek small, then heesterbeek large
    minDiff = 100*ones(3,29);
    count = 1;
for ChangingR0 = 1.2 :0.1:4.0
    changingBetaAndGamma= zeros(4,90);
    index = 1;
    for i = .0005:0.00005:.005
        beta = i;
        gamma = beta/(ChangingR0 /100);
        [t,y] = ode45('systemofKM',[0 tmax],[S0; I0; R0]);
        yI = y(:,2);
        inflection_idx = find(diff(sign(gradient(gradient(yI)))));
        newt = t(1:inflection_idx(1));
        expForm = fittype('b*exp(r*x)');
        expFit = fit(newt,yI(1:inflection_idx(1)), expForm, 'StartPoint',[1,.1]);
        coeffs = coeffvalues(expFit);
        r = coeffs(2);

        %fprintf('r estimated : %d\n',r);


        subplot(4,1,2);
        plot(t, y(:,2), newt, expFit(newt));
        title('SIR Model');
        legend('I(t)', 'I(t) with exponential fit until first inflection point');
        xlabel('Time, t');
        ylabel('Population');

        changingBetaAndGamma(1,index)= exp(r); % e^r from the model
        changingBetaAndGamma(2,index)= beta*S0/gamma; %From Kermack-Mckendrick ???????
        changingBetaAndGamma(3,index)= exp(r/gamma); % from the Heesterbeek paper
        changingBetaAndGamma(4,index)= 1+(r/gamma); %from the Heesterbeek paper, where r is exp growth and
        %TG is 1/beta by my calculation
        

        if (maxDiff(1,count)< abs(exp(r) - ChangingR0))
            maxDiff(1,count) = abs(exp(r)- ChangingR0);
        end
        if (minDiff(1,count)> abs(exp(r)- ChangingR0))
            minDiff(1,count) = abs(exp(r)- ChangingR0);
        end
        
        if (maxDiff(2,count)< abs(1+(r/gamma) - ChangingR0))
            maxDiff(2,count) = abs(1+(r/gamma)- ChangingR0);
        end
        if (minDiff(2,count)> abs(1+(r/gamma)- ChangingR0))
            minDiff(2,count) = abs(1+(r/gamma)- ChangingR0);
        end
        if (maxDiff(3,count)< abs(exp(r/gamma) - ChangingR0))
            maxDiff(3,count) = abs(exp(r/gamma)- ChangingR0);
        end
        if (minDiff(3,count)> abs(exp(r/gamma)- ChangingR0))
            minDiff(3,count) = abs(exp(r/gamma)- ChangingR0);
        end
        
        index = index + 1;
    end
    count = count + 1;
end

%Figure details
subplot(4,1,3);
plot(1.2 :0.1:4.0, maxDiff);
title('Maximum Residuals');
legend( 'e^(r)','1+(r/gamma)', '1+e^(r/gamma)');
xlabel('R0');
ylabel('Residual from R0');

%Figure details
subplot(4,1,4);
plot(1.2 :0.1:2.0, minDiff);
title('Minimum Residuals');
legend( 'e^(r)','1+(r/gamma)', '1+e^(r/gamma)');
xlabel('R0');
ylabel('Residual from R0');

