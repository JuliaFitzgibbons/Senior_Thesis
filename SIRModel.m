function SIRModel()
%Initial Conditions and time span
global beta gamma

S0=100;
I0=5;
R0=0;
tmax = 30;
beta = 0.01;
gamma = 0.03;

[t,y] = ode45('systemofKM',[0 tmax],[S0; I0; R0]);

%Adding Gaussian distributed noise where the mean (mu) is 0 and the stdev is 1

mu=0;
sigma=1;
noise = sigma *randn(length(t),1)+mu;

noisevect= [ noise, noise,noise];


newy = noisevect + y;

expForm = fittype('a-b*exp(r*x)');
expFit = fit(t,newy(:,2), expForm, 'StartPoint',[1,1,1]);

coeffs = coeffvalues(expFit);
r = coeffs(3);


%Figure details
plot(t, y(:,2), t, newy(:,2), t, expFit(t));
title('SIR Model');
legend('I(t)', 'I with Noise', 'I exponential fit');
xlabel('time, t');
ylabel('Population');
